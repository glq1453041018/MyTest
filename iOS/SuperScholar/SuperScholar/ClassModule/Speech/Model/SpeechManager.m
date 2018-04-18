//
//  SpeechManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/18.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "SpeechManager.h"

@implementation SpeechManager


// !!!!: 上传动态内容
+(void)uploadMessageToServerWithMessage:(NSString*)message classId:(NSInteger)classId response:(void (^)(NSDictionary *, id))responseBlock{
    NSString *url = C_UploadMessageUrlString;
    NSDictionary *dic = @{
                          @"content":message,
                          @"classId":@(classId)
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            NSDictionary *dic = [responseObject objectForKeyNotNull:@"data"];
            if (responseBlock) {
                responseBlock(dic,nil);
            }
        }
        else{
            if (responseBlock) {
                responseBlock(nil,@"上传失败");
            }
        }
        
    } failure:^(NSError *error) {
        if (responseBlock) {
            responseBlock(nil,@"上传失败");
        }
    }];
}

// !!!!: 上传多媒体
+(void)uploadMediaToServerWithArticleId:(NSInteger)articleId classId:(NSInteger)classId images:(NSArray *)images videos:(NSArray *)videos response:(void (^)(NSArray *, id))responseBlock{
    NSString *url = C_UplodMediaInfoUrlString;
    NSDictionary *dic = @{
                          @"articleId":@(articleId),
                          @"classId":@(classId)
                          };
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:dic type:Post images:images videosArray:videos uploadProgress:^(NSProgress *uploadPro) {
        DLog(@"%@",[NSString stringWithFormat:@"当前已经上传：%.1f%%", ((NSProgress *)uploadPro).fractionCompleted*100]);
    } success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            NSArray *images = [responseObject objectForKeyNotNull:@"data"];
            if (responseBlock) {
                responseBlock(images,nil);
            }
        }
        else{
            if (responseBlock) {
                responseBlock(nil,@"上传失败");
            }
        }
        
    } failure:^(NSError *error) {
        if (responseBlock) {
            responseBlock(nil,@"上传失败");
        }
    }];
}


@end
