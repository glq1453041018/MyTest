//
//  UIViewController+Based.m
//  BasedVC
//
//  Created by LOLITA on 2017/7/10.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

#import "UIViewController+Based.h"
#import <objc/runtime.h>
#import <AFNetworking.h>
//#import "LLAlertView.h"
@implementation UIViewController (Based)

#pragma mark - ***************************************---加载视图---***************************************
-(IndicatorView *)loadingView{
    IndicatorView *loading = objc_getAssociatedObject(self, _cmd);
    if (loading==nil) {
        loading = [[IndicatorView alloc] initWithType:IndicatorTypeBounceSpot3 tintColor:[UIColor redColor]];
        [self.view addSubview:loading];
//        loading.center = CGPointMake(kScreenWidth/2.0, (kScreenHeight-kNavigationbarHeight)/2.0+kNavigationbarHeight);
        [loading cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).centerYtoSuper(0).width(maker.viewWidth).height(maker.viewHeight);
        }];
        objc_setAssociatedObject(self, @selector(loadingView), loading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return loading;
}
-(void)setLoadingView:(IndicatorView *)loadingView{
    objc_setAssociatedObject(self, @selector(loadingView), loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}





#pragma mark - ***************************************---导航视图---***************************************
-(LLNavigationView *)navigationBar{
    LLNavigationView *navBar = objc_getAssociatedObject(self, _cmd);
    if (navBar==nil) {
        navBar = [[LLNavigationView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kNavigationbarHeight)];
        objc_setAssociatedObject(self, @selector(navigationBar), navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        navBar.backgroundColor = KColorTheme;
        navBar.delegate = self;
        [self.view addSubview:navBar];
    }
    return navBar;
}
-(void)setNavigationBar:(LLNavigationView *)navigationBar{
    objc_setAssociatedObject(self, @selector(navigationBar), navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - ***************************************---返回手势---***************************************
-(BOOL)isNeedGoBack{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setIsNeedGoBack:(BOOL)isNeedGoBack{
    objc_setAssociatedObject(self, @selector(isNeedGoBack), [NSNumber numberWithBool:isNeedGoBack], OBJC_ASSOCIATION_ASSIGN);
    if (isNeedGoBack) {
        // 获取系统自带滑动手势的target对象
        id target = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
        // 设置手势代理，拦截手势触发
        pan.delegate=self;
        // 给导航控制器的view添加全屏滑动手势
        [self.view addGestureRecognizer:pan];
        // 禁止使用系统自带的滑动手势
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if(self.navigationController.childViewControllers.count == 1){
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}
-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pag{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - ***************************************---页面级按钮锁---***************************************
- (void)setEvent_locked:(BOOL)event_locked{
    objc_setAssociatedObject(self, @selector(isEvent_locked), @(event_locked), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isEvent_locked{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}





#pragma mark - ***************************************---检测更新---***************************************

/**
 根据服务器判定检查更新的探测，强制或者手动
 参数：(1:当服务端为强制更新则YES与NO无影响)(0:当服务端为手动更新则YES需要弹窗NO不需要弹窗)
 
 @param canTancun 弹窗是否出现
 */
+(void)checkAppForUpdates:(BOOL)canTancun{
//    [DengLuData banBenPanDuan:^(NSMutableArray *arry) {
//        BanBenHao *p=arry.firstObject;
//        NSString *strBanBenHao=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        if ([p.value1 isEqualToString:@"1"]) {
//            if ([strBanBenHao isEqualToString:p.versioncode]) {
//            }
//            else if ([p.versioncode compare:strBanBenHao] == NSOrderedAscending){
//            }
//            else{
//                [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
//                    if(index == 0){
//                        NSString *address = GetInfoForKey(kIos_huicelue_update_UserDefaults);
//                        if (address.length) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
//                        }
//                    }
//                } message:@"更新版本" buttonTitles:@"确定", nil];
//            }
//        }
//        else if ([p.value1 isEqualToString:@"0"]) {
//            if (!canTancun) return ;
//            if ([strBanBenHao isEqualToString:p.versioncode]) {
//            }
//            else if ([p.versioncode compare:strBanBenHao] == NSOrderedAscending){
//            }
//            else {
//                [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
//                    if(index == 0){
//                        NSString *address = GetInfoForKey(kIos_huicelue_update_UserDefaults);
//                        if (address.length) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
//                        }
//                    }
//                } message:@"版本更新" buttonTitles:@"确定", @"取消", nil];
//                
//            }
//        }
//    }];
}
/**
 强制
 */
-(void)checkAppForUpdatesForced{
//        BanBenHao *p=[MYMemoryDefaults standardUserDefaults].forceUpdateModel;
//        NSString *strBanBenHao=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        
//        if ([p.value1 isEqualToString:@"1"]) {
//            if ([strBanBenHao isEqualToString:p.versioncode]) {
//            }
//            else if ([p.versioncode compare:strBanBenHao] == NSOrderedAscending){
//            }
//            else{
//                [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
//                    if(index == 0){
//                        NSString *address = GetInfoForKey(kIos_huicelue_update_UserDefaults);
//                        if (address.length) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
//                        }
//                    }
//                } message:@"更新版本" buttonTitles:@"确定", nil];
//            }
//        }
}


/**
 手动
 */
-(void)checkAppForUpdatesUnForced{
//    BanBenHao *p=[MYMemoryDefaults standardUserDefaults].forceUpdateModel;
//    NSString *strBanBenHao=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        if ([p.value1 isEqualToString:@"0"]) {
//            if ([strBanBenHao isEqualToString:p.versioncode]) {
//            }
//            else if ([p.versioncode compare:strBanBenHao] == NSOrderedAscending){
//            }
//            else {
//                [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
//                    if(index == 0){
//                        NSString *address = GetInfoForKey(kIos_huicelue_update_UserDefaults);
//                        if (address.length) {
//                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
//                        }
//                    }
//                } message:@"版本更新" buttonTitles:@"确定", @"取消", nil];
//            }
//        }
}

#pragma mark - ***************************************---系统信息获取---***************************************
- (BOOL)getNetworkState{//获取当前网络连接状态
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability =
    SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags =
    SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags) {
        return NO;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL isNetworkEnable =(isReachable && !needsConnection) ? YES : NO;
    return isNetworkEnable;
}



-(void)viewDidLoad{
    DLog(@"进入了：%@,%@",[self class],self.title);
}



@end
