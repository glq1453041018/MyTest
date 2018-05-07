//
//  AFService.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AFService.h"

@implementation AFService

#pragma mark - 纯文本

-(void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(HttpRequestType)type success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    if(![self requestBeforeCheckNetWork]){
        NSError *error = [NSError errorWithDomain:NSURLErrorKey code:-1000 userInfo:@{@"error":@"没有网络"}];
        failure(error);
        return;
    }
    
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _manager.requestSerializer.timeoutInterval = 10;
    _manager.operationQueue.maxConcurrentOperationCount = 10;
    
    // 添加 userid 和 uuid 两种必要参数
    if ([AppInfo share].user) {
        NSMutableDictionary *dic = nil;
        if (parameters) {
            dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        }else{
            dic = [NSMutableDictionary dictionary];
        }
        NSString *uuid = [AppInfo share].user.uuid;
        NSInteger userId = [AppInfo share].user.userId;
        [dic setValue:uuid.length?uuid:@"" forKey:@"uuid"];
        [dic setValue:@(userId) forKey:@"userId"];
        parameters = dic;
    }
    
    // 拼接地址
    if (parameters) {
        NSString *urlStringTmp = URLString;
        for (NSString *key in parameters) {
            NSString*value = parameters[key];
            NSString* item = [NSString stringWithFormat:@"&%@=%@",key,value];
            urlStringTmp = [urlStringTmp stringByAppendingString:item];
        }
        DLog(@"LLLLLLLL数据地址：%@",urlStringTmp);
    }else{
        DLog(@"LLLLLLLL数据地址：%@",URLString);
    }
    
    switch (type) {
        case Get:
        {
            _MyTask = [_manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                if (success) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    success(dic);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    failure(error);
                }
            }];
        }
            
            break;
            
        default:
            
        {
            _MyTask = [_manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                if (success) {
                    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    success(dic);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if (failure) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    failure(error);
                }
                
            }];
        }
            
            break;
    }
    
    
}


#pragma mark - 带图片或者视频
-(void)requestWithURLString:(NSString *)URLString parameters:(id)parameters type:(HttpRequestType)type images:(NSArray *)imgsArray videosArray:(NSArray *)videosArray uploadProgress:(void (^)(NSProgress *))uploadPro success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    if(![self requestBeforeCheckNetWork]){
        NSError *error = [NSError errorWithDomain:NSURLErrorKey code:-1000 userInfo:@{@"error":@"没有网络"}];
        failure(error);
        return;
    }
    
    _manager = [AFHTTPSessionManager manager];
    _manager.requestSerializer.timeoutInterval = 20;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    // 添加 userid 和 uuid 两种必要参数
    if ([AppInfo share].user) {
        NSMutableDictionary *dic = nil;
        if (parameters) {
            dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
        }else{
            dic = [NSMutableDictionary dictionary];
        }
        NSString *uuid = [AppInfo share].user.uuid;
        NSInteger userId = [AppInfo share].user.userId;
        [dic setValue:uuid.length?uuid:@"" forKey:@"uuid"];
        [dic setValue:@(userId) forKey:@"userId"];
        parameters = dic;
    }
    
    // 拼接地址
    if (parameters) {
        NSString *urlStringTmp = URLString;
        for (NSString *key in parameters) {
            NSString*value = parameters[key];
            NSString* item = [NSString stringWithFormat:@"&%@=%@",key,value];
            urlStringTmp = [urlStringTmp stringByAppendingString:item];
        }
        DLog(@"LLLLLLLL数据地址：%@",urlStringTmp);
    }else{
        DLog(@"LLLLLLLL数据地址：%@",URLString);
    }
    
    _MyTask = [_manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //图片
        if (imgsArray.count) {
            
            for (int i=0; i<imgsArray.count; i++) {
                
                UIImage *image = imgsArray[i];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg",dateString];
                
                //media为服务器文件夹
                [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                
            }
        }
        
        //视频
        if (videosArray.count) {

            for (int i = 0; i < videosArray.count; i++) {

                NSData *data=[videosArray objectAtIndex:i];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
                
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                
                NSString *fileName = [NSString  stringWithFormat:@"%@.MOV", dateString];
                
                [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"media"];
            }
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            uploadPro(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
    
}


#pragma mark - 取消网络任务
-(void)cancelRequest{
    [_MyTask cancel];
}

#pragma mark  请求前统一处理：如果是没有网络，则不论是GET请求还是POST请求，均无需继续处理
- (BOOL)requestBeforeCheckNetWork {
    
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable  =(isReachable && !needsConnection) ? YES : NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible =isNetworkEnable;/*  网络指示器的状态： 有网络 ： 开  没有网络： 关  */
    });
    return isNetworkEnable;
}


@end
