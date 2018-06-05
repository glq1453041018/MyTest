//
//  AppAPI.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#ifndef AppAPI_h
#define AppAPI_h


/*
 此文件放置应用接口信息
 */


#pragma mark - <************************** 用户 **************************>
#define U_LoginUrlString YuMingAnd(@"/mobile/user/login?")      // 用户登录
#define U_LogoutUrlString YuMingAnd(@"/mobile/user/out")    //退出登录
#define U_SmsLoginUrlString YuMingAnd(@"/public/user/smsLogin")    //短信登录



#pragma mark - <************************** 班级 **************************>
#define C_ClassListInfoUrlString YuMingAnd(@"/mobile/user/class?")      // 班级列表信息
#define C_UplodMediaInfoUrlString YuMingAnd(@"/mobile/classStatus/imageAdd?")       // 上传班级动态图片
#define C_UploadMessageUrlString YuMingAnd(@"/mobile/article/add?")     // 上传班级动态消息



#endif /* AppAPI_h */
