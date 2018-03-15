//
//  ClassSapceTableViewCell.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassSapceTableViewCell.h"
#import "ClassSapceManager.h"
#import "PhotoBrowser.h"

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
-(void)loadData:(NSArray *)data index:(NSInteger)index pageSize:(NSInteger)pageSize{
    ClassSapceModel *csm = data[index];
    // content
    self.userNamelLabel.text = [NSString stringWithFormat:@"%ld row",index];
    self.contentLabel.attributedText = csm.contentAttring;
    
    
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
                ClassSapceModel *csmTmp = data[i];
                [ClassSapceManager removePicsWithModel:csmTmp];
            }
            if (currentPage<=totalPage-2) {
                // 删除 +2 页数据
                for (NSInteger j=(currentPage+1)*pageSize; j<(currentPage+2)*pageSize; j++) {
                    ClassSapceModel *csmTmp = data[j];
                    [ClassSapceManager removePicsWithModel:csmTmp];
                }
            }
        }
    }
    
    // 创建
    for (NSInteger i=MAX((currentPage-1)*pageSize, 0); i<MIN(data.count, (currentPage+1)*pageSize); i++) {
        ClassSapceModel *csmTmp = data[i];
        if (csmTmp.mediaView.subviews.count==0) {
            if (csmTmp.pics.count) {
            }
            [ClassSapceManager addPicsWithModel:csmTmp];
        }
    }
    
    for (UIView* viewItem in self.mediaView.subviews) {
        [viewItem removeFromSuperview];
    }
    [self.mediaView addSubview:csm.mediaView];
    
    // frame
    self.contentLabel.viewHeight = csm.contentLabelHeight;
    self.mediaView.top = self.contentLabel.bottom;
    self.mediaView.viewSize = csm.mediaView.viewSize;
    self.bottomView.top = self.mediaView.bottom;
    
    // 图片
    for (UIButton *btn in csm.picViews) {
        [btn addTarget:self action:@selector(imageActionEvent:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(btn, @"imageBtn", csm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(void)imageActionEvent:(UIButton*)btn{
    DLog(@"第%ld个图片",btn.tag);
    ClassSapceModel *csm = objc_getAssociatedObject(btn, @"imageBtn");
    [PhotoBrowser showURLImages:csm.pics placeholderImage:[UIImage imageNamed:@"zhanweitu"] selectedIndex:btn.tag];
}


@end
