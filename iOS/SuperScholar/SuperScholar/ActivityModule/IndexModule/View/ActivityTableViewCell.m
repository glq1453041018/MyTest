//
//  ActivityTableViewCell.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityTableViewCell.h"

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self adjustFrame];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation ActivityTableViewCell_Image
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 4;
    self.image.layer.masksToBounds = YES;
    // Initialization code
}
@end

@implementation ActivityTableViewCell_NO_Image
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end



@implementation ActivityTableViewCell_Video
- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = 4;
    self.image.layer.masksToBounds = YES;
    // Initialization code
}
@end
