//
//  ClassSapceManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassSapceModel.h"

@interface ClassSapceManager : NSObject




// !!!: 获取数据
+(void)requestDataStyle:(InteractiveStyle)style response:(void(^)(NSArray *resArray,id error))responseBlock;

+(void)addPicsWithModel:(ClassSapceModel*)csm;

+(void)removePicsWithModel:(ClassSapceModel*)csm;

@end
