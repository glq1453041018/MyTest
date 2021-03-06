//
//  ClassInfoManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoManager.h"

@implementation ClassInfoManager

+(void)requestDataType:(ReCruitType)type response:(void (^)(NSArray *, id))responseBlock{
    NSMutableArray *titles = [NSMutableArray array];
    if (type==ReCruitTypeClass) {
        for (int i=0; i<4; i++) {
            ClassInfoModel *cim = [ClassInfoModel new];
            cim.key = @[@"招生启示",@"最新动态",@"活动预告",@"精彩活动"][i];
            cim.value = @[@"12",@"23",@"25",@"32"][i];
            cim.code = @[ZhaoShengQiShiCode,ZuiXinDongTaiCode,HuoDongYuGaoCode,JingCaiHuoDongCode][i];
            cim.cellHeight = AdaptedWidthValue(60);
            [titles addObject:cim];
        }
        ClassInfoModel_PingJia *cimpj = [ClassInfoModel_PingJia new];
        cimpj.starNum = 4;
        cimpj.commentNum = 123;
        cimpj.cellHeight = AdaptedWidthValue(44);
        NSArray *pingjias = @[cimpj];
        NSMutableArray *items = [NSMutableArray array];
        NSArray *columns = @[@"北京市东华街道20号楼6单元501室（新区美罗湘西200）",@"联系方式",@"班级简介",@"班级环境",@"班级列表",@"学校信息"];
        for (int i=0; i<columns.count; i++) {
            ClassInfoModel_Item *cimi = [ClassInfoModel_Item new];
            cimi.icon = @"location";
            cimi.key = columns[i];
            cimi.value = @[@"",@"15150912502",@"",@"",@"",@""][i];
            cimi.code = @[@"location",@"phone",@"brief",@"environment",@"list",@"school"][i];
            cimi.cellHeight = AdaptedWidthValue(44);
            [items addObject:cimi];
        }
        NSArray *resArray = @[@[titles],pingjias,items];
        if (responseBlock) {
            responseBlock(resArray,nil);
        }
    }
    else{
        for (int i=0; i<4; i++) {
            ClassInfoModel *cim = [ClassInfoModel new];
            cim.key = @[@"招生启示",@"最新动态",@"活动预告",@"精彩活动"][i];
            cim.value = @[@"12",@"23",@"25",@"32"][i];
            cim.code = @[ZhaoShengQiShiCode,ZuiXinDongTaiCode,HuoDongYuGaoCode,JingCaiHuoDongCode][i];
            cim.cellHeight = AdaptedWidthValue(60);
            [titles addObject:cim];
        }
        ClassInfoModel_PingJia *cimpj = [ClassInfoModel_PingJia new];
        cimpj.starNum = 4;
        cimpj.commentNum = 123;
        cimpj.cellHeight = AdaptedWidthValue(44);
        NSArray *pingjias = @[cimpj];
        NSMutableArray *items = [NSMutableArray array];
        NSArray *columns = @[@"北京市东华街道20号楼6单元501室（新区美罗湘西200）",@"联系方式",@"学校简介",@"学校环境"];
        for (int i=0; i<columns.count; i++) {
            ClassInfoModel_Item *cimi = [ClassInfoModel_Item new];
            cimi.icon = @"location";
            cimi.key = columns[i];
            cimi.value = @[@"",@"15150912502",@"",@""][i];
            cimi.code = @[@"location",@"phone",@"brief",@"environment"][i];
            cimi.cellHeight = AdaptedWidthValue(44);
            [items addObject:cimi];
        }
        NSArray *resArray = @[@[titles],pingjias,items];
        if (responseBlock) {
            responseBlock(resArray,nil);
        }
    }
}



// !!!: 加载数据
-(void)loadTitleCellData:(NSArray*)data cell:(ClassInfoTableViewCell_Title*)cell delegate:(id)delegate{
    if (delegate) {
        self.delegate = delegate;
    }
    
    for (UIView* view in cell.subviews) {
        if ([view isKindOfClass:[ClassInfoTitleItemView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (data.count) {
        CGFloat width = kScreenWidth / data.count;
        for (int i=0; i<data.count; i++) {
            ClassInfoModel *cim = data[i];
            ClassInfoTitleItemView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTitleItemView" owner:nil options:nil] firstObject];
            itemView.titleLabel.text = cim.key.length?cim.key:@"-";
            itemView.detailLabel.text = cim.value.length?cim.value:@"-";
            [itemView.tapBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            objc_setAssociatedObject(itemView.tapBtn, @"tapBtn", cim, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            itemView.tapBtn.tag = i;
            itemView.centerX = width/2.0 * (2*i+1);
            [cell addSubview:itemView];
        }
    }
    
}

-(void)click:(UIButton*)btn{
    ClassInfoModel *cim = objc_getAssociatedObject(btn, @"tapBtn");
    if (self.delegate&&[self.delegate respondsToSelector:@selector(classInfoManagerTitleClickEvent:data:)]) {
        [self.delegate classInfoManagerTitleClickEvent:btn.tag data:cim];
    }
}


@end
