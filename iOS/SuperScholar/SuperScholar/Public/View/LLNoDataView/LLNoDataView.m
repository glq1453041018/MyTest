//
//  LLNoDataView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "LLNoDataView.h"
@interface LLNoDataView ()
@property (copy ,nonatomic) NSString *image;
@property (copy ,nonatomic) NSString *tip;
@property (copy ,nonatomic) NSString *title;
@property (strong ,nonatomic) UIView *contentView;  // 内容视图
@end
@implementation LLNoDataView

-(UIImageView *)imageView{
    if (_imageView==nil) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}


-(UILabel *)tipLabel{
    if (_tipLabel==nil) {
        _tipLabel = [UILabel new];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:15];
        _tipLabel.numberOfLines = 0;
        _tipLabel.adjustsFontSizeToFitWidth = YES;
        _tipLabel.textColor = HexColor(0x999999);
        _tipLabel.viewHeight = AdaptedWidthValue(50);
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

-(UIButton *)tipBtn{
    if (_tipBtn==nil) {
        _tipBtn = [UIButton new];
        _tipBtn.backgroundColor = KColorTheme;
        _tipBtn.layer.cornerRadius = 5;
        _tipBtn.layer.masksToBounds = YES;
        [_tipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_tipBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_16]];
        _tipBtn.viewHeight = AdaptedWidthValue(40);
        [self.contentView addSubview:_tipBtn];
    }
    return _tipBtn;
}

-(UIView *)contentView{
    if (_contentView==nil) {
        _contentView = [UIView new];
        [self addSubview:_contentView];
    }
    return _contentView;
}


-(void)setImage:(NSString *)image tip:(NSString *)tip btnTitle:(NSString *)title{
    if (image.length) {
        self.image = image;
        self.imageView.image = [UIImage imageNamed:image];
        self.imageView.viewSize = self.imageView.image.size;
    }
    if (tip.length) {
        self.tip = tip;
        self.tipLabel.text = tip;
    }
    if (title.length) {
        self.title = title;
        [self.tipBtn setTitle:title forState:UIControlStateNormal];
    }
//    [self layoutIfNeeded];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.viewWidth = self.bounds.size.width;
    CGFloat maxHeight = 0;
    if (self.image) {
        self.imageView.centerX = self.contentView.bounds.size.width/2.0;
        self.imageView.y = maxHeight;
        maxHeight += self.imageView.viewHeight;
    }
    if (self.tip) {
        self.tipLabel.viewWidth = self.viewWidth;
        self.tipLabel.centerX = self.contentView.bounds.size.width/2.0;
        self.tipLabel.y = maxHeight;
        maxHeight += self.tipLabel.viewHeight;
    }
    if (self.title) {
        self.tipBtn.viewWidth = MIN(self.viewWidth, AdaptedWidthValue(270));
        self.tipBtn.centerX = self.contentView.bounds.size.width/2.0;
        self.tipBtn.y = maxHeight;
        maxHeight += self.tipBtn.viewHeight;
    }
    self.contentView.viewHeight = maxHeight;
    self.contentView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
}



@end
