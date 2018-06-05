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


-(void)loginEventTestWithCompletion:(void (^)())completion{
    NSString *url = U_LoginUrlString;
    NSDictionary *dic = @{
                          @"mobile":@"15059421608",
                          @"password":@"123456"
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

@end
