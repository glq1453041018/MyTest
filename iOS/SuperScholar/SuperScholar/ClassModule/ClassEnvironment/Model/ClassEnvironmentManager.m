//
//  ClassEnvironmentManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassEnvironmentManager.h"

@implementation ClassEnvironmentManager

+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock{
    NSMutableArray *res = [NSMutableArray array];
    for (int i=0; i<100; i++) {
        ClassEnvironmentModel *cem = [ClassEnvironmentModel new];
        cem.picUrl = [TESTDATA randomUrlString];
        CGFloat width = getRandomNumberFromAtoB(100, 150);
        CGFloat height = getRandomNumberFromAtoB(50, 200);
        cem.size = CGSizeMake(width, height);
        [res addObject:cem];
    }
    if (responseBlock) {
        responseBlock(res,nil);
    }
}

@end
