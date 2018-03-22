//
//  ShareManager.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ShareManager.h"
#import <OpenShareHeader.h>


@implementation ShareManager
+ (void)applicationDidFinishLaunching{
    //全局注册appId，别忘了#import "OpenShareHeader.h"
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
}
+ (BOOL)applicationOpenURL:(NSURL *)url{
    if([OpenShare handleOpenURL:url]){
        return YES;
    }
    return NO;
}
+ (void)shareToQQToFriend:(NSString *)msgs withCompletion:(void(^)(OSMessage *message, NSError *error))completion{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=msgs;
    [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
        if(completion)
            completion(message, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        if(completion)
            completion(message, error);
    }];
}
+ (void)shareToQQToSpace:(NSString *)msgs withCompletion:(void (^)(OSMessage *, NSError *))completion{
    [OpenShare QQAuth:@"get_user_info" Success:^(NSDictionary *message) {
//        ULog(@"QQ登录成功\n%@",message);
    } Fail:^(NSDictionary *message, NSError *error) {
//        ULog(@"QQ登录失败\n%@\n%@",error,message);
    }];

    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=msgs;
    [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
        if(completion)
            completion(message, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        if(completion)
            completion(message, error);
    }];
}
+ (void)shareToWeChatToFriend:(NSString *)msgs withCompletion:(void (^)(OSMessage *, NSError *))completion{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=msgs;
    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
        if(completion)
            completion(message, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        if(completion)
            completion(message, error);
    }];
}
+ (void)shareToWeChatToSpace:(NSString *)msgs withCompletion:(void (^)(OSMessage *, NSError *))completion{
    OSMessage *msg=[[OSMessage alloc] init];
    msg.title=msgs;
    [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
        if(completion)
            completion(message, nil);
    } Fail:^(OSMessage *message, NSError *error) {
        if(completion)
            completion(message, error);
    }];
}
@end
