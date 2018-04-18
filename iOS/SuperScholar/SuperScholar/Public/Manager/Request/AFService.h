//
//  AFService.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

@interface AFService : NSObject

typedef NS_ENUM(NSUInteger,HttpRequestType){
    Get = 0,
    Post
};

@property(strong,nonatomic)AFHTTPSessionManager *manager;
@property(strong,nonatomic)NSURLSessionDataTask *MyTask;

#pragma mark - 纯文本
- (void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(HttpRequestType)type success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;

#pragma mark - 带图片或者视频
-(void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(HttpRequestType)type images:(NSArray*)imgsArray videosArray:(NSArray*)videosArray uploadProgress:(void(^)(NSProgress * uploadPro))uploadPro success:(void (^)(NSDictionary* responseObject))success failure:(void (^)(NSError* error))failure;

#pragma mark - 取消网络任务
-(void)cancelRequest;


@end
