//
//  ResetPasswordStep2ViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/6/6.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ResetPasswordStep2ViewController.h"
#import "SMSManager.h"

@interface ResetPasswordStep2ViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) dispatch_source_t timer;//定时器
@property (assign, nonatomic) CGFloat second;//秒
@end

@implementation ResetPasswordStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    [self.navigationBar setTitle:@"" leftImage:@"public_left" rightText:nil];
    [self.navigationBar.letfBtn setTintColor:HexColor(0x333333)];
    [self.navigationBar.titleLabel setTextColor:HexColor(0x333333)];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.passwordBackView.layer.cornerRadius = self.passwordBackView.viewHeight / 2.0;
    self.passwordBackView.layer.borderWidth = 0.5;
    self.passwordBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.vertifycodeBackView.layer.cornerRadius = self.vertifycodeBackView.viewHeight / 2.0;
    self.vertifycodeBackView.layer.borderWidth = 0.5;
    self.vertifycodeBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    self.loginButton.layer.cornerRadius = self.loginButton.viewHeight / 2.0;
    self.loginButton.userInteractionEnabled = NO;

   [self startTimeAlarmClock];//开始倒计时

}


#pragma mark - <*********************** 初始化控件/数据 **********************>


#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
// !!!: 返回
-(void)navigationViewLeftClickEvent{
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if([self vertifyCodeIsValid:textField.text]){
        self.vertifyErrorLog.hidden = NO;
        [self shackView:self.vertifyErrorLog];
    }else{
        self.vertifyErrorLog.hidden = YES;
    }
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)textField{
    if([self vertifyCodeIsValid:self.vertifyField.text] && [self passwordIsValid:self.passwordField.text]){
        self.loginButton.backgroundColor = HexColor(0xff5e5e);
        self.loginButton.userInteractionEnabled = YES;
    }else{
        self.loginButton.backgroundColor = HexColor(0xf08080);
        self.loginButton.userInteractionEnabled = NO;
    }
}

#pragma mark - <************************** 点击事件 **************************>

- (IBAction)onClickGetVertifyCode:(UIButton *)sender {
    // !!!: 发送验证码
    if(sender.enabled == YES && [self vertifyCodeIsValid:self.vertifyField.text]){
        //发送验证码
        // !!!: 获取验证码请求
        //    WeakObj(self);
        [SMSManager getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNumber result:^(NSError *error) {
            if(!error){
                NSLog(@"获取验证码成功！");
            }
        }];
        
        [self startTimeAlarmClock];
    }
}

- (void)startTimeAlarmClock{
    self.getVertifyBtn.enabled = NO;
    self.second = 60;
    [self.getVertifyBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.getVertifyBtn setTitle:[NSString stringWithFormat:@"重新发送(%.0fS)", self.second] forState:UIControlStateNormal];
    
    //开始倒计时
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        self.second --;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.getVertifyBtn setTitle:[NSString stringWithFormat:@"重新发送(%.0fS)", self.second] forState:UIControlStateNormal];
        [CATransaction commit];
        //倒计时结束
        if(self.second == 0){
            self.getVertifyBtn.enabled = YES;
            [self.getVertifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [self.getVertifyBtn setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
            dispatch_cancel(self.timer);
        }
    });
    dispatch_resume(self.timer);
}

- (IBAction)onClickCommitBtn:(UIButton *)sender {
    // !!!: 提交按钮点击事件
    
    //提交验证码请求
    WeakObj(self);
    [SMSManager commitVerificationCode:self.vertifyField.text phoneNumber:self.phoneNumber result:^(NSError *error) {
        //        dispatch_cancel(weakself.timer);
        if(!error){
            // 登录事件
            //调重置密码的接口
            [[AppInfo share] resetPasswordWithMobile:self.phoneNumber password:self.passwordField.text code:self.vertifyField.text withCompletion:^{
                [self.navigationController dismissViewControllerAnimated:NO completion:^(){
                    [LLAlertView showSystemAlertViewMessage:@"密码重置成功，登录成功" buttonTitles:@[@"确定"] clickBlock:nil];
                }];
            }];
        }else{//验证码错误
            weakself.vertifyErrorLog.text = @"验证码错误";
            weakself.vertifyErrorLog.hidden = NO;
            weakself.vertifycodeBackView.layer.borderColor = HexColor(0xff5e5e).CGColor;
            [weakself shackView:weakself.vertifyErrorLog];
        }
    }];

}


#pragma mark - <************************** 私有方法 **************************>

- (BOOL)passwordIsValid:(NSString *)phone{
    //TODO: 新密码合法性匹配
    NSString *preidct = @"^(\\d|[a-zA-Z]){6,20}$";
    NSRange range = [phone rangeOfString:preidct options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (BOOL)vertifyCodeIsValid:(NSString *)code{
    //TODO: 验证码合法性匹配
    NSString *preidct = @"^\\d{4}$";
    NSRange range = [code rangeOfString:preidct options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (void)shackView:(UIView *)view{
    //TODO: 摇晃视图
    CABasicAnimation *shack = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D trans = CATransform3DMakeTranslation(10, 0, 0);
    shack.duration = 0.09;
    shack.toValue = [NSValue valueWithCATransform3D:trans];
    shack.removedOnCompletion = YES;
    shack.repeatCount = 3;
    shack.autoreverses = YES;
    shack.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:shack forKey:@"fdsa"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
