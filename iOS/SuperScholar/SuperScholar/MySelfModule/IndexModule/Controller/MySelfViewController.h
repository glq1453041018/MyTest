//
//  MySelfViewController.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySelfViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *didLoginView;//已登录视图
@property (weak, nonatomic) IBOutlet UIButton *loginButtton;//短信登录按钮
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//高斯模糊背景图
@end
