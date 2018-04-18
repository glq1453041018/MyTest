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


-(void)loginEventTest{
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
        }
        else{
            NSAssert(NO, @"数据结构出错");
        }
        
    } failure:^(NSError *error) {
        NSAssert(NO, @"获取数据出错");
    }];
}


@end
