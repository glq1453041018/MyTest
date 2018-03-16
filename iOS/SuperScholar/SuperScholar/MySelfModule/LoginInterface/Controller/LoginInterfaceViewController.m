//
//  LoginInterfaceViewController.m
//  MOBTest
//
//  Created by 伟南 陈 on 2018/3/15.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import "LoginInterfaceViewController.h"
#import "SMSManager.h"

@interface LoginInterfaceViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) dispatch_source_t timer;//定时器
@property (assign, nonatomic) CGFloat second;//秒
@end

@implementation LoginInterfaceViewController

#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}

- (void)getVertifyCodeFromServer{
    // !!!: 获取验证码请求
//    WeakObj(self);
    [SMSManager getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text result:^(NSError *error) {
        if(error){
            NSLog(@"获取验证码成功！");
        }
    }];
}

- (void)commitVertifyCode{
    // !!!: 提交验证码请求
//    WeakObj(self);
    [SMSManager commitVerificationCode:self.vertifyField.text phoneNumber:self.phoneField.text result:^(NSError *error) {
//        dispatch_cancel(weakself.timer);
        if(!error){
            NSLog(@"登录成功!");
            SaveInfoForKey(@"abcdefg", UserId_NSUserDefaults);
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{//验证码错误
            self.vertifyErrorLog.text = @"验证码错误";
            self.vertifyErrorLog.hidden = NO;
            self.vertifycodeBackView.layer.borderColor = HexColor(0xff5e5e).CGColor;
            [self shackView:self.vertifyErrorLog];
        }
    }];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipTriggerd)];
    gesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:gesture];
    
    self.phoneBackView.layer.cornerRadius = self.phoneBackView.viewHeight / 2.0;
    self.phoneBackView.layer.borderWidth = 0.5;
    self.phoneBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.vertifycodeBackView.layer.cornerRadius = self.vertifycodeBackView.viewHeight / 2.0;
    self.vertifycodeBackView.layer.borderWidth = 0.5;
    self.vertifycodeBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.loginButton.layer.cornerRadius = self.loginButton.viewHeight / 2.0;
    
    [self.phoneField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.vertifyField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>




#pragma mark - <************************** 代理方法 **************************>

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self showErrorFieldIfNeed:textField];
    return YES;
}

- (IBAction)textFieldEditingChanged:(UITextField *)textField{
    if(textField == self.phoneField && [self phoneIsValid:textField.text]){
        [self showErrorFieldIfNeed:textField];
    }else if(textField == self.vertifyField && [self vertifyCodeIsValid:textField.text]){
        [self showErrorFieldIfNeed:textField];
    }
    
    if([self phoneIsValid:self.phoneField.text] && [self vertifyCodeIsValid:self.vertifyField.text]){
        self.loginButton.backgroundColor = HexColor(0xff5e5e);
    }else{
        self.loginButton.backgroundColor = HexColor(0xf08080);
    }
}



#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickCloseBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSwipTriggerd{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBackViewClicked{
    [self.view endEditing:YES];
}

- (IBAction)onClickGetVertifyCode:(UIButton *)sender {
    // !!!: 发送验证码
    [self showErrorFieldIfNeed:self.phoneField];
    if(sender.enabled == YES && [self phoneIsValid:self.phoneField.text]){
        sender.enabled = NO;
        self.second = 60;
        [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [sender setTitle:[NSString stringWithFormat:@"重新发送(%.0fS)", self.second] forState:UIControlStateNormal];
        //发送验证码
        [self getVertifyCodeFromServer];
        
        //开始倒计时
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            self.second --;
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
                [sender setTitle:[NSString stringWithFormat:@"重新发送(%.0fS)", self.second] forState:UIControlStateNormal];
            [CATransaction commit];
            //倒计时结束
            if(self.second == 0){
                sender.enabled = YES;
                [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                [sender setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
                dispatch_cancel(self.timer);
            }
        });
        dispatch_resume(self.timer);
    }
}

- (IBAction)onClickLoginBtn:(UIButton *)sender {
    // !!!: 登录事件
    if([self phoneIsValid:self.phoneField.text] && [self vertifyCodeIsValid:self.vertifyField.text])
        [self commitVertifyCode];
}

#pragma mark - <************************** 其他方法 **************************>

- (BOOL)phoneIsValid:(NSString *)phone{
    //TODO: 手机号合法性匹配
    NSString *preidct = @"^1\\d{10}$";
    NSRange range = [phone rangeOfString:preidct options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (BOOL)vertifyCodeIsValid:(NSString *)code{
    //TODO: 验证码合法性匹配
    NSString *preidct = @"^\\d{4}$";
    NSRange range = [code rangeOfString:preidct options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
}

- (void)showErrorFieldIfNeed:(UITextField *)textField{
    //TODO: 输入不合法UI提示
    if(textField == self.phoneField){
        if(![self phoneIsValid:textField.text]){
            self.phoneErrorLog.text = @"手机号错误";
            self.phoneErrorLog.hidden = NO;
            self.phoneBackView.layer.borderColor = HexColor(0xff5e5e).CGColor;
            [self shackView:self.phoneErrorLog];
        }else{
            self.phoneErrorLog.hidden = YES;
            self.phoneBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }else{
        if(![self vertifyCodeIsValid:textField.text] && [textField.text length]){
            self.vertifyErrorLog.text = @"验证码错误";
            self.vertifyErrorLog.hidden = NO;
            self.vertifycodeBackView.layer.borderColor = HexColor(0xff5e5e).CGColor;
            [self shackView:self.vertifyErrorLog];
        }else{
            self.vertifyErrorLog.hidden = YES;
            self.vertifycodeBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
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


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
