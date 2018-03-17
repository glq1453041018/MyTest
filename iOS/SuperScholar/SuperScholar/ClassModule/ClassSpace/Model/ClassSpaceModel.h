//
//  ClassSapceModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassSpaceModel : NSObject

// !!!: 头部信息
@property (copy ,nonatomic) NSString *headerIcon;
@property (copy ,nonatomic) NSString *userName;
@property (copy ,nonatomic) NSString *time;
@property (copy ,nonatomic) NSString *content;
@property (copy ,nonatomic) NSAttributedString *contentAttring;
@property (assign ,nonatomic) CGFloat starNum;  // 评价星级数

// !!!: 底部信息
@property (assign ,nonatomic) NSInteger viewNum;
@property (assign ,nonatomic) NSInteger likeNum;
@property (assign ,nonatomic) NSInteger commentNum;


// !!!: 多媒体信息
@property (copy ,nonatomic) NSArray *pics;
@property (strong ,nonatomic) UIView *mediaView;
@property (copy ,nonatomic) NSMutableArray *picViews;


@property (assign ,nonatomic) CGFloat contentLabelHeight;
@property (assign ,nonatomic) CGFloat cellHeight;


@end







