//
//  DataEditTableViewCell.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "DataEditTableViewCell.h"

@implementation DataEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.textLabel.font = [UIFont systemFontOfSize:FontSize_16];
//    self.textLabel.textColor = HexColor(0x333333);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
