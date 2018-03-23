//
//  ShareManager.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  "OpenShare+Weixin.h"
#import "OpenShare+QQ.h"

typedef NS_ENUM(NSUInteger, SharePlatform) {
    SharePlatformQQ,//qq
    SharePlatformQZone,//qq空间
    SharePlatformWeChat,//微信
    SharePlatformWeChatTimeline//微信朋友圈
};

@interface ShareManager : NSObject
+ (void)applicationDidFinishLaunching;
+ (BOOL)applicationOpenURL:(NSURL *)url;

/**
 分享

 @param plateform 平台：qq、qzone、wechat、wechattimeline
 @param title 标题
 @param body 内容
 @param link 链接
 @param completion 结束回调
 */
+ (void)shareToPlatform:(SharePlatform)plateform link:(NSString *)link title:(NSString *)title body:(NSString *)body withCompletion:(void (^)(OSMessage *message, NSError *body))completion;
@end
