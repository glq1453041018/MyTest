//
//  SMSManager.m
//  MOBTest
//
//  Created by 伟南 陈 on 2018/3/15.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import "SMSManager.h"

@implementation SMSManager
+ (void)getVerificationCodeByMethod:(SMSGetCodeMethod)method phoneNumber:(NSString *)phoneNumber result:(void(^)(NSError *error))result{
    [SMSSDK getVerificationCodeByMethod:method phoneNumber:phoneNumber zone:@"86"  result:^(NSError *error) {
        if (!error)
        {
            // 请求成功
            if(result)
                result(nil);
        }
        else
        {
            // error
            if(result)
                result(error);
        }
    }];
}


+(void)commitVerificationCode:(NSString *)code phoneNumber:(NSString *)phoneNumber result:(void(^)(NSError *error))result{
    [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
        if (!error)
        {
            // 请求成功
            if(result)
                result(nil);
        }
        else
        {
            // error
            if(result)
                result(error);
        }
    }];
}
@end
