//
//  LLNavigationView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLNavigationViewDelegate <NSObject>
@optional
-(void)navigationViewLeftClickEvent;
-(void)navigationViewRightClickEvent;
@end

@interface LLNavigationView : UIView
@property (strong ,nonatomic) UIButton *letfBtn;
@property (strong ,nonatomic) UIButton *rightBtn;
@property (strong ,nonatomic) UILabel *titleLabel;
@property (nonatomic,weak) id <LLNavigationViewDelegate> delegate;

/**
 设置左右图片
 */
-(void)setTitle:(NSString*)title leftImage:(NSString*)leftImg rightImage:(NSString *)rightImg;

/**
 设置左右文字
 */
-(void)setTitle:(NSString*)title leftText:(NSString*)leftText rightText:(NSString *)rightText;

/**
 设置左图右文
 */
-(void)setTitle:(NSString*)title leftImage:(NSString*)leftImg rightText:(NSString *)rightText;

/**
 设置左文右图
 */
-(void)setTitle:(NSString*)title leftText:(NSString*)leftText rightImage:(NSString *)rightImg;

/**
 设置自定义视图，如果是自定义可分别设置 [letfBtn],[rightBtn],[titleLabel] 的frame等设置，并传入对应view
 */
-(void)setCenterView:(UIView*)centerView leftView:(UIView*)leftView rightView:(UIView*)rightView;

@end
