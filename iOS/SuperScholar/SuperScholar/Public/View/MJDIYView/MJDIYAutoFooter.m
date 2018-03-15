//
//  MJDIYAutoFooter.m
//  MJCustom
//
//  Created by LOLITA on 2017/7/11.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MJDIYAutoFooter.h"
#import "IndicatorView.h"
@interface MJDIYAutoFooter()
{
    CGSize indicatorSize;
    CGFloat space;
}

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) IndicatorView *indicator;

@end

@implementation MJDIYAutoFooter

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    indicatorSize = CGSizeMake(25, 25);
    space = 2;
    
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    _label = [[UILabel alloc] init];
    _label.font = [UIFont boldSystemFontOfSize:16];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor darkGrayColor];
    [self addSubview:_label];
    
    _indicator = [[IndicatorView alloc] initWithType:IndicatorTypeBounceSpot1 tintColor:[UIColor redColor] size:indicatorSize];
    [self addSubview:_indicator];
    
}


#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
}


#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    self.label.frame = self.bounds;
    
    switch (state) {
        case MJRefreshStateIdle:
            self.label.text = @"上拉加载更多";
            [self.indicator stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在加载更多数据…";
            CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            self.label.center = CGPointMake(self.mj_w/2.0+space+indicatorSize.width/2.0, self.mj_h/2.0);
            self.indicator.center = CGPointMake(self.mj_w/2.0-size.width/2.0-space-20/2.0+space/2.0+indicatorSize.width/2.0, self.mj_h/2.0);
            [self.indicator startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            [self.indicator stopAnimating];
            self.label.text = @"已经全部加载完毕";
        default:
            break;
    }
}


#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
}


@end
