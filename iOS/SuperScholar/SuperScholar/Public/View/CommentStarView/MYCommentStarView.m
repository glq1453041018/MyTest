//
//  MYCommentStarView.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/6/27.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYCommentStarView.h"

#define FOREGROUND_STAR_IMAGE_NAME @"pingjia_dianji"
#define BACKGROUND_STAR_IMAGE_NAME @"pingjia_weidian"
#define DEFALUT_STAR_NUMBER 5
#define ANIMATION_TIME_INTERVAL 1

@interface MYCommentStarView ()

@property (strong, nonatomic) UIView *foregroundStarView;
@property (strong, nonatomic) UIView *backgroundStarView;

@property (assign, nonatomic) NSInteger numberOfStars;//星星总数
@property (assign, nonatomic) CGFloat inset;//星星间距
@property (assign, nonatomic) CGFloat starWidth;//星星大小

@property (assign, nonatomic) CGFloat numberOfLightStar;//亮的星星数

@end

@implementation MYCommentStarView

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _allowIncompleteStar = YES;
        [self buildDataAndUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self  = [super initWithFrame:frame]){
        _allowIncompleteStar = YES;
        [self buildDataAndUI];
    }
    return self;
}

#pragma mark - Private Methods

//滑动点击大星星
- (void)buildDataAndUI {
    _scorePercent = 1;//默认为1
    _numberOfStars = DEFALUT_STAR_NUMBER;
    _numberOfLightStar = DEFALUT_STAR_NUMBER;
    if(_duration == 0)
        _duration = ANIMATION_TIME_INTERVAL / 5.0;
    
    _starWidth = CGRectGetHeight(self.frame) - 5;
    
    self.foregroundStarView = [self createStarViewWithImage:FOREGROUND_STAR_IMAGE_NAME];
    self.backgroundStarView = [self createStarViewWithImage:BACKGROUND_STAR_IMAGE_NAME];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
}

- (void)userTapRateView:(CGFloat)locationInSelf {
    CGFloat realStarScore = locationInSelf / self.bounds.size.width;
    self.scorePercent = realStarScore;
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    
    _starWidth = _starWidth > 0 ? _starWidth : 17;
    _inset = (CGRectGetWidth(self.frame) - _numberOfStars * _starWidth) / (_numberOfStars);
    
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(_inset / 2.0 + _inset*i + i*_starWidth, CGRectGetHeight(self.frame) / 2.0 - _starWidth / 2.0, _starWidth, _starWidth);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        if (self.tinColor) {
            imageView.tintColor = self.tinColor;
        }
        [view addSubview:imageView];
    }
    return view;
}

//设置完分数，开始动画方法

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak MYCommentStarView *weakSelf = self;
    CGFloat animationTimeInterval =0;
    animationTimeInterval = ANIMATION_TIME_INTERVAL;
    
    CGFloat numberOflightStar = ((ceil(weakSelf.scorePercent * 10)) / 2.0);//乘10 -> 向上取整 -> 除以2
    if(_allowIncompleteStar == NO){
        numberOflightStar = ceil(numberOflightStar);
        if(numberOflightStar < _minimumScore)
            numberOflightStar = _minimumScore;
    }

    if (self.noAnimation) {
        self.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * numberOflightStar / 5, weakSelf.bounds.size.height);
        if([self.delegate respondsToSelector:@selector(commentStarView:scoreChanged:)]){
            [self.delegate commentStarView:weakSelf scoreChanged:numberOflightStar];
        }
    }
    else{
        [UIView animateWithDuration:_duration * fabs(_numberOfLightStar - numberOflightStar) animations:^{
            weakSelf.foregroundStarView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width * numberOflightStar / 5, weakSelf.bounds.size.height);
        }completion:^(BOOL finished) {
            if([weakSelf.delegate respondsToSelector:@selector(commentStarView:scoreChanged:)]){
                [weakSelf.delegate commentStarView:weakSelf scoreChanged:numberOflightStar];
            }
        }];
    }
    
    
    _numberOfLightStar = numberOflightStar;
}

#pragma mark - Get and Set Methods

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self buildDataAndUI];
}

- (void)setScorePercent:(CGFloat)scroePercent {
    if (_scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scroePercent;
    }

    [self setNeedsLayout];
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touche = [touches anyObject];
    CGPoint tapPoint = [touche locationInView:self];
    [self userTapRateView:tapPoint.x];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touche = [touches anyObject];
    CGPoint tapPoint = [touche locationInView:self];
    [self userTapRateView:tapPoint.x];
}




@end
