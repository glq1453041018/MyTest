//
//  RemotePushManager.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/11/23.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemotePushManager : NSObject

//远程推送管理，处理远程推送消息接收事件
+ (instancetype)defaultManager;

/**
 处理远程推送消息

 @param userInfo 消息模型
 */
- (void)handleRemoteMessage:(id)userInfo;

/**
 将远程推送的json信息转为数据模型

 @param jsonStr json字典
 @return 消息模型
 */
- (id)changeSocketJsonInfoInToSocketModel:(NSDictionary *)jsonStr;


/** 阿里推送绑定、解绑账号 */
- (void)bindAccountToAliPushServer;
- (void)unBindAccountToAliPushServer;
- (void)setBadgeNumberToAliPushServer:(NSInteger)number;


@end
