//
//  SMSManager.h
//  MOBTest
//
//  Created by 伟南 陈 on 2018/3/15.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SMS_SDK/SMSSDK.h>

@interface SMSManager : NSObject
//获取短信验证码
+ (void)getVerificationCodeByMethod:(SMSGetCodeMethod)method phoneNumber:(NSString *)phoneNumber result:(void(^)(NSError *error))result;
//验证验证码
+(void)commitVerificationCode:(NSString *)code phoneNumber:(NSString *)phoneNumber result:(void(^)(NSError *error))result;
@end
