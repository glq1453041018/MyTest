//
//  ClassInfoManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassInfoModel.h"

@interface ClassInfoManager : NSObject

// !!!: 获取数据
+(void)requestDataStyle:(InteractiveStyle)style response:(void(^)(NSArray *resArray,id error))responseBlock;

@end
