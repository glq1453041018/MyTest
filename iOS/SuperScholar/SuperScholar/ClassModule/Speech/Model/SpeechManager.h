//
//  SpeechManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/18.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechManager : NSObject

// !!!!: 上传动态内容
+(void)uploadMessageToServerWithMessage:(NSString*)message classId:(NSInteger)classId response:(void(^)(NSDictionary* res,id error))responseBlock;


// !!!!: 上传多媒体
+(void)uploadMediaToServerWithArticleId:(NSInteger)articleId classId:(NSInteger)classId images:(NSArray<UIImage*>*)images videos:(NSArray<NSData*>*)videos response:(void(^)(NSArray *resArray,id error))responseBlock;

@end
