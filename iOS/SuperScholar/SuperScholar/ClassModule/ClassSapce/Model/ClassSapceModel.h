//
//  ClassSapceModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassSapceModel : NSObject

@property (copy ,nonatomic) NSString *headerIcon;
@property (copy ,nonatomic) NSString *userName;
@property (copy ,nonatomic) NSString *time;
@property (copy ,nonatomic) NSString *content;

@property (assign ,nonatomic) NSInteger viewNum;
@property (assign ,nonatomic) NSInteger likeNum;
@property (assign ,nonatomic) NSInteger commentNum;

@property (copy ,nonatomic) NSArray *pics;              // 图片数组

@property (assign ,nonatomic) CGFloat contentLabelHeight;
@property (assign ,nonatomic) CGFloat cellHeight;
@property (strong ,nonatomic) UIView *mediaView;
@property (copy ,nonatomic) NSMutableArray *picViews;
@end







