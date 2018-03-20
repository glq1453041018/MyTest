//
//  ClassCommentManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
// !!!: 视图类
#import "ClassSpaceTableViewCell.h"
#import "PhotoBrowser.h"
// !!!: 数据类
#import "ClassSpaceModel.h"
#import "LLTableCellOptimization.h"


@interface ClassCommentManager : NSObject

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;

+(void)addPicsWithModel:(ClassSpaceModel*)csm;

+(void)removePicsWithModel:(ClassSpaceModel*)csm;

// !!!: 加载视图
-(void)loadData:(NSArray *)data cell:(ClassSpaceTableViewCell*)cell index:(NSInteger)index pageSize:(NSInteger)pageSize;

@end
