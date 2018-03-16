//
//  ClassInfoFootView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoFootView.h"

@implementation ClassInfoFootView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self adjustFrame];
    
    [self.chatBtn setBackgroundColor:kDarkOrangeColor];
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    path.lineWidth = 0.5;
    [kDarkOrangeColor setStroke];
    [path stroke];
}


@end
