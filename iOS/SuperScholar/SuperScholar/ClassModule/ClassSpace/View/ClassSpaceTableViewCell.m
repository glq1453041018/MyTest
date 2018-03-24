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
    
    // 操作事件
    [self.headerBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.headerBtn.tag = ClassCellHeadClickEvent;
    [self.likeBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn.tag = ClassCellLikeClickEvent;
    [self.commentBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn.tag = ClassCellCommentClickEvent;
}

-(void)btnAction:(UIButton*)btn{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(classSpaceTableViewCellClickEvent:)]) {
        [self.delegate classSpaceTableViewCellClickEvent:btn.tag];
    }
}

@end
