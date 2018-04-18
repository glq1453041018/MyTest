//
//  ClassViewModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassViewModel : NSObject

@property (copy ,nonatomic) NSString *icon;         // 图标
@property (copy ,nonatomic) NSString *name;         // 班级名称
@property (assign ,nonatomic) NSInteger classId;    // 班级Id
@property (assign ,nonatomic) NSInteger userId;
@property (copy ,nonatomic) NSString *desc;         // 班级秒速

@end
