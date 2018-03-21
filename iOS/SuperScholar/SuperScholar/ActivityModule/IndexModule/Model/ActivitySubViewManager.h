//
//  ActivitySubViewManager.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityModel.h"

@interface ActivitySubViewManager : NSObject
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *data;
- (void)requestFromServer:(BOOL)isReset withCompletion:(void(^)(BOOL isLastData, NSError *error))completion;
@end
