//
//  MJDIYHeader.m
//  MJCustom
//
//  Created by LOLITA on 2017/7/11.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MJDIYHeader.h"
#import "IndicatorView.h"

@interface MJDIYHeader()
{
    CGSize indicatorSize;
    CGFloat space;
}

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) IndicatorView *indicator;

@property (strong ,nonatomic) UIImageView *bgView;

@end

@implementation MJDIYHeader


#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    indicatorSize = CGSizeMake(25, 25);
    space = 2;
    
    // 设置控件的高度
    self.mj_h = 50;
    self.mj_w = kScreenWidth;
    
    // 添加label
    _label = [[UILabel alloc] init];
    _label.font = [UIFont boldSystemFontOfSize:16];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor darkGrayColor];
    [self addSubview:_label];

    _indicator = [[IndicatorView alloc] initWithType:IndicatorTypeBounceSpot1 tintColor:KColorTheme size:indicatorSize];
    [self addSubview:_indicator];
    
    
}


-(void)setLoadingTintColor:(UIColor *)loadingTintColor{
    _loadingTintColor = loadingTintColor;
    _indicator.loadingTintColor = loadingTintColor;
}
-(void)setTipColor:(UIColor *)tipColor{
    _tipColor = tipColor;
    _label.textColor = tipColor;
}


-(void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.bgView.backgroundColor = bgColor;
    [self insertSubview:self.bgView belowSubview:self.label];
}

//-(UIImageView *)bgView{
//    if (_bgView==nil) {
//        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kScreenHeight+self.mj_h, self.mj_w, kScreenHeight)];
//        _bgView.image = KImageTheme;
//    }
//    return _bgView;
//}



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
            self.label.text = @"下拉可以刷新";
            [self.indicator stopAnimating];
            break;
        case MJRefreshStatePulling:
            self.label.text = @"松开立即刷新";
            [self.indicator stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.label.text = @"正在刷新数据中…";
            CGSize size = [self.label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            self.label.center = CGPointMake(self.mj_w/2.0+space+indicatorSize.width/2.0, self.mj_h/2.0);
            self.indicator.center = CGPointMake(self.mj_w/2.0-size.width/2.0-space-20/2.0+space/2.0+indicatorSize.width/2.0, self.mj_h/2.0);
            [self.indicator startAnimating];
            break;
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
