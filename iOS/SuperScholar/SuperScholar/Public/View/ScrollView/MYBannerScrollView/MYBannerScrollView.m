//
//  MYBannerScrollView.m
//  MYBannerScrollView
//
//  Created by 陈伟南 on 2016/10/21.
//  Copyright © 2016年 陈伟南. All rights reserved.
//

#import "MYBannerScrollView.h"
#import "MYBannerImageView.h"
#import "UIView+CWNView.h"
#import "NSTimer+Addition.h"
#import "NSArray+ExtraMethod.h"

@interface MYBannerScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSArray *imagePaths;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) MYBannerImageView *leftImageView;
@property (strong, nonatomic) MYBannerImageView *centerImageView;
@property (strong, nonatomic) MYBannerImageView *rightImageView;

@property (strong, nonatomic) NSLayoutConstraint *imageHeight;//UIControl
@property (strong, nonatomic) NSLayoutConstraint *imageWidth;//UIControl

@property (strong, nonatomic) NSLayoutConstraint *topConsTraint;
@property (strong, nonatomic) NSLayoutConstraint *pageControlBottom;

@property (assign, nonatomic) CGSize estimateSize;//设置图片显示大小

@end

@implementation MYBannerScrollView

@synthesize scrollView = _scrollView;
@synthesize failImage = _failImage;

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame: frame]){
        _autoDuration = 3;
        _currentPageIndex = 0;
        _useHorizontalParallaxEffect = YES;
        _useVerticalParallaxEffect = NO;
        _useScaleEffect = NO;
        _enableTimer = YES;
        _estimateSize = CGSizeMake(0, 0);
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        _autoDuration = 3;
        _currentPageIndex = 0;
        _useHorizontalParallaxEffect = YES;
        _useVerticalParallaxEffect = NO;
        _useScaleEffect = NO;
        _enableTimer = YES;
        _estimateSize = CGSizeMake(0, 0);
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    _topConsTraint = [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraint:_topConsTraint];
    WeakObj(self);
    [_scrollView cwn_makeConstraints:^(UIView *maker) {
        maker.rightToSuper(0).leftToSuper(0).bottomToSuper(0);
    }];
    
    _pageControlBottom = [NSLayoutConstraint constraintWithItem:_pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraint:_pageControlBottom];
    [_pageControl cwn_makeConstraints:^(UIView *maker) {
        switch (weakself.location) {
            case locationCenter:
            {
                maker.height(25).centerXtoSuper(0);
            }
                break;
            case locationRight:
            {
                maker.height(25).rightToSuper(20);
            }
                break;
            case locationLeft:
            {
                maker.height(25).leftToSuper(20);
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.rightImageView];
    
    [_leftImageView cwn_makeConstraints:^(UIView *maker) {
        maker.topToSuper(0).leftToSuper(0).rightTo(weakself.centerImageView, 1, 0).bottomToSuper(0);
    }];
    _imageHeight = [NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [_scrollView addConstraint:_imageHeight];
   _imageWidth = [NSLayoutConstraint constraintWithItem:_leftImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0] ;
    [_scrollView addConstraint:_imageWidth];
    
    [_centerImageView cwn_makeConstraints:^(UIView *maker) {
        maker.topToSuper(0).heightTo(weakself.leftImageView, 1, 0).rightTo(weakself.rightImageView, 1, 0).widthTo(weakself.leftImageView, 1, 0).bottomToSuper(0);
    }];
    
    [_rightImageView cwn_makeConstraints:^(UIView *maker) {
        maker.topToSuper(0).heightTo(weakself.centerImageView, 1, 0).rightToSuper(0).widthTo(weakself.centerImageView, 1, 0).bottomToSuper(0);
    }];
    
    [_centerImageView addTarget:self action:@selector(onClickImageView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configContentViews{
    if(_useHorizontalParallaxEffect && [_imagePaths count] != 1){
        _leftImageView.imageLeft.constant = _estimateSize.width/3;
        _rightImageView.imageLeft.constant = -_estimateSize.width/3;
    }

    [_leftImageView loadImageWithImagePath:[self.imagePaths objectAtIndexNotOverFlow:[self checkNextPageIndex:_currentPageIndex-1]]];
    [_centerImageView loadImageWithImagePath:[self.imagePaths objectAtIndexNotOverFlow:[self checkNextPageIndex:_currentPageIndex]]];
    [_rightImageView loadImageWithImagePath:[self.imagePaths objectAtIndexNotOverFlow:[self checkNextPageIndex:_currentPageIndex+1]]];
    
    [_scrollView setContentOffset:CGPointMake(_estimateSize.width, 0)];//此处若开启动画属性就会发现：第一或第三张图片url先变化了，然后才滚回第二张图片，显示上一个或下一个url
}

#pragma mark Self method

-(void)setLocation:(MYPageControlLocation)location{
    _location = location;
    [self.pageControl cwn_reMakeConstraints:^(UIView *maker) {
        switch (location) {
            case locationCenter:
            {
                maker.height(25).centerXtoSuper(0).bottomToSuper(0);
            }
                break;
            case locationRight:
            {
                maker.height(25).rightToSuper(20).bottomToSuper(0);
            }
                break;
            case locationLeft:
            {
                maker.height(25).leftToSuper(20).bottomToSuper(0);
            }
                break;
                
            default:
                break;
        }
    }];
}

- (NSInteger)checkNextPageIndex:(NSInteger)nextPage{
    if(nextPage == -1)
        return [_imagePaths count] - 1;
    else if (nextPage == [_imagePaths count])
        return 0;
    else
        return nextPage;
}

#pragma mark Public method

- (void)loadImages:(NSArray *)imagePaths estimateSize:(CGSize)estimateSize{
    _imageWidth.constant = estimateSize.width;
    _imageHeight.constant = estimateSize.height;
    _leftImageView.imageHeight.constant = estimateSize.height;
    _centerImageView.imageHeight.constant = estimateSize.height;
    _rightImageView.imageHeight.constant = estimateSize.height;
    _leftImageView.imageWidth.constant = estimateSize.width;
    _centerImageView.imageWidth.constant = estimateSize.width;
    _rightImageView.imageWidth.constant = estimateSize.width;
    
    _estimateSize = estimateSize;
    
//    if([_imagePaths count]>1)//此处防止外部多次调用load函数, 导致开启多个定时器（初始化本类时load了一张默认图）
//        return;
    _scrollView.scrollEnabled = NO;
    [_timer pauseTimer];
    
    _imagePaths = imagePaths;
    if ([_imagePaths count] > 1) {//多张图情况
        _scrollView.scrollEnabled = YES;
        [self.pageControl setHidden:NO];
        self.pageControl.numberOfPages = [_imagePaths count];
        self.pageControl.currentPage = 0;
        
        if(_enableTimer){
            if(!_timer){//定时器未加载
                _timer = [NSTimer scheduledTimerWithTimeInterval:_autoDuration target:self selector:@selector(timerDidFired:) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
            }
            [_timer pauseTimer];
            [_timer resumeTimerAfterTimeInterval:_autoDuration];
        }
        else
            [_timer invalidate];
    } else {//一张图情况
        _scrollView.scrollEnabled = NO;
        [self.pageControl setHidden:YES];
        self.pageControl.numberOfPages = 0;
        [_timer pauseTimer];
    }
    
    _currentPageIndex = 0;
    [self configContentViews];
    [_centerImageView addTarget:self action:@selector(onClickImageView) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView setContentOffset:CGPointMake(_estimateSize.width, 0)];
}

- (void)pauseTimer{
    if([_imagePaths count] < 2)//无需定时器
        return;
    [_scrollView setContentOffset:CGPointMake(_estimateSize.width, 0) animated:YES];
    [_timer pauseTimer];
}

- (void)resumeTimer{
    if([_imagePaths count] < 2)//无需定时器
        return;
    [_scrollView setContentOffset:CGPointMake(_estimateSize.width, 0)animated:YES];
    [_timer resumeTimerAfterTimeInterval:_autoDuration];
}

#pragma mark - EventHandler

- (void)timerDidFired:(NSTimer *)timer{
    CGPoint newOffset = CGPointMake(2 * _estimateSize.width, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)onClickImageView{
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:didClickScrollView:)]) {
        [self.delegate bannerScrollView:self didClickScrollView:self.currentPageIndex];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer pauseTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_timer resumeTimerAfterTimeInterval:_autoDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _scrollView){
        
        NSInteger imagesCount = [_imagePaths count];
        if(imagesCount == 0 || imagesCount == 1)
            return;
        
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            self.currentPageIndex = [self checkNextPageIndex:self.currentPageIndex + 1];
            [self configContentViews];
        }
        if(contentOffsetX <= 0) {
            self.currentPageIndex = [self checkNextPageIndex:self.currentPageIndex - 1];
            [self configContentViews];
        }
        
        self.pageControl.currentPage = self.currentPageIndex;
        
        if (_useHorizontalParallaxEffect) {
            CGFloat contentOffsetX = scrollView.contentOffset.x;
            _leftImageView.imageLeft.constant = _estimateSize.width/3 - _estimateSize.width/3*((_estimateSize.width - contentOffsetX)/_estimateSize.width);
            _centerImageView.imageLeft.constant = contentOffsetX > _estimateSize.width?(scrollView.contentOffset.x - _estimateSize.width)/3:-(_estimateSize.width - scrollView.contentOffset.x)/3;
            _rightImageView.imageLeft.constant = - _estimateSize.width/3 + _estimateSize.width/3*((contentOffsetX - _estimateSize.width)/_estimateSize.width);
        }
        
        return;
    }
    
    if(_useVerticalParallaxEffect == NO && _useScaleEffect == NO)
        return;

    if([scrollView isKindOfClass:[UITableView class]] || [scrollView isKindOfClass:[UICollectionView class]] || [scrollView.superview isKindOfClass:[UIWebView class]]){
        //判断scrollView类型
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if(contentOffsetY < 0){//下拉放大效果
            if(_useScaleEffect == YES){
                _topConsTraint.constant = contentOffsetY;
                
                _imageHeight.constant = CGRectGetHeight(self.bounds) - contentOffsetY;
                
                _leftImageView.imageHeight.constant = _estimateSize.height - contentOffsetY;
                _centerImageView.imageHeight.constant = _estimateSize.height - contentOffsetY;
                _rightImageView.imageHeight.constant = _estimateSize.height - contentOffsetY;
            }
        }else { //垂直视差效果
            if(_useVerticalParallaxEffect == YES){
                if (contentOffsetY >= _estimateSize.height)
                    contentOffsetY = _estimateSize.height;
                _topConsTraint.constant = contentOffsetY/1.8;
                _pageControlBottom.constant = contentOffsetY/1.8;
                if(contentOffsetY > CGRectGetHeight(_pageControl.bounds)/2 + 8)
                    [_pageControl setHidden:YES];
                else
                    [_pageControl setHidden:NO];
            }
        }
    }
    return;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(_estimateSize.width, 0) animated:YES];
}

#pragma mark SubViews

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setBounces:NO];
        [_scrollView setContentOffset:CGPointMake(_estimateSize.width, 0)];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if(!_pageControl){
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_pageControl sizeToFit];
        [_pageControl setEnabled:NO];//不可点
        [_pageControl setCurrentPageIndicatorTintColor:KColorTheme];
        [_pageControl setHidden:YES];
    }
    return _pageControl;
}

- (MYBannerImageView *)leftImageView{
    if(!_leftImageView){
        _leftImageView = [[MYBannerImageView alloc] init];
        [_leftImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_leftImageView setFailImage:self.failImage];
    }
    return _leftImageView;
}

- (MYBannerImageView *)centerImageView{
    if(!_centerImageView){
        _centerImageView = [[MYBannerImageView alloc] init];
        [_centerImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_centerImageView setFailImage:self.failImage];
    }
    return _centerImageView;
}

- (MYBannerImageView *)rightImageView{
    if(!_rightImageView){
        _rightImageView = [[MYBannerImageView alloc] init];
        [_rightImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_rightImageView setFailImage:self.failImage];
    }
    return _rightImageView;
}

- (UIImage *)failImage{
    if (_failImage == nil) {
        _failImage = [UIImage imageNamed:@"morenbanner"];
    }
    return _failImage;
}

- (void)setFailImage:(UIImage *)failImage{
    _failImage = failImage;
    _leftImageView.failImage = failImage;
    _centerImageView.failImage = failImage;
    _rightImageView.failImage = failImage;
}

@end
