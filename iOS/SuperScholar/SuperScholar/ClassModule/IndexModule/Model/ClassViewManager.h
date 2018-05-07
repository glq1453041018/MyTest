//
//  ClassViewManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassViewCollectionViewCell.h"
#import "ClassViewModel.h"

@interface ClassViewManager : NSObject

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray <ClassViewModel*>* resArray,id error))responseBlock;

+(void)loadCell:(ClassViewCollectionViewCell*)cell model:(ClassViewModel*)model;

@end
