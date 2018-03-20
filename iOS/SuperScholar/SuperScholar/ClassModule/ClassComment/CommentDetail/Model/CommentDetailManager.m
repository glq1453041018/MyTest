//
//  CommentDetailManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "CommentDetailManager.h"

@implementation CommentDetailManager

#pragma mark - <************************** 数据的初始化 **************************>
-(NSMutableArray *)datas{
    if (_datas==nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}


// !!!: 获取数据
-(void)requestDataResponse:(void(^)(BOOL succeed,id error))responseBlock{
    // 配置相关地址和参数
    NSArray *comments = @[
                          @"破🎫",
                          @"盖章真快啊👨‍🏫",
                          @"薛定谔的猫🐱，最终他妈妈通过微博找到了案件的真凶😄",
                          @"名字真皮啊ℹ️🆙🈚️🐶👎😅😁🐱👌",
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
    // 回复数组
    // 创建回复cell
    ClassComDetailTableViewCell *cellDetail = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:nil options:nil] firstObject];
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        ClassComItemModel *itemModel = [ClassComItemModel new];
        itemModel.userName = [NSString stringWithFormat:@"啦啦%d号",i];
        itemModel.icon = picsUrl[getRandomNumberFromAtoB(0, 100)%9];
        itemModel.comment = comments[getRandomNumberFromAtoB(0, 100)%8];
        itemModel.commentAttr = [self changeToAttr:itemModel.comment];
        itemModel.date = @"2018-3-19";
        cellDetail.commentLabel.text = itemModel.comment;
        CGSize size = [cellDetail.commentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(305), MAXFLOAT)];
        itemModel.commentLabelHeight = size.height;
        itemModel.cellHeight = cellDetail.commentLabel.y + itemModel.commentLabelHeight + 10;
        if (i==0) {                             // 主体部分
            self.mainModel = itemModel;
        }
        else{
            [items addObject:itemModel];        // 回复部分
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (responseBlock) {
            self.datas = items;
            responseBlock(YES,nil);
        }
    });
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





// !!!: 刷新cell
-(void)loadCell:(ClassComDetailTableViewCell*)cell model:(ClassComItemModel*)ccim{
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:ccim.icon] placeholderImage:kPlaceholderHeadImage];
    cell.userNameLabel.text = ccim.userName;
    cell.dateLabel.text = ccim.date;
    cell.commentLabel.text = ccim.comment;
    cell.rowView.backgroundColor = [UIColor lightGrayColor];
    
    // frame
    cell.commentLabel.viewHeight = ccim.commentLabelHeight;
    cell.moreLabel.hidden = YES;
    cell.rowView.y = ccim.cellHeight-1;
}




@end
