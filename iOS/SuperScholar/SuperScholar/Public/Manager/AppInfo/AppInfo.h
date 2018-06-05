//
//  AppInfo.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/18.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface AppInfo : NSObject

+(instancetype)share;

/*
 用户信息
 */
@property (strong ,nonatomic) UserModel *user;
- (void)clearUserInfo;//清除用户信息

/*
 测试登录事件
 */
-(void)loginEventTestWithMobile:(NSString *)mobile password:(NSString *)password andCompletion:(void (^)())completion;
-(void)smsLoginEventTestWithMobile:(NSString *)mobile code:(NSString *)code completion:(void (^)())completion;

/*
 测试退出登录事件
 */
-(void)logoutEventTestWithCompletion:(void (^)())completion;



@end
