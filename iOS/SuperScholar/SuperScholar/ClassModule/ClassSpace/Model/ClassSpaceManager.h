//
//  ClassSapceManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassSpaceModel.h"             // 数据模型
#import "ClassSpaceTableViewCell.h"     // cell样式
#import "PhotoBrowser.h"                // 图片浏览器
#import "LLTableCellOptimization.h"     // cell优化策略

@interface ClassSpaceManager : NSObject

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;

+(void)addPicsWithModel:(ClassSpaceModel*)csm;

+(void)removePicsWithModel:(ClassSpaceModel*)csm;

// !!!: 加载视图
-(void)loadData:(NSArray *)data cell:(ClassSpaceTableViewCell*)cell index:(NSInteger)index pageSize:(NSInteger)pageSize;

@end
