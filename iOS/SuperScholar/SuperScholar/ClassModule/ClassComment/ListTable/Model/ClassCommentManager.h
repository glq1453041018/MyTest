//
//  ClassCommentManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassCommentModel.h"

@interface ClassCommentManager : NSObject

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;

+(void)addPicsWithModel:(ClassCommentModel*)csm;

+(void)removePicsWithModel:(ClassCommentModel*)csm;

@end
