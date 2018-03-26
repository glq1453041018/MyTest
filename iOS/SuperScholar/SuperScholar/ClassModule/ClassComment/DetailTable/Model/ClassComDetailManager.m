//
//  ClassComDetailManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassComDetailManager.h"

@implementation ClassComDetailManager
// !!!: 数据模型初始化
-(ClassComDetailModel *)dataModel{
    if (_dataModel==nil) {
        _dataModel = [ClassComDetailModel new];
    }
    return _dataModel;
}



// !!!: 获取数据
-(void)requestDataResponse:(void(^)(BOOL succeed,id error))responseBlock{
    // 配置相关地址和参数
    
    // 创建消息主体cell
    ClassSpaceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceTableViewCell" owner:nil options:nil] firstObject];
    ClassSpaceModel *csm = [ClassSpaceModel new];
    csm.headerIcon = [TESTDATA randomUrlString];
    csm.content = [TESTDATA randomContent];
    csm.contentAttring = [self changeToAttr:csm.content];
    csm.starNum = getRandomNumberFromAtoB(0, 5);
    NSMutableArray *pics = [NSMutableArray array];
    for (int j=0; j<getRandomNumberFromAtoB(0, 9); j++) {
        [pics addObject:[TESTDATA randomUrlString]];
    }
    csm.pics = pics;
    cell.contentLabel.attributedText = csm.contentAttring;
    CGSize size = [cell.contentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(355), MAXFLOAT)];
    csm.contentLabelHeight = size.height + 10*2;
    [self addPicsWithModel:csm];
    csm.cellHeight = cell.contentLabel.y+csm.contentLabelHeight+csm.mediaView.viewHeight+cell.bottomView.viewHeight;
    
    // 回复数组
    // 创建回复cell
    ClassComDetailTableViewCell *cellDetail = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:nil options:nil] firstObject];
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        ClassComItemModel *itemModel = [ClassComItemModel new];
        itemModel.userName = [NSString stringWithFormat:@"啦啦%d号",i];
        itemModel.icon = [TESTDATA randomUrlString];
        itemModel.comment = [TESTDATA randomContent];
        itemModel.commentAttr = [self changeToAttr:itemModel.comment];
        itemModel.date = @"2018-3-19";
        cellDetail.commentLabel.text = itemModel.comment;
        CGSize size = [cellDetail.commentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(305), MAXFLOAT)];
        itemModel.commentLabelHeight = size.height;
        itemModel.moreNum = getRandomNumberFromAtoB(1, 20);
        itemModel.more = YES;
        itemModel.cellHeight = cellDetail.commentLabel.y + itemModel.commentLabelHeight + 10;
        itemModel.cellHeight += itemModel.more?cellDetail.moreLabel.viewHeight+5:0;   // 是否有更多
        [items addObject:itemModel];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (responseBlock) {
            self.dataModel.mainModel = csm;
            self.dataModel.responses = items;
            responseBlock(YES,nil);
        }
    });
    
}

// !!!: 添加图片控件
-(void)addPicsWithModel:(ClassSpaceModel*)csm{
    if (csm.pics.count==0) {
        return;
    }
    CGFloat space = 5;
    CGFloat width_total = AdaptedWidthValue(355);
    CGFloat width_item = (width_total-space*2)/3.0;
    NSMutableArray *btns = [NSMutableArray array];
    for (int i=0; i<csm.pics.count; i++) {
        NSString *urlString = csm.pics[i];
        NSInteger line = i%3;
        NSInteger row = i/3;
        CGPoint center = CGPointMake(width_item/2.0*(2*line+1)+space*line, width_item/2.0*(2*row+1)+space*row);
        UIButton *btn = [UIButton new];
        btn.viewSize = CGSizeMake(width_item, width_item);
        btn.center = center;
        [btn sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:kPlaceholderImage];
        [btns addObject:btn];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.tag = i;
        [csm.mediaView addSubview:btn];
    }
    csm.picViews = btns;
    UIButton *lastBtn = btns.lastObject;
    csm.mediaView.viewSize = CGSizeMake(width_total, lastBtn.frame.size.height+lastBtn.frame.origin.y);
}


// !!!: 转换为富文本内容
-(NSMutableAttributedString*)changeToAttr:(NSString*)content{
    NSMutableAttributedString *attr = nil;
    if (content.length==0||content==nil) {
        return attr;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    attr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:FontSize_16],
                                                                                  NSParagraphStyleAttributeName:style
                                                                                  }];
    return attr;
}


// !!!: 加载视图
-(void)loadCell:(ClassSpaceTableViewCell*)cell{
    ClassSpaceModel *csm = self.dataModel.mainModel;
    // content
    [cell.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:csm.headerIcon] forState:UIControlStateNormal placeholderImage:kPlaceholderHeadImage];
//    cell.userNamelLabel.text = csm.userName;
    cell.contentLabel.attributedText = csm.contentAttring;
    cell.starView.scorePercent = MIN(csm.starNum, 5.0) / 5.0;
    
    for (UIView* viewItem in cell.mediaView.subviews) {
        [viewItem removeFromSuperview];
    }
    [cell.mediaView addSubview:csm.mediaView];
    
    // frame
    cell.contentLabel.viewHeight = csm.contentLabelHeight;
    cell.mediaView.top = cell.contentLabel.bottom;
    cell.mediaView.viewSize = csm.mediaView.viewSize;
    cell.bottomView.top = cell.mediaView.bottom;
    
    // 图片
    for (UIButton *btn in csm.picViews) {
        [btn addTarget:self action:@selector(imageActionEvent:) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(btn, @"imageBtn", csm, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

// !!!: 图片点击事件
-(void)imageActionEvent:(UIButton*)btn{
    DLog(@"第%ld个图片",btn.tag);
    ClassSpaceModel *csm = objc_getAssociatedObject(btn, @"imageBtn");
    [PhotoBrowser showURLImages:csm.pics placeholderImage:kPlaceholderImage selectedIndex:btn.tag selectedView:nil];
}



// !!!: 加载回复视图
-(void)loadResponseCell:(ClassComDetailTableViewCell *)cell index:(NSInteger)index{
    ClassComItemModel *ccim = self.dataModel.responses[index];
    [cell.iconImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:ccim.icon] forState:UIControlStateNormal placeholderImage:kPlaceholderHeadImage];
    cell.userNameLabel.text = ccim.userName;
    cell.commentLabel.attributedText = ccim.commentAttr;
    cell.dateLabel.text = ccim.date;
    cell.commentLabel.text = ccim.comment;
    cell.moreLabel.text = [NSString stringWithFormat:@"  查看%ld回复 >",ccim.moreNum];
    
    // frame
    cell.commentLabel.viewHeight = ccim.commentLabelHeight;
    cell.moreLabel.y = cell.commentLabel.bottom + 5;
    cell.moreLabel.hidden = !ccim.more;
    cell.rowView.y = ccim.cellHeight-0.5;
}


@end
