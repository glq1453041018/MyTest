//
//  ClassSapceManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassSpaceModel.h"

@interface ClassSpaceManager : NSObject




// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;

+(void)addPicsWithModel:(ClassSpaceModel*)csm;

+(void)removePicsWithModel:(ClassSpaceModel*)csm;

@end
