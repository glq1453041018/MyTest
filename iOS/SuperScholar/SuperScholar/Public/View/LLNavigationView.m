//
//  LLNavigationView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "LLNavigationView.h"
@interface LLNavigationView ()
@property (strong ,nonatomic) NSLayoutConstraint *self_top;
@end
@implementation LLNavigationView



#pragma mark - <************************** 控件初始化 **************************>
-(UIButton *)letfBtn{
    if (_letfBtn==nil) {
        _letfBtn = [UIButton new];
        [_letfBtn addTarget:self action:@selector(leftClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_letfBtn];
    }
    return _letfBtn;
}

-(UILabel *)titleLabel{
    if (_titleLabel==nil) {
        _titleLabel = [UILabel new];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIButton *)rightBtn{
    if (_rightBtn==nil) {
        _rightBtn = [UIButton new];
        [_rightBtn addTarget:self action:@selector(rightClickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.backgroundColor = KColorTheme;
    // 监听屏幕旋转
    //设备旋转通知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    WS(ws);
    [self cwn_makeConstraints:^(UIView *maker) {
        ws.self_top = maker.rightToSuper(0).leftToSuper(0).height(kNavigationbarHeight).topToSuper(0).lastConstraint;
    }];
}



#pragma mark - <************************** 设置方法 **************************>
-(void)setTitle:(NSString *)title leftImage:(NSString *)leftImg leftText:(NSString*)leftText rightImage:(NSString *)rightImg rightText:(NSString*)rightText{
    CGFloat defaultWidth = kNavigationbarHeight-kStatusBarHeight;
    CGFloat maxWidth = defaultWidth;
    // 左边
    if (leftImg&&leftImg.length) {
        [self.letfBtn setImage:[UIImage imageNamed:leftImg] forState:UIControlStateNormal];
        [self.letfBtn cwn_reMakeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(defaultWidth);
        }];
    }
    if (leftText&&leftText.length) {
        [self.letfBtn setTitle:leftText forState:UIControlStateNormal];
        maxWidth = [leftText sizeWithAttributes:@{NSFontAttributeName:self.letfBtn.titleLabel.font}].width + 10;
        maxWidth = MIN(kScreenWidth/2.0, MAX(maxWidth, defaultWidth));
        [self.letfBtn cwn_reMakeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(maxWidth);
        }];
    }
    // 右边
    if (rightImg&&rightImg.length) {
        [self.rightBtn setImage:[UIImage imageNamed:rightImg] forState:UIControlStateNormal];
        [self.rightBtn cwn_reMakeConstraints:^(UIView *maker) {
            maker.rightToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(defaultWidth);
        }];
    }
    if (rightText&&rightText.length) {
        [self.rightBtn setTitle:rightText forState:UIControlStateNormal];
        maxWidth = [rightText sizeWithAttributes:@{NSFontAttributeName:self.rightBtn.titleLabel.font}].width + 10;
        maxWidth = MAX(maxWidth, defaultWidth);
        maxWidth = MIN(kScreenWidth/2.0, MAX(maxWidth, defaultWidth));
        [self.rightBtn cwn_reMakeConstraints:^(UIView *maker) {
            maker.rightToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(maxWidth);
        }];
    }
    // 中间文字
    if (title&&title.length) {
        self.titleLabel.text = title;
        maxWidth = MIN(maxWidth, kScreenWidth);
        [self.titleLabel cwn_reMakeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).leftToSuper(maxWidth);
        }];
    }
}

// !!!: 设置左右图片
-(void)setTitle:(NSString *)title leftImage:(NSString *)leftImg rightImage:(NSString *)rightImg{
    [self setTitle:title leftImage:leftImg leftText:nil rightImage:rightImg rightText:nil];
}

// !!!: 设置左右文字
-(void)setTitle:(NSString*)title leftText:(NSString*)leftText rightText:(NSString *)rightText{
    [self setTitle:title leftImage:nil leftText:leftText rightImage:nil rightText:rightText];
}

// !!!: 设置左图右文
-(void)setTitle:(NSString *)title leftImage:(NSString *)leftImg rightText:(NSString *)rightText{
    [self setTitle:title leftImage:leftImg leftText:nil rightImage:nil rightText:rightText];
}

// !!!: 设置左文右图
-(void)setTitle:(NSString*)title leftText:(NSString*)leftText rightImage:(NSString *)rightImg{
    [self setTitle:title leftImage:nil leftText:leftText rightImage:rightImg rightText:nil];
}


// !!!: 设置自定义视图
-(void)setCenterView:(UIView *)centerView leftView:(UIView *)leftView rightView:(UIView *)rightView{
    CGFloat defaultWidth = kNavigationbarHeight-kStatusBarHeight;
    CGFloat maxWidth = defaultWidth;
    if (leftView) {
        [self addSubview:leftView];
        maxWidth = MAX(maxWidth, leftView.viewWidth);
        maxWidth = MIN(maxWidth, kScreenWidth/2.0);
        [leftView cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(15).centerYtoSuper(kStatusBarHeight/2.0).height(maker.viewHeight).width(maker.viewWidth);
        }];
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftClickEvent)];
        [leftView addGestureRecognizer:tap];
    }
    if (rightView) {
        [self addSubview:rightView];
        maxWidth = MAX(maxWidth, rightView.viewWidth);
        maxWidth = MIN(maxWidth, kScreenWidth/2.0);
        [rightView cwn_makeConstraints:^(UIView *maker) {
            maker.rightToSuper(15).centerYtoSuper(kStatusBarHeight/2.0).height(maker.viewHeight).width(maker.viewWidth);
        }];
        // 添加手势
        rightView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightClickEvent)];
        [rightView addGestureRecognizer:tap];
    }
    if (centerView) {
        [self addSubview:centerView];
        maxWidth = MIN(maxWidth, kScreenWidth);
        [centerView cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).centerYtoSuper(kStatusBarHeight/2.0).height(maker.viewHeight).width(maker.viewWidth);
        }];
    }
}



#pragma mark - <************************** 代理方法 **************************>
-(void)leftClickEvent{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(navigationViewLeftClickEvent)]) {
        [self.delegate navigationViewLeftClickEvent];
    }
}

-(void)rightClickEvent{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(navigationViewRightClickEvent)]) {
        [self.delegate navigationViewRightClickEvent];
    }
}



#pragma mark - <************************** 通知 **************************>
// !!!: 屏幕旋转方向
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    UIDevice *device = [UIDevice currentDevice] ;
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            self.self_top.constant = -(self.viewHeight - kNavigationbarHeight);
            break;
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            self.self_top.constant = 0;
            break;
        default:
            DLog(@"无法辨识");
            break;
    }
}

@end
