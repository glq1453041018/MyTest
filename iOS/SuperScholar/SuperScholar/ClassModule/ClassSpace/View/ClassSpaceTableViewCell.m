//
//  ClassSapceTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassSpaceTableViewCell.h"

@implementation ClassSpaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrame];
    
    self.headerBtn.layer.masksToBounds = YES;
    self.headerBtn.layer.cornerRadius = self.headerBtn.viewHeight/2.0;
}

@end
