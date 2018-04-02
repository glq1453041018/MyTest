//
//  UIButton+AddBlock.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AddBlock)
- (void)addBlock:(void(^)(UIButton *btn))block;
@end
