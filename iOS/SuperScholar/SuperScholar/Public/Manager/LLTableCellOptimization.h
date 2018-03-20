//
//  LLTableCellOptimization.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLTableCellOptimization : NSObject

+(void)handleTableData:(NSInteger)totalCount currentIndex:(NSInteger)index pageSize:(NSInteger)pageSize deleteRange:(void(^)(NSRange range))block_d addRange:(void(^)(NSRange range))block_a;

@end
