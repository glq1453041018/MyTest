//
//  AppInfo.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/18.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+(instancetype)share{
    static AppInfo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AppInfo new];
    });
    return instance;
}


-(UserModel *)user{
    if (_user==nil) {
        NSDictionary *dic = GetInfoForKey(UserInfo_NSUserDefaults);
        _user = [UserModel objectWithModuleDic:dic hintDic:nil];
    }
    return _user;
}

- (void)clearUserInfo{
    UserDefaultRemoveObjectForKey(UserInfo_NSUserDefaults);
}


-(void)loginEventTestWithMobile:(NSString *)mobile password:(NSString *)password andCompletion:(void (^)())completion{
    NSString *url = U_LoginUrlString;
//    NSDictionary *dic = @{
//                          @"mobile":@"15059421608",
//                          @"password":@"123456"
//                          };
    mobile = mobile ? mobile : @"";
    password = password ? password : @"";
    NSDictionary *dic = @{
                          @"mobile":mobile,
                          @"password":password
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            NSMutableDictionary *dic = [responseObject objectForKeyNotNull:@"data"];
            NSString *uuid = [responseObject objectForKeyNotNull:@"uuid"];
            [dic setValue:uuid.length?uuid:@"" forKey:@"uuid"];
            // 将用户信息保存到本地
            SaveInfoForKey(dic.copy, UserInfo_NSUserDefaults);
            self.user = [UserModel objectWithModuleDic:dic hintDic:nil];
            if(completion)
                completion();
        }
        else{
            [LLAlertView showSystemAlertViewMessage:[NSString stringWithFormat:@"%@ 可以试试 \n账号:%@ 密码:%@", [responseObject objectForKeyNotNull:@"msg"], @"15059421608", @"123456"] buttonTitles:@[@"确定"] clickBlock:nil];
        }
    } failure:^(NSError *error) {
        [LLAlertView showSystemAlertViewMessage:error.localizedDescription buttonTitles:@[@"确定"] clickBlock:nil];
    }];
}

-(void)smsLoginEventTestWithMobile:(NSString *)mobile code:(NSString *)code completion:(void (^)())completion{
    NSString *url = U_SmsLoginUrlString;
    
    mobile = mobile ? mobile : @"";
    code = code ? code : @"";
    NSDictionary *dic = @{
                          @"mobile":mobile,
                          @"code":code
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            NSMutableDictionary *dic = [responseObject objectForKeyNotNull:@"data"];
            NSString *uuid = [responseObject objectForKeyNotNull:@"uuid"];
            [dic setValue:uuid.length?uuid:@"" forKey:@"uuid"];
            // 将用户信息保存到本地
            SaveInfoForKey(dic, UserInfo_NSUserDefaults);
            self.user = [UserModel objectWithModuleDic:dic hintDic:nil];
            if(completion)
                completion();
        }
        else{
            [LLAlertView showSystemAlertViewMessage:[responseObject objectForKeyNotNull:@"msg"] buttonTitles:@[@"确定"] clickBlock:nil];
        }
        
    } failure:^(NSError *error) {
        [LLAlertView showSystemAlertViewMessage:error.localizedDescription buttonTitles:@[@"确定"] clickBlock:nil];
    }];
}


- (void)logoutEventTestWithCompletion:(void(^)())completion{
    NSString *url = U_LogoutUrlString;
    NSDictionary *dic = @{
                          @"userId":@(self.user.userId),
                          @"uuid":self.user.uuid ? self.user.uuid : @""
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            // 将用户信息保存到本地
            SaveInfoForKey(nil, UserInfo_NSUserDefaults);
            self.user = nil;
            if(completion)
                completion();
        }
        else{
            [LLAlertView showSystemAlertViewMessage:[responseObject objectForKeyNotNull:@"msg"] buttonTitles:@[@"确定"] clickBlock:nil];
        }
        
    } failure:^(NSError *error) {
        [LLAlertView showSystemAlertViewMessage:error.localizedDescription buttonTitles:@[@"确定"] clickBlock:nil];
    }];
}

- (void)resetPasswordWithMobile:(NSString *)mobile password:(NSString *)password code:(NSString *)code withCompletion:(void(^)())completion{
    mobile = mobile ? mobile : @"";
    password = password ? password : @"";
    code = code ? code : @"";
    
    NSString *url = U_ResetPasswordUrlString;
    NSDictionary *dic = @{
                          @"userId":@(self.user.userId),
                          @"uuid":self.user.uuid ? self.user.uuid : @"",
                          @"mobile":mobile,
                          @"password":password,
                          @"code":code
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            // 将用户信息保存到本地
            SaveInfoForKey(nil, UserInfo_NSUserDefaults);
            self.user = nil;
            if(completion)
                completion();
        }
        else{
            [LLAlertView showSystemAlertViewMessage:[responseObject objectForKeyNotNull:@"msg"] buttonTitles:@[@"确定"] clickBlock:nil];
        }
        
    } failure:^(NSError *error) {
        [LLAlertView showSystemAlertViewMessage:error.localizedDescription buttonTitles:@[@"确定"] clickBlock:nil];
    }];
}

@end
