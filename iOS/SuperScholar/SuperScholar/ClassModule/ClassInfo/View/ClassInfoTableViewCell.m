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






@implementation ClassInfoTableViewCell_PingJia

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


@end





@implementation ClassInfoTableViewCell_Item

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.detailLabel.textColor = KColorTheme;
}

@end
