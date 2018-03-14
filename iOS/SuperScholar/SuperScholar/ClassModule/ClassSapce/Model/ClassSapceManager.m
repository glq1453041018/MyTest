//
//  ClassSapceManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassSapceManager.h"

@implementation ClassSapceManager

// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock{
    NSArray *contents = @[
                          @"水电费就是封建势力的开发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方就 看老师的九分裤设计的肌肤立即受到了饭就流口水的肌肤",
                          @"发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方",
                          @"发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方发建设快乐的肌肤克赖斯基风口浪尖上看到了就分开就开始了对方"
                          ];
    NSArray *picsUrl = @[
                         @"http://img02.tooopen.com/images/20150507/tooopen_sy_122395947985.jpg",
                         @"http://pic2.nipic.com/20090424/1242397_110033072_2.jpg",
                         @"http://img.zcool.cn/community/0191f1589c3469a8012060c83cebf3.jpg@1280w_1l_2o_100sh.png",
                         @"http://img.sccnn.com/bimg/338/34264.jpg",
                         @"http://img.zcool.cn/community/0166e959ac1386a801211d25c63563.jpg@1280w_1l_2o_100sh.jpg",
                         @"http://img.zcool.cn/community/0190b359772978a8012193a34ea33b.jpg@1280w_1l_2o_100sh.jpg",
                         @"http://img.taopic.com/uploads/allimg/121014/234931-1210140JK414.jpg",
                         @"http://img03.tooopen.com/uploadfile/downs/images/20110714/sy_20110714135215645030.jpg",
                         @"http://img05.tooopen.com/images/20140328/sy_57865838889.jpg"
                         ];
    NSMutableArray *cells = [NSMutableArray array];
    NSInteger number = 10;
    for (int i=0; i<number; i++) {
        ClassSapceModel *csm = [ClassSapceModel new];
        NSInteger ran = getRandomNumberFromAtoB(0, 10)%3;
        csm.content = contents[ran];
        NSMutableArray *pics = [NSMutableArray array];
        for (int j=0; j<getRandomNumberFromAtoB(0, 9); j++) {
            [pics addObject:picsUrl[getRandomNumberFromAtoB(0, 8)]];
        }
        csm.pics = pics;
        // 创建cell
        ClassSapceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSapceTableViewCell" owner:nil options:nil] firstObject];
        cell.contentLabel.text = csm.content;
        CGSize size = [cell.contentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(355), MAXFLOAT)];
        csm.contentLabelHeight = size.height + 5*2;
        [self handlePics:csm.pics withModel:csm];
        csm.cellHeight = cell.contentLabel.y+csm.contentLabelHeight+csm.mediaView.bottom+cell.bottomView.viewHeight;
        
        [cells addObject:csm];
    }
    if (responseBlock) {
        responseBlock(cells,nil);
    }
}



+(void)handlePics:(NSArray*)pics withModel:(ClassSapceModel*)csm{
    if (pics.count==0||csm.picViews.count) {
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
        [btn sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"testImg"]];
        [btns addObject:btn];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.tag = i;
        [csm.mediaView addSubview:btn];
    }
    csm.picViews = btns;
    UIButton *lastBtn = btns.lastObject;
    csm.mediaView.viewSize = CGSizeMake(width_total, lastBtn.frame.size.height+lastBtn.frame.origin.y);
}



@end
