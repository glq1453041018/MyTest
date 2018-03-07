//
//  LLNavigationView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "LLNavigationView.h"
@interface LLNavigationView ()
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








#pragma mark - <************************** 设置方法 **************************>
-(void)setTitle:(NSString *)title leftImage:(NSString *)leftImg rightImage:(NSString *)rightImg{
    if (leftImg&&leftImg.length) {
        [self.letfBtn setImage:[UIImage imageNamed:leftImg] forState:UIControlStateNormal];
        [self.letfBtn cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(kNavigationbarHeight);
        }];
    }
    if (rightImg&&rightImg.length) {
        [self.rightBtn setImage:[UIImage imageNamed:rightImg] forState:UIControlStateNormal];
        [self.rightBtn cwn_makeConstraints:^(UIView *maker) {
            maker.rightToSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).width(kNavigationbarHeight);
        }];
    }
    if (title&&title.length) {
        self.titleLabel.text = title;
        [self.titleLabel cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).topToSuper(kStatusBarHeight).bottomToSuper(0).leftToSuper(kNavigationbarHeight);
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


@end
