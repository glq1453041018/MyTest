//
//  ResetPasswordViewController.h
//  SuperScholar
//
//  Created by cwn on 2018/6/6.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *phoneBackView;//手机号背景
@property (weak, nonatomic) IBOutlet UIButton *nextButton;//下一步按钮

@property (weak, nonatomic) IBOutlet UITextField *phoneField;//手机号输入框


//传递参数
@property (strong, nonatomic) NSString *phoneNumber;//电话号码

@end
