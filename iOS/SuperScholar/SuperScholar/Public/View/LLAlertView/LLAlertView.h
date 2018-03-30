//
//  LLAlertView.h
//  GuDaShi
//
//  Created by LOLITA on 2017/11/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LLAlertViewBlock)(NSInteger index);

@interface LLAlertView : UIView
@property (copy ,nonatomic) LLAlertViewBlock block;

@property (strong, nonatomic) UIView *backgroundView;

@property (assign ,nonatomic) BOOL isShow;


/**
 是否需要关闭按钮，默认不需要
 */
@property (assign ,nonatomic) BOOL needCloseBtn;

/**
 是否点击背景关闭，默认不需要
 */
@property (assign ,nonatomic) BOOL touchToClose;

/**
 传入自定义视图
 */
@property (strong, nonatomic) UIView *contentView;
/**
 传入自定义动画
 */
@property (strong ,nonatomic) CAAnimation *animation;

/**
 点击背景视图回调
 */
@property (nonatomic,copy) void(^touchBgView)();


/**
 显示
 */
-(void)show;

/**
 隐藏
 */
-(void)hideWithBlock:(void(^)())block;


/**
 显示系统弹窗AlertViewController
 */
+(void)showSystemAlertViewClickBlock:(LLAlertViewBlock)block message:(NSString*)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 显示系统弹窗AlertView , title 默认 “提示”
 */
-(void)showSystemAlertViewClickBlock:(LLAlertViewBlock)block message:(NSString*)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 显示系统弹窗AlertView ,  参数title 
 */
-(UIAlertView *)showSystemAlertViewClickBlock:(LLAlertViewBlock)block AlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end
