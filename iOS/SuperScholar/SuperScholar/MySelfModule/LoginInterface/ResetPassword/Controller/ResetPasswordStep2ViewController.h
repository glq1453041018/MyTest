//
//  ResetPasswordStep2ViewController.h
//  SuperScholar
//
//  Created by cwn on 2018/6/6.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordStep2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *phoneBackView;//手机号背景
@property (weak, nonatomic) IBOutlet UIView *vertifycodeBackView;//验证码背景

@property (weak, nonatomic) IBOutlet UITextField *phoneField;//手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *vertifyField;//验证码输入框

@property (weak, nonatomic) IBOutlet UIButton *getVertifyBtn;//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;//登录按钮


@end
