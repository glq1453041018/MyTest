//
//  ClassViewManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewManager.h"

@implementation ClassViewManager

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock{
    NSArray *titles = @[@"AI学堂-机器学习",@"大数据基础篇",@"算法分析",@"人工智能-AlphaGo",@"Python-爬虫进阶"];
    NSArray *icons = @[@"0",@"1",@"2",@"3",@"4"];
    NSMutableArray *resArray = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        ClassViewModel *cvm = [ClassViewModel new];
        cvm.title = titles[i];
        cvm.icon = icons[i];
        [resArray addObject:cvm];
    }
    if (responseBlock) {
        responseBlock(resArray,nil);
    }
}

@end
