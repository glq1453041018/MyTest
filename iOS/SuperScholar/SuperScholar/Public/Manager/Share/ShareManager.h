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
 直接分享——图文链接

 @param plateform 平台：qq、qzone、wechat、wechattimeline
 @param title 标题
 @param body 内容
 @param image 头像
 @param link 链接
 @param completion 结束回调
 @note 只传title表示纯文本分享
 */
+ (void)shareToPlatform:(SharePlatform)plateform title:(NSString *)title body:(NSString *)body  image:(UIImage *)image link:(NSString *)link withCompletion:(void (^)(OSMessage *message, NSError *error))completion;

/**
 直接分享——纯文本
 
 @param plateform 平台：qq、qzone、wechat、wechattimeline
 */
+ (void)shareToPlatform:(SharePlatform)plateform title:(NSString *)title withCompletion:(void (^)(OSMessage *message, NSError *error))completion;



/**
 弹窗分享——图文链接
 
 @param title 标题
 @param body 内容
 @param image 头像
 @param link  链接
 @param completion 结束回调
 @note 只传title表示纯文本分享
 */
+ (void)showShareViewWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image link:(NSString *)link withCompletion:(void (^)(OSMessage *message, NSError *error))completion;

/**
 弹窗分享——纯文本
 
 @param title 文本内容
 */
+ (void)showShareViewWithTitle:(NSString *)title withCompletion:(void (^)(OSMessage *message, NSError *error))completion;
@end
