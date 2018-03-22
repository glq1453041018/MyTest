//
//  ShareManager.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenShare/OpenShare+Weixin.h>
#import <OpenShare/OpenShare+QQ.h>

@interface ShareManager : NSObject
+ (void)applicationDidFinishLaunching;
+ (BOOL)applicationOpenURL:(NSURL *)url;

/**
 分享qq朋友

 @param msgs 待分享消息
 @param completion 分享消息回调
 */
+ (void)shareToQQToFriend:(NSString *)msgs withCompletion:(void(^)(OSMessage *message, NSError *error))completion;

/**
 分享qq空间

 @param msgs 待分享消息
 @param completion 分享消息回调
 */
+ (void)shareToQQToSpace:(NSString *)msgs withCompletion:(void(^)(OSMessage *message, NSError *error))completion;

/**
 分享微信朋友
 
 @param msgs 待分享消息
 @param completion 分享消息回调
 */
+ (void)shareToWeChatToFriend:(NSString *)msgs withCompletion:(void(^)(OSMessage *message, NSError *error))completion;

/**
 分享微信朋友圈

 @param msgs 待分享消息
 @param completion 分享消息回调
 */
+ (void)shareToWeChatToSpace:(NSString *)msgs withCompletion:(void (^)(OSMessage *message, NSError *error))completion;
@end
