//
//  UIButton+AddBlock.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "UIControl+AddBlock.h"
#import <objc/runtime.h>

@interface UIControl ()
@property (strong, nonatomic) NSDictionary *event_blocks;//block缓存
@end
@implementation UIControl (AddBlock)

// !!!: 添加按钮事件
- (void)addBlock:(void(^)(UIControl *sender))block forControlEvents:(UIControlEvents)controlEvents{
    NSAssert(block, @"不行，block必须传！");
    
    SEL sel;
    switch (controlEvents) {
        case UIControlEventTouchDown:
            sel = @selector(UIControlEventTouchDown);
            break;
        case UIControlEventTouchDownRepeat:
            sel = @selector(UIControlEventTouchDownRepeat);
            break;
        case UIControlEventTouchDragInside:
            sel = @selector(UIControlEventTouchDragInside);
            break;
        case UIControlEventTouchDragOutside:
            sel = @selector(UIControlEventTouchDragOutside);
            break;
        case UIControlEventTouchDragEnter:
            sel = @selector(UIControlEventTouchDragEnter);
            break;
        case UIControlEventTouchDragExit:
            sel = @selector(UIControlEventTouchDragExit);
            break;
        case UIControlEventTouchUpInside:
            sel = @selector(UIControlEventTouchUpInside);
            break;
        case UIControlEventTouchUpOutside:
            sel = @selector(UIControlEventTouchUpOutside);
            break;
        case UIControlEventTouchCancel:
            sel = @selector(UIControlEventTouchCancel);
            break;
        default:
            break;
    }
    
    [self.event_blocks setValue:block forKey:NSStringFromSelector(sel)];
    [self addTarget:self action:sel forControlEvents:controlEvents];
}

// !!!: 事件处理
- (void)UIControlEventTouchDown{[self block:_cmd];}
- (void)UIControlEventTouchDownRepeat{[self block:_cmd];}
- (void)UIControlEventTouchDragInside{[self block:_cmd];}
- (void)UIControlEventTouchDragOutside{[self block:_cmd];}
- (void)UIControlEventTouchDragEnter{[self block:_cmd];}
- (void)UIControlEventTouchDragExit{[self block:_cmd];}
- (void)UIControlEventTouchUpInside{[self block:_cmd];}
- (void)UIControlEventTouchUpOutside{[self block:_cmd];}
- (void)UIControlEventTouchCancel{[self block:_cmd];}
- (void)block:(SEL)cmd{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(event_blocks));
    void (^blcok)(UIButton *) = [dic objectForKey:NSStringFromSelector(cmd)];
    if(blcok){
        blcok(self);
    }
}

// !!!: setter/getter方法
- (NSDictionary *)event_blocks{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if(!dic){
        objc_setAssociatedObject(self, _cmd, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic = objc_getAssociatedObject(self, _cmd);
    }
    return dic;
}
@end
