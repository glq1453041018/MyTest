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
    
    NSArray *picsUrl = @[
                         @"http://pic33.photophoto.cn/20141023/0017030062939942_b.jpg",
                         @"http://pic14.nipic.com/20110427/5006708_200927797000_2.jpg",
                         @"http://pic23.nipic.com/20120803/9171548_144243306196_2.jpg",
                         @"http://pic39.nipic.com/20140311/8821914_214422866000_2.jpg",
                         @"http://pic7.nipic.com/20100609/3143623_160732828380_2.jpg",
                         @"http://pic9.photophoto.cn/20081128/0020033015544930_b.jpg",
                         @"http://pic2.16pic.com/00/35/74/16pic_3574684_b.jpg",
                         @"http://pic42.nipic.com/20140605/9081536_142458626145_2.jpg",
                         @"http://pic35.photophoto.cn/20150626/0017029557111337_b.jpg"
                         ];
    [self.scrollView loadImages:picsUrl estimateSize:CGSizeMake([[UIScreen mainScreen]bounds].size.width , [[UIScreen mainScreen]bounds].size.width *200 / 375.0)];
    self.scrollView.location = locationRight;
    self.scrollView.style = MYPageControlStyleLabel;
    self.scrollView.backgroundColor = [UIColor cyanColor];
    self.scrollView.useScaleEffect = YES;
    self.scrollView.needBgView = YES;
    self.scrollView.useVerticalParallaxEffect = YES;
}

@end
