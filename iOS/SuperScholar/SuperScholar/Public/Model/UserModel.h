//
//  UserModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/18.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+InitData.h"

@interface UserModel : NSObject
 
/*
 头像
 */
@property (copy ,nonatomic) NSString *img;
/*
 地址
 */
@property (copy ,nonatomic) NSString *address;
/*
 性别
 */
@property (copy ,nonatomic) NSString *gender;
/*
 用户名称
 */
@property (copy ,nonatomic) NSString *useName;
/*
 用户Id
 */
@property (assign ,nonatomic) NSInteger userId;
/*
 账号
 */
@property (copy ,nonatomic) NSString *account;
/*
 个人简介
 */
@property (copy ,nonatomic) NSString *desc;
/*
 uuid
 */
@property (copy ,nonatomic) NSString *uuid;


@end
