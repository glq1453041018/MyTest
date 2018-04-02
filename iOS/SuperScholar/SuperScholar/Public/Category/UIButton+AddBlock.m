//
//  UIButton+AddBlock.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "UIButton+AddBlock.h"
#import <objc/runtime.h>

typedef void (^block)(UIButton *btn);

@interface UIButton ()
@property (copy, nonatomic) void (^clickBlock)(UIButton *btn);
@property (copy, nonatomic) block block;
@end
@implementation UIButton (AddBlock)

- (void (^)(UIButton *))clickBlock{
    void (^block)(UIButton *btn) = objc_getAssociatedObject(self, _cmd);
    return block;
}
- (void)setClickBlock:(void (^)(UIButton *))clickBlock{
    objc_setAssociatedObject(self, @selector(clickBlock), clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addBlock:(void(^)(UIButton *btn))block{
    self.clickBlock = block;
    [self addTarget:self action:@selector(onclickBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onclickBtn{
    if(self.clickBlock){
        self.clickBlock(self);
    }
}
@end
