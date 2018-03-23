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
    NSMutableArray *icons = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        [icons addObject:[TESTDATA randomUrlString]];
    }
    NSMutableArray *resArray = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        ClassViewModel *cvm = [ClassViewModel new];
        cvm.title = titles[i];
        cvm.icon = icons[i];
        [resArray addObject:cvm];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (responseBlock) {
            responseBlock(resArray,nil);
        }
    });
}


+(void)loadCell:(ClassViewCollectionViewCell *)cell model:(ClassViewModel *)model{
    cell.titleLabel.text = model.title;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kPlaceholderImage];
}



@end
