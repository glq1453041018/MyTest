//
//  ClassSpaceHeadView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassSpaceHeadView.h"

@implementation ClassSpaceHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self adjustFrame];
    
    self.iconImageView.layer.masksToBounds = YES;
}

@end
