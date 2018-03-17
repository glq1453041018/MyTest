//
//  MYAutoScaleView.m
//  MOBTest
//
//  Created by 伟南 陈 on 2018/3/15.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import "MYAutoScaleView.h"
@interface MYAutoScaleView()
@property (weak, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) NSLayoutConstraint *top;
@end

@implementation MYAutoScaleView

- (void)dealloc{
    if(self.scrollview)
        [self removeObserver:self.scrollview forKeyPath:@"contentOffset"];
}

- (void)setContentView:(UIView *)contentView scrollview:(UIScrollView *)scrollview{
    [contentView removeFromSuperview];
    self.scrollview = scrollview;
    [self.scrollview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addSubview:contentView];
    WeakObj(self);
    [contentView cwn_makeConstraints:^(UIView *maker) {
        weakself.top = maker.leftToSuper(0).rightToSuper(0).bottomToSuper(0).topToSuper(0).lastConstraint;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint point = [change[@"new"] CGPointValue];
    self.top.constant = MIN(0, point.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
