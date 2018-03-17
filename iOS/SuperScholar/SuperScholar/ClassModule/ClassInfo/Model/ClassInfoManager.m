//
//  ClassInfoManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoManager.h"

@implementation ClassInfoManager

+(void)requestDataStyle:(InteractiveStyle)style response:(void(^)(NSArray *resArray,id error))responseBlock{
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        ClassInfoModel *cim = [ClassInfoModel new];
        cim.key = @[@"招生启示",@"最新动态",@"学校环境",@"精彩活动"][i];
        cim.value = @[@"12",@"23",@"25",@"32"][i];
        cim.cellHeight = AdaptedWidthValue(60);
        [titles addObject:cim];
    }
    ClassInfoModel_PingJia *cimpj = [ClassInfoModel_PingJia new];
    cimpj.starNum = 5;
    cimpj.commentNum = 123;
    if (style==ClassInfoStyle) {
        cimpj.style = ClassCommentStyle;
    }else if (style==SchoolInfoStyle){
        cimpj.style = SchoolCommentStyle;
    }
    cimpj.cellHeight = AdaptedWidthValue(44);
    NSArray *pingjias = @[cimpj];
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        ClassInfoModel_Item *cimi = [ClassInfoModel_Item new];
        cimi.icon = @"location";
        cimi.key = @[@"北京市东华街道20号楼6单元501室（新区美罗湘西200）",@"联系方式",@"学校简介",@"班级列表"][i];
        cimi.value = @[@"",@"15150912502",@"",@""][i];
        cimi.code = @[@"location",@"phone",@"brief",@"list"][i];
        cimi.cellHeight = AdaptedWidthValue(44);
        [items addObject:cimi];
    }
    NSArray *resArray = @[@[titles],pingjias,items];
    if (responseBlock) {
        responseBlock(resArray,nil);
    }
}

@end
