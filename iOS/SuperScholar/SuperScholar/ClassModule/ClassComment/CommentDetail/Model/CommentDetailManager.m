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
        itemModel.cellHeight = cellDetail.commentLabel.y + itemModel.commentLabelHeight + 10;
        if (i==0) {                             // 主体部分
            self.mainModel = itemModel;
        }
        else{
            [items addObject:itemModel];        // 回复部分
        }
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    [cell.iconImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:ccim.icon] forState:UIControlStateNormal placeholderImage:kPlaceholderHeadImage];
    cell.userNameLabel.text = ccim.userName;
    cell.dateLabel.text = ccim.date;
    cell.commentLabel.text = ccim.comment;
    
    // frame
    cell.commentLabel.viewHeight = ccim.commentLabelHeight;
    cell.moreLabel.hidden = YES;
    cell.rowView.y = ccim.cellHeight-1;
}




@end
