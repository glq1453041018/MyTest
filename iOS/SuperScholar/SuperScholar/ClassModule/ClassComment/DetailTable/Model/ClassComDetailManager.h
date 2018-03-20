//
//  ClassComDetailManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassSpaceTableViewCell.h"             // 消息主体cell
#import "ClassComDetailTableViewCell.h"         // 回复cell
#import "PhotoBrowser.h"
#import "ClassComDetailModel.h"                 // 数据模型

@interface ClassComDetailManager : NSObject
@property (copy ,nonatomic) ClassComDetailModel *dataModel;     // 数据模型

// !!!: 获取数据
-(void)requestDataResponse:(void(^)(BOOL succeed,id error))responseBlock;

// !!!: 加载视图
-(void)loadCell:(ClassSpaceTableViewCell*)cell;
-(void)loadResponseCell:(ClassComDetailTableViewCell*)cell index:(NSInteger)index;

@end
