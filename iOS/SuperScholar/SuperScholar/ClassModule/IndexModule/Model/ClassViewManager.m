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
+(void)requestDataResponse:(void (^)(NSArray<ClassViewModel *> *, id))responseBlock{
    
    NSString *url = C_ClassListInfoUrlString;
    AFService *request = [AFService new];
    [request requestWithURLString:url parameters:nil type:Post success:^(NSDictionary *responseObject) {
        NSString *code = [responseObject objectForKeyNotNull:@"code"];
        if (code.integerValue==1) {
            NSArray *datas = [responseObject objectForKeyNotNull:@"data"];
            NSMutableArray *resArray = [NSMutableArray array];
            for (NSDictionary *dic in datas) {
                ClassViewModel *cvm = [ClassViewModel objectWithModuleDic:dic hintDic:@{@"image":@"icon"}];
                [resArray addObject:cvm];
            }
            if (responseBlock) {
                responseBlock(resArray,nil);
            }
        }
        else{
            if (responseBlock) {
                responseBlock(nil,@"获取数据失败");
            }
        }
        
    } failure:^(NSError *error) {
        if (responseBlock) {
            responseBlock(nil,@"获取数据失败");
        }
    }];
}


+(void)loadCell:(ClassViewCollectionViewCell *)cell model:(ClassViewModel *)model{
    cell.titleLabel.text = model.name;
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:kPlaceholderImage];
}



@end
