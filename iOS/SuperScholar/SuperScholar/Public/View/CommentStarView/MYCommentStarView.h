//
//  MYCommentStarView.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/6/27.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>//外界只需对frame设置就好，每次frame设置(比如适配本视图)都会根据新frame高确定星星大小及位置
@class MYCommentStarView;

@protocol MYCommentStarViewDelegate <NSObject>

- (void)commentStarView:(MYCommentStarView *)starView scoreChanged:(CGFloat)score;//分数，满分5分

@end


@class MYCommentStarView;

@interface MYCommentStarView : UIView

@property (assign ,nonatomic) BOOL noAnimation;
@property (strong ,nonatomic) UIColor *tinColor;

@property (assign, nonatomic) CGFloat scorePercent;//得分比，范围为0--1
@property (assign, nonatomic) NSInteger minimumScore;//允许最小的分数(星星数)，范围0-5

@property (assign, nonatomic) BOOL allowIncompleteStar;//评分时是否允许半颗星，默认为YES
@property (assign, nonatomic) CGFloat duration;//移动一颗星星所需动画时间

@property (weak, nonatomic) id <MYCommentStarViewDelegate> delegate;

@end
