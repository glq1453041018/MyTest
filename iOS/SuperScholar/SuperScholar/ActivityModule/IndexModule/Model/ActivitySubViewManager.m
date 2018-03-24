//
//  ActivitySubViewManager.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivitySubViewManager.h"
#import "TESTDATA.h"


@implementation ActivitySubViewManager
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}
- (void)requestFromServer:(BOOL)isReset withCompletion:(void(^)(BOOL isLastData, NSError *error))completion{
    self.page = isReset ? 1 : isReset;

    //模拟请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *arr = isReset ? [NSMutableArray array] : self.data;
        for (int i=0; i < 10; i ++) {
            NSString *content = [TESTDATA randomContent];
            NSString *image = [TESTDATA randomUrlString];
            ActivityModel *model = [ActivityModel new];
            model.title = content;
            model.imageUrl = image;
            [arr addObject:model];
        }
        
        //如果有请求回来数据
        ++self.page;
        self.data = [arr mutableCopy];
        completion(arc4random() % 4 == 1 ? YES : NO, nil);
    });
}
@end
