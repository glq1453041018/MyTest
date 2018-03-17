//
//  NSArray+ExtraMethod.h
//  JCFindHouse
//
//  Created by Jam on 13-11-20.
//  Copyright (c) 2013年 jiamiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ExtraMethod)


/**
 安全获取数组某一项数据

 @param index 索引
 @return 数据
 */
- (id)objectAtIndexNotOverFlow:(NSUInteger)index;

@end
