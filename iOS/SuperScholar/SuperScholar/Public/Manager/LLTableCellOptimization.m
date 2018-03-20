//
//  LLTableCellOptimization.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "LLTableCellOptimization.h"

@implementation LLTableCellOptimization

+(void)handleTableData:(NSInteger)totalCount currentIndex:(NSInteger)index pageSize:(NSInteger)pageSize deleteRange:(void (^)(NSRange))block_d addRange:(void (^)(NSRange))block_a{
    if (pageSize==0) {
        NSAssert(NO, @"分页数不能为0");
        return;
    }
    NSInteger totalPage = totalCount/pageSize;
    NSInteger currentPage = index/pageSize;
    BOOL needOperate = NO;
    if (index % pageSize==0) {
        needOperate = YES;
    }
    if (needOperate) {  // 需要进行操作
        if (currentPage>=2) {   // 删除当前页的 前2和后2页的数据，并创建当前页
            // 删除 -2 页数据
            if (block_d) {
                NSRange range = NSMakeRange((currentPage-2)*pageSize, pageSize);
                DLog(@"删除%@",NSStringFromRange(range));
                block_d(range);
            }
            if (currentPage<=totalPage-2) {
                // 删除 +2 页数据
                NSRange range = NSMakeRange((currentPage+1)*pageSize, pageSize);
                DLog(@"删除%@",NSStringFromRange(range));
                block_d(range);
            }
        }
        
        // 创建
        if (block_a) {
            NSInteger startIndex = MAX((currentPage-1)*pageSize, 0);
            NSInteger endIndex = MIN(totalCount, (currentPage+1)*pageSize);
            NSRange range = NSMakeRange(startIndex, endIndex-startIndex);
            DLog(@"添加%@",NSStringFromRange(range));
        }
    }
}

@end
