//
//  ClassCommentManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentManager.h"
#import "NSArray+ExtraMethod.h"

@interface ClassCommentManager ()<PhotoBrowserDelegate>
@end

@implementation ClassCommentManager

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock{
    // 配置相关地址和参数

    
    NSMutableArray *cells = [NSMutableArray array];
    NSInteger number = 10;
    // 创建cell
    ClassSpaceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceTableViewCell" owner:nil options:nil] firstObject];
    for (int i=0; i<number; i++) {
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
        [cells addObject:csm];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (responseBlock) {
            responseBlock(cells,nil);
        }
    });
}

+(CGFloat)getMediaViewHeight:(ClassSpaceModel*)csm{
    CGFloat height = 0;
    if (csm.pics.count==0) {
        return height;
    }
    CGFloat space = 5;
    CGFloat width_total = AdaptedWidthValue(355);
    CGFloat width_item = (width_total-space*2)/3.0;
    NSInteger i = csm.pics.count;
    NSInteger row = ceilf(i/3.0);
    height = row * width_item + (row-1) * space;
    return height;
}

// !!!: 添加图片控件
+(void)addPicsWithModel:(ClassSpaceModel*)csm{
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
        [btn setImage:[UIImage imageNamed:urlString] forState:UIControlStateNormal];
        [btn sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zhanweifu"]];
        [btns addObject:btn];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.tag = i;
        [csm.mediaView addSubview:btn];
    }
    csm.picViews = btns;
    UIButton *lastBtn = btns.lastObject;
    csm.mediaView.viewSize = CGSizeMake(width_total, lastBtn.frame.size.height+lastBtn.frame.origin.y);
}

// !!!: 移除图片控件
+(void)removePicsWithModel:(ClassSpaceModel*)csm{
    [csm.mediaView removeFromSuperview];
    csm.mediaView = nil;
    csm.picViews = nil;
}


// !!!: 转换为富文本内容
+(NSMutableAttributedString*)changeToAttr:(NSString*)content{
    NSMutableAttributedString *attr = nil;
    if (content.length==0||content==nil) {
        return attr;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    attr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:FontSize_16],
                                                                                  NSParagraphStyleAttributeName:style
                                                                                  }];
    return attr;
}



// !!!: 加载视图
-(void)loadData:(NSArray *)data cell:(ClassSpaceTableViewCell*)cell index:(NSInteger)index pageSize:(NSInteger)pageSize{
    ClassSpaceModel *csm = data[index];
    // content
    [cell.headerBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:csm.headerIcon] forState:UIControlStateNormal placeholderImage:kPlaceholderImage];
    cell.userNamelLabel.text = [NSString stringWithFormat:@"%ld row",index];
    cell.contentLabel.attributedText = csm.contentAttring;
    cell.starView.scorePercent = MIN(csm.starNum, 5.0) / 5.0;
    
    
    [LLTableCellOptimization handleTableData:data.count currentIndex:index pageSize:pageSize deleteRange:^(NSRange range) {
        for (NSInteger i=range.location; i<range.location+range.length; i++) {
            ClassSpaceModel *csmTmp = data[i];
            [ClassCommentManager removePicsWithModel:csmTmp];
        }
    } addRange:^(NSRange range) {
        for (NSInteger i=range.location; i<range.location+range.length; i++) {
            ClassSpaceModel *csmTmp = data[i];
            if (csmTmp.mediaView.subviews.count==0) {
                if (csmTmp.pics.count) {
                }
                [ClassCommentManager addPicsWithModel:csmTmp];
            }
        }
    }];
    
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
    PhotoBrowser *photoBroser = [PhotoBrowser showURLImages:csm.pics placeholderImage:kPlaceholderImage selectedIndex:btn.tag selectedView:btn];
    objc_setAssociatedObject(photoBroser, @"photoBrowser", csm, OBJC_ASSOCIATION_RETAIN);
    photoBroser.delegate = self;
}

// !!!:图片切换代理
- (UIView *)photoBrowser:(PhotoBrowser *)photoBrowser didScrollToPage:(NSInteger)currentPage{
    ClassSpaceModel *csm = objc_getAssociatedObject(photoBrowser, @"photoBrowser");
    if(csm){
        UIButton *btn = [csm.picViews objectAtIndexNotOverFlow:currentPage];
        if(btn){
            return btn;
        }
    }
    return nil;
}

@end
