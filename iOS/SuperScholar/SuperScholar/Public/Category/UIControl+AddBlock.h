//
//  UIButton+AddBlock.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (AddBlock)

/**
 按钮事件添加，相当于addTarget
 
 @param block 按钮事件回调
 */
- (void)addBlock:(void(^)(UIControl *sender))block forControlEvents:(UIControlEvents)controlEvents;

@end
