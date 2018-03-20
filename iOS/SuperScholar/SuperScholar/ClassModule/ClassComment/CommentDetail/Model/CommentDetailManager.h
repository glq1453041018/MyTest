//
//  CommentDetailManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassComDetailTableViewCell.h"         // 回复cell
#import "ClassComDetailModel.h"                 // 回复model

@interface CommentDetailManager : NSObject
@property (strong ,nonatomic) ClassComItemModel *mainModel;                 // 消息主体
@property (strong ,nonatomic) NSMutableArray <ClassComItemModel*> *datas;   // 回复的模型数组
@property (assign ,nonatomic) NSInteger page;           // 分页标志符


// !!!: 获取数据
-(void)requestDataResponse:(void(^)(BOOL succeed,id error))responseBlock;


// !!!: 刷新cell
-(void)loadCell:(ClassComDetailTableViewCell*)cell model:(ClassComItemModel*)ccim;

@end
