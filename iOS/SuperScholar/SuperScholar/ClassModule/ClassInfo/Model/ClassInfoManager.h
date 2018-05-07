//
//  ClassInfoManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
// !!!: 视图类
#import "ClassInfoTitleItemView.h"
#import "ClassInfoTableViewCell.h"
// !!!: 数据里
#import "ClassInfoModel.h"

@protocol ClassInfoManagerDelegate;
@interface ClassInfoManager : NSObject

@property (nonatomic,weak) id <ClassInfoManagerDelegate> delegate;

// !!!: 获取数据
+(void)requestDataType:(ReCruitType)type response:(void(^)(NSArray *resArray,id error))responseBlock;

// !!!: 加载数据
-(void)loadTitleCellData:(NSArray*)data cell:(ClassInfoTableViewCell_Title*)cell delegate:(id)delegate;

@end



@protocol ClassInfoManagerDelegate <NSObject>
@optional
-(void)classInfoManagerTitleClickEvent:(NSInteger)index data:(ClassInfoModel*)model;

@end
