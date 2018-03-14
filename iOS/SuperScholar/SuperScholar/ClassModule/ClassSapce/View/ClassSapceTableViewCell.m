//
//  ClassSapceTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassSapceTableViewCell.h"

@implementation ClassSapceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// !!!: 加载视图
-(void)loadData:(NSArray *)data index:(NSInteger)index{
    ClassSapceModel *csm = data[index];
    // content
    self.userNamelLabel.text = [NSString stringWithFormat:@"%ld row",index];
    self.contentLabel.text = csm.content;
    
    for (UIView* viewItem in self.mediaView.subviews) {
        [viewItem removeFromSuperview];
    }
    [self.mediaView addSubview:csm.mediaView];
    
    // frame
    self.contentLabel.viewHeight = csm.contentLabelHeight;
    self.mediaView.top = self.contentLabel.bottom;
    self.mediaView.viewSize = csm.mediaView.viewSize;
    self.bottomView.top = self.mediaView.bottom;
}








@end
