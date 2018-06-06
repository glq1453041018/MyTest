//
//  ResetPasswordStep2ViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/6/6.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ResetPasswordStep2ViewController.h"

@interface ResetPasswordStep2ViewController ()

@end

@implementation ResetPasswordStep2ViewController

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


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    [self.navigationBar setTitle:@"" leftImage:@"public_left" rightText:nil];
    [self.navigationBar.letfBtn setTintColor:HexColor(0x333333)];
    [self.navigationBar.titleLabel setTextColor:HexColor(0x333333)];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    self.phoneBackView.layer.cornerRadius = self.phoneBackView.viewHeight / 2.0;
    self.phoneBackView.layer.borderWidth = 0.5;
    self.phoneBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.vertifycodeBackView.layer.cornerRadius = self.vertifycodeBackView.viewHeight / 2.0;
    self.vertifycodeBackView.layer.borderWidth = 0.5;
    self.vertifycodeBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.loginButton.layer.cornerRadius = self.loginButton.viewHeight / 2.0;

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

- (IBAction)textFieldEditingChanged:(UITextField *)textField{
//    if([self phoneIsValid:textField.text]){
//        self.nextButton.backgroundColor = HexColor(0xff5e5e);
//        self.nextButton.userInteractionEnabled = YES;
//    }else{
//        self.nextButton.backgroundColor = HexColor(0xf08080);
//        self.nextButton.userInteractionEnabled = NO;
//    }
}

#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickNextBtn:(id)sender {
    // !!!: 下一步按钮点击事件
    
}


#pragma mark - <************************** 私有方法 **************************>

- (BOOL)phoneIsValid:(NSString *)phone{
    //TODO: 手机号合法性匹配
    NSString *preidct = @"^1\\d{10}$";
    NSRange range = [phone rangeOfString:preidct options:NSRegularExpressionSearch];
    return range.location != NSNotFound;
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
