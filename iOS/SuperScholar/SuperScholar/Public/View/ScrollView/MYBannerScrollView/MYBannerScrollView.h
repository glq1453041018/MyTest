//
//  MYBannerScrollView.h
//  MYBannerScrollView
//
//  Created by 陈伟南 on 2016/10/21.
//  Copyright © 2016年 陈伟南. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MYPageControlLocation) {//分页控件位置
    locationCenter,
    locationLeft,
    locationRight
};

typedef NS_ENUM(NSInteger , MYPageControlStyle) {//分页控件样式
    MYPageControlStyleDefault,//小圆点样式
    MYPageControlStyleLabel,//文本样式1/5
};


@class MYBannerScrollView;

@protocol MYBannerScrollViewDelegate  <NSObject>

@optional
- (void)bannerScrollView:(MYBannerScrollView *)bannerScrollView didClickScrollView:(NSInteger)pageIndex;

@end

@interface MYBannerScrollView : UIView

@property (strong, nonatomic, readonly) UIScrollView *scrollView;
@property (strong, nonatomic) UIImage *failImage;
@property (assign, nonatomic) NSTimeInterval autoDuration;
@property (assign, nonatomic) id<MYBannerScrollViewDelegate> delegate;
@property (assign, nonatomic) BOOL enableTimer;//是否开启定时轮播

@property (assign ,nonatomic) MYPageControlLocation location;
@property (assign ,nonatomic) MYPageControlStyle style;
@property (strong ,nonatomic ,readonly) NSArray *imagePaths;
@property (assign ,nonatomic) BOOL needBgView;  // 是否需要背景

//默认开启滚动视差效果和下拉放大效果
@property (assign, nonatomic) BOOL useHorizontalParallaxEffect;
@property (assign, nonatomic) BOOL useVerticalParallaxEffect;
@property (assign, nonatomic) BOOL useScaleEffect;

- (void)loadImages:(NSArray *)imagePaths estimateSize:(CGSize)estimateSize;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)pauseTimer;
- (void)resumeTimer;

- (void)setCurrentPage:(NSInteger)page; // 设置当前页

@end
