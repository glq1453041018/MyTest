//
//  UIViewController+Based.h
//  BasedVC
//
//  Created by LOLITA on 2017/7/10.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndicatorView.h"
#import "LLNavigationView.h"

@interface UIViewController (Based)<LLNavigationViewDelegate,UIGestureRecognizerDelegate>


// !!!: ------------------------------------------属性类------------------------------------------
/**
 加载视图
 */
@property (strong,nonatomic)IndicatorView *loadingView;

/**
 导航栏
 */
@property (strong, nonatomic) LLNavigationView *navigationBar;

/**
 是否需要滑动返回手势
 */
@property (assign, nonatomic)BOOL isNeedGoBack;

/**
 事件锁，可由此控制页面某个事件的触发频率
 */
@property (assign, nonatomic, getter=isEvent_locked) BOOL event_locked;







// !!!: ------------------------------------------方法类------------------------------------------
/**
 强制更新检测
 */
-(void)checkAppForUpdatesForced;

/**
 手动更新检测
 */
-(void)checkAppForUpdatesUnForced;

/**
 获取网络连接状态
 */
- (BOOL)getNetworkState;


@end
