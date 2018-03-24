//
//  ClassInfoHeadView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoHeadView.h"

@implementation ClassInfoHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    [self adjustFrame];
    
    NSMutableArray *pics = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        [pics addObject:[TESTDATA randomUrlString]];
    }
    [self.scrollView loadImages:pics estimateSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width , [[UIScreen mainScreen]bounds].size.width *200 / 375.0)];
    self.scrollView.location = locationRight;
    self.scrollView.style = MYPageControlStyleLabel;
    self.scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView.useScaleEffect = YES;
    self.scrollView.needBgView = YES;
    self.scrollView.useVerticalParallaxEffect = YES;
    
    [self.headBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[TESTDATA randomUrlString]] forState:UIControlStateNormal placeholderImage:kPlaceholderImage];
}

@end
