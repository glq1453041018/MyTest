//
//  ShareManager.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ShareManager.h"
#import "OpenShareHeader.h"


@implementation ShareManager
+ (void)applicationDidFinishLaunching{
    //全局注册appId，别忘了#import "OpenShareHeader.h"
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f" miniAppId:@"gh_d43f693ca31f"];
    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
}
+ (BOOL)applicationOpenURL:(NSURL *)url{
    if([OpenShare handleOpenURL:url]){
        return YES;
    }
    return NO;
}
+ (void)shareToPlatform:(SharePlatform)plateform link:(NSString *)link title:(NSString *)title body:(NSString *)body withCompletion:(void (^)(OSMessage *, NSError *))completion{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=title ? title : @"";
    msg.desc = body ? body : @"";
    msg.link = link ? link : @"";
    msg.image = kPlaceholderHeadImage;
    msg.multimediaType = OSMultimediaTypeUndefined;
    msg.thumbnail = kPlaceholderImage;
    
    switch (plateform) {
        case SharePlatformQQ:{
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformQZone:{
            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformWeChat:{
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformWeChatTimeline:{
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        default:
            break;
    }
}
@end
