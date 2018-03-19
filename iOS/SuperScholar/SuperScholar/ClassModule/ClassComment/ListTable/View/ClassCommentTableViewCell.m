//
//  ClassCommentTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentTableViewCell.h"
#import "ClassCommentModel.h"
#import "PhotoBrowser.h"

@implementation ClassCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self adjustFrame];
    
    // 评分视图
    self.starView.noAnimation = YES;
    self.starView.tinColor = kDarkOrangeColor;
    self.starView.userInteractionEnabled = NO;
    
}
// !!!: 加载视图
-(void)loadData:(NSArray *)data index:(NSInteger)index pageSize:(NSInteger)pageSize{
    ClassCommentModel *ccm = data[index];
    // content
    self.userNamelLabel.text = [NSString stringWithFormat:@"%ld row",index];
    self.contentLabel.attributedText = ccm.contentAttring;
    self.starView.scorePercent = MIN(ccm.starNum, 5.0) / 5.0;
    DLog(@"%f分评价",ccm.starNum);
    
    NSInteger totalPage = data.count/pageSize;
    NSInteger currentPage = index/pageSize;
    BOOL needOperate = NO;
    if (index % pageSize==0) {
        needOperate = YES;
    }
    if (needOperate) {  // 需要进行操作
        if (currentPage>=2) {   // 删除当前页的 前2和后2页的数据，并创建当前页
            // 删除 -2 页数据
            for (NSInteger i=(currentPage-2)*pageSize; i<(currentPage-1)*pageSize; i++) {
                ClassCommentModel *ccmTmp = data[i];
                [ClassCommentManager removePicsWithModel:ccmTmp];
            }
            if (currentPage<=totalPage-2) {
                // 删除 +2 页数据
                for (NSInteger j=(currentPage+1)*pageSize; j<(currentPage+2)*pageSize; j++) {
                    ClassCommentModel *ccmTmp = data[j];
                    [ClassCommentManager removePicsWithModel:ccmTmp];
                }
            }
        }
    }
    
    // 创建
    for (NSInteger i=MAX((currentPage-1)*pageSize, 0); i<MIN(data.count, (currentPage+1)*pageSize); i++) {
        ClassCommentModel *ccmTmp = data[i];
        if (ccmTmp.mediaView.subviews.count==0) {
            if (ccmTmp.pics.count) {
            }
            [ClassCommentManager addPicsWithModel:ccmTmp];
        }
    }
    
    for (UIView* viewItem in self.mediaView.subviews) {
        [viewItem removeFromSuperview];
    }
    [self.mediaView addSubview:ccm.mediaView];
    
    // frame
    self.contentLabel.viewHeight = ccm.contentLabelHeight;
    self.mediaView.top = self.contentLabel.bottom;
    self.mediaView.viewSize = ccm.mediaView.viewSize;
    self.bottomView.top = self.mediaView.bottom;
    
    // 图片
    for (UIButton *btn in ccm.picViews) {
        [btn addTarget:self action:@selector(imageActionEvent:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(btn, @"imageBtn", ccm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(void)imageActionEvent:(UIButton*)btn{
    DLog(@"第%ld个图片",btn.tag);
    ClassCommentModel *ccm = objc_getAssociatedObject(btn, @"imageBtn");
    [PhotoBrowser showURLImages:ccm.pics placeholderImage:[UIImage imageNamed:@"zhanweitu"] selectedIndex:btn.tag];
}

@end
