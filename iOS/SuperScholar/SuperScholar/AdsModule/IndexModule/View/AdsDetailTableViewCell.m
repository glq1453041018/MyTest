//
//  AdsDetailTableViewCell.m
//  SuperScholar
//
//  Created by guolq on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsDetailTableViewCell.h"

@implementation AdsDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation AdsDetailTableViewCell_comment
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starView.noAnimation = YES;
    self.starView.tinColor = kDarkOrangeColor;
    self.starView.userInteractionEnabled = NO;
    
    self.starLabel.textColor = kDarkOrangeColor;
}

@end

@implementation AdsDetailTableViewCell_adress



@end
