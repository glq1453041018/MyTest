//
//  ClassComDetailModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassSpaceModel.h"             // 头部主体
@class ClassComItemModel;
@interface ClassComDetailModel : NSObject
@property (strong ,nonatomic) ClassSpaceModel *mainModel;               // 详情主体
@property (copy ,nonatomic) NSArray <ClassComItemModel*> *responses;    // 评论列表
@end







// !!!: 单条评论
@interface ClassComItemModel : NSObject
@property (copy ,nonatomic) NSString *icon;
@property (copy ,nonatomic) NSString *userName;
@property (copy ,nonatomic) NSString *comment;
@property (copy ,nonatomic) NSString *date;
@property (assign ,nonatomic) BOOL more;

@property (assign ,nonatomic) CGFloat commentLabelHeight;
@property (assign ,nonatomic) CGFloat cellHeight;
@end




