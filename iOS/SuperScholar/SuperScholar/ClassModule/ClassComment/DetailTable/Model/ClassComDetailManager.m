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
    NSArray *contents = @[
                          @"一天当中，我们起码应该挤出十分钟的宁静，让自己有喘一口气的闲暇，有一个可以让阳光照进来的间隙。长期处在动荡、嘈杂的生活中，会迷失方向、烦乱而浮躁。",
                          @"有一种路程叫万水千山，有一种情意叫海枯石烂。有一种约定叫天荒地老，有一种记忆叫刻骨铭心。有一种思念叫望穿秋水，有一种爱情叫至死不渝。有一种幸福叫天长地久，有一种拥有叫别无所求。有一种遥远叫天涯海角，有一种思念叫肝肠寸断，还有一种叫失恋无言以对。",
                          @"曾经在千年树下等候，只求你回眸一笑，曾经在菩提下焚香，只为等一世轮回的相遇。阡陌红尘，终究一场繁花落寞，回忆在岁月中飘落了谁的眼泪，往事在时间中飘落谁的忧伤。如烟往事，不知谁飘落了谁的相思，如梦的回忆，不知谁飘落了谁的等待。与你作别，不问曾经伤痛几何。",
                          @"喜欢一个人，在一起的时候会很开心。爱一个人，在一起的时候会莫名的失落。喜欢一个人，永远是欢乐，爱一个人，你会常常流泪。喜欢一个人，当你想起他会微微一笑。爱一个人，当你想起他会对着天空发呆。喜欢一个人，是看到了他的优点。爱一个人，是包容了他的缺点。喜欢，是一种心情，爱，是一种感情。",
                          ];
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
    // 创建消息主体cell
    ClassSpaceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceTableViewCell" owner:nil options:nil] firstObject];
    ClassSpaceModel *csm = [ClassSpaceModel new];
    NSInteger ran = getRandomNumberFromAtoB(0, 10)%4;
    csm.content = contents[ran];
    csm.contentAttring = [self changeToAttr:csm.content];
    csm.starNum = getRandomNumberFromAtoB(0, 5);
    NSMutableArray *pics = [NSMutableArray array];
    for (int j=0; j<getRandomNumberFromAtoB(0, 9); j++) {
        [pics addObject:picsUrl[getRandomNumberFromAtoB(0, 8)]];
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
    for (int i=0; i<20; i++) {
        ClassComItemModel *itemModel = [ClassComItemModel new];
        itemModel.userName = [NSString stringWithFormat:@"啦啦%d号",i];
        itemModel.icon = @"bgImage";
        itemModel.comment = contents[ran];
        itemModel.commentAttr = [self changeToAttr:itemModel.comment];
        itemModel.date = @"2018-3-19";
        cellDetail.commentLabel.text = itemModel.comment;
        CGSize size = [cellDetail.commentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(305), MAXFLOAT)];
        itemModel.commentLabelHeight = size.height;
        itemModel.cellHeight = cellDetail.commentLabel.y + itemModel.commentLabelHeight + 10;
        itemModel.cellHeight += itemModel.more?cellDetail.moreLabel.viewHeight:0;   // 是否有更多
        [items addObject:itemModel];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [PhotoBrowser showURLImages:csm.pics placeholderImage:[UIImage imageNamed:@"zhanweitu"] selectedIndex:btn.tag];
}



// !!!: 加载回复视图
-(void)loadResponseCell:(ClassComDetailTableViewCell *)cell index:(NSInteger)index{
    ClassComItemModel *ccim = self.dataModel.responses[index];
    cell.userNameLabel.text = ccim.userName;
    cell.commentLabel.attributedText = ccim.commentAttr;
    cell.iconImageView.image = [UIImage imageNamed:ccim.icon];
    cell.dateLabel.text = ccim.date;
    cell.commentLabel.text = ccim.comment;
    
    // frame
    cell.commentLabel.viewHeight = ccim.commentLabelHeight;
    cell.moreLabel.y = cell.commentLabel.bottom;
    cell.moreLabel.hidden = !ccim.more;
    cell.rowView.y = ccim.cellHeight-1;
}


@end
