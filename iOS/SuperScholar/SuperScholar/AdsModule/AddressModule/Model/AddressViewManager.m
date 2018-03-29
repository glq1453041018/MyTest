//
//  AddressViewManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressViewManager.h"

@interface AddressViewManager ()

@end

@implementation AddressViewManager

// !!!: 获取数据
+(void)requestDataResponse:(void (^)(NSArray *, id))responseBlock{
    
    NSDictionary *dic = [self getCityList];
    
    NSMutableArray *resArray = [NSMutableArray array];
    // 热门城市
    NSArray *hots = [dic objectForKey:@"hotCity"];
    if (hots.count) {
        NSMutableArray *hotsTmp = [NSMutableArray array];
        for (int i=0; i<hots.count; i++) {
            NSDictionary *itemDic = hots[i];
            AddressModel *am = [AddressModel objectWithModuleDic:itemDic hintDic:nil];
            am.typeName = @"热门城市";
            NSInteger row = ceilf(hots.count / 3.0);
            am.cellHeight = row * 45;
            [hotsTmp addObject:am];
        }
        [resArray addObject:hotsTmp];
    }
    // 普通城市
    NSDictionary *normal = [dic objectForKey:@"normalCity"];
    NSArray *keys = [normal.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString* obj2) {
        if (obj1>obj2) {
            return NSOrderedDescending;
        }
        else{
            return NSOrderedAscending;
        }
    }];
    for (NSString *key in keys) {
        NSArray *items = [normal objectForKey:key];
        if (items.count) {
            NSMutableArray *normalTmp = [NSMutableArray array];
            for (int i=0; i<items.count; i++) {
                NSDictionary *itemDic = items[i];
                AddressModel *am = [AddressModel objectWithModuleDic:itemDic hintDic:nil];
                am.typeName = key;
                am.cellHeight = 44;
                [normalTmp addObject:am];
            }
            [resArray addObject:normalTmp];
        }
    }
    if (responseBlock) {
        responseBlock(resArray,nil);
    }
    
}




// !!!: 获取城市名称
+(NSDictionary *)getCityList{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityOrder" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
