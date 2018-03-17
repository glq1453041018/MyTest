//
//  ClassInfoTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoTableViewCell.h"

@implementation ClassInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end







@implementation ClassInfoTableViewCell_Title

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)loadData:(NSArray *)data{
    self.data = data;
    
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[ClassInfoTitleItemView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (data.count) {
        CGFloat width = kScreenWidth / data.count;
        for (int i=0; i<data.count; i++) {
            ClassInfoModel *cim = data[i];
            ClassInfoTitleItemView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTitleItemView" owner:nil options:nil] firstObject];
            itemView.titleLabel.text = cim.key.length?cim.key:@"-";
            itemView.detailLabel.text = cim.value.length?cim.value:@"-";
            [itemView.tapBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            itemView.tapBtn.tag = i;
            itemView.centerX = width/2.0 * (2*i+1);
            [self addSubview:itemView];
        }
    }
}

-(void)click:(UIButton*)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(classInfoTableViewCell_TitleClickEvent:data:)]) {
        [self.delegate classInfoTableViewCell_TitleClickEvent:btn.tag data:self.data[btn.tag]];
    }
}

@end





@implementation ClassInfoTableViewCell_PingJia

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView.noAnimation = YES;
    self.starView.tinColor = kDarkOrangeColor;
    self.starView.userInteractionEnabled = NO;
    
    self.starLabel.textColor = kDarkOrangeColor;

}


@end





@implementation ClassInfoTableViewCell_Item

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailLabel.textColor = KColorTheme;
}

@end
