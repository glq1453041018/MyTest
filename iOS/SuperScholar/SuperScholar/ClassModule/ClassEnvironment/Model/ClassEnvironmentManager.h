//
//  ClassEnvironmentManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassEnvironmentModel.h"

@interface ClassEnvironmentManager : NSObject

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;

@end
