//
//  ClassComDetailTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassComDetailTableViewCell.h"

@implementation ClassComDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrame];
    
    self.userNameLabel.textColor = FontSize_colorgray;
    
    self.moreLabel.textColor = KColorTheme;
    self.iconImageView.layer.cornerRadius = self.iconImageView.viewHeight / 2.0;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.moreLabel.layer.cornerRadius = 2;
    self.moreLabel.layer.masksToBounds = YES;
    self.moreLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.rowView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
}


@end
