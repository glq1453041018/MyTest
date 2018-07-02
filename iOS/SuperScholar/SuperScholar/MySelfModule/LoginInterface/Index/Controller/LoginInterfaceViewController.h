//
//  LoginInterfaceViewController.h
//  MOBTest
//
//  Created by 伟南 陈 on 2018/3/15.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//《登陆页》

#import <UIKit/UIKit.h>

@interface LoginInterfaceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *phoneBackView;//手机号背景
@property (weak, nonatomic) IBOutlet UIView *vertifycodeBackView;//验证码背景
@property (weak, nonatomic) IBOutlet UIButton *loginButton;//登录按钮

@property (weak, nonatomic) IBOutlet UITextField *phoneField;//手机号输入框
@property (weak, nonatomic) IBOutlet UIButton *getVertifyBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *vertifyField;//验证码输入框

@property (weak, nonatomic) IBOutlet UILabel *phoneErrorLog;//手机号错误提示
@property (weak, nonatomic) IBOutlet UILabel *vertifyErrorLog;//验证码错误提示


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *vertifiLoginTip;//验证码登录提示(未注册手机验证后自动登录)
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;//找回密码按钮
@property (weak, nonatomic) IBOutlet UIView *findPasswordBtnLeftLine;//找回密码按钮左边线
@property (weak, nonatomic) IBOutlet UIView *getVertifyBtnLeftLine;//获取验证码按钮左边线



@end