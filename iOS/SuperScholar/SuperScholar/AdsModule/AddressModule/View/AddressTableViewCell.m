//
//  AddressTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/27.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressTableViewCell.h"

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableArray *)subViews{
    if (_subViews==nil) {
        _subViews = [NSMutableArray array];
    }
    return _subViews;
}

@end
