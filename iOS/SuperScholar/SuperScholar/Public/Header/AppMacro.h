//
//  AppMacro.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#import "LLAlertView.h"

#pragma mark - <************************** 获取设备大小 **************************>
// 获取屏幕 宽度、高度，支持横屏
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)


#define Screen_Scale [UIScreen mainScreen].scale
#define S_WIDTH @"[UIScreen mainScreen].bounds.size.width-40"
#define IEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define IEW_HEGHT [UIScreen mainScreen].bounds.size.height
//只能用于横屏的时候
#define SCREEN_HEIGHT MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define MAIN_SPWP  SCREEN_WIDTH/667.0
#define MAIN_SPWPW SCREEN_HEIGHT/375.0

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationbarHeight (kStatusBarHeight+44.0)
#define kNavigationbarHeightCtrl (kStatusBarHeight+self.navigationController.navigationBar.frame.size.height)
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49) // 适配iPhone x 底栏高度

#pragma mark - <************************** 打印日志 **************************>
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif



#pragma mark - <************************** 颜色类 **************************>
// rgb颜色转换（16进制->10进制）
#define ColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]

// 获取RGB颜色
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//随机颜色
#define RandColor ColorWithRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))



#pragma mark - <************************** 发消息 **************************>
#define MsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define MsgTarget(target) (__bridge void *)(target)


#pragma mark - <************************** 适配 **************************>
// 以iPhone6为基准，获取缩放比例来设置控件的自适应
#define kScreenWidthRatio (kScreenWidth/375.0)
#define kScreenHeightRatio (kScreenHeight/667.0)
#define AdaptedWidthValue(x) ((x)*kScreenWidthRatio)
#define AdaptedHeightValue(x) ((x)*kScreenWidthRatio)
#define ShiPei(a)  ([UIScreen mainScreen].bounds.size.width/375.0*(a))


#pragma mark - <************************** 其他 **************************>

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define WeakObj(o) __weak typeof(o) weak##o = o

// 保存偏好信息
#define SaveInfoForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

// 获取偏好信息
#define GetInfoForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]

// 删除偏好信息
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}

// 获取随机数
#define getRandomNumberFromAtoB(A,B) (int)(A+(arc4random()%(B-A+1)))

//设置应用角标
#define setBadgeNumber(num)  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num]

// 网络错误提示
#define ServerError_Description(x) ((x)==123?NetworkError_Description:[NSString stringWithFormat:@"网络异常 - code: %ld",(long)(x)])
#define NetworkError_Description @"网络异常，请检查网络状态" //code:123 即无网络
#define NoMoreData_Description @"暂无相关数据"
#define NoMoreData_Image @"NodataImage"

// 警告框架
// 弹出框Controller级，block 为重试回调 （页面无法重新激发且逻辑简单的需要重试）
#define LLAlertControllerRetry(block,code) \
[LLAlertView showSystemAlertViewClickBlock:^(NSInteger index){\
if (index == 1) {\
block();\
}\
} message:ServerError_Description(code) buttonTitles:@"取消",@"重试", nil]
#define LLAlertControllerConfirm(code) [LLAlertView showSystemAlertViewClickBlock:nil message:ServerError_Description(code) buttonTitles:@"确定", nil]
#define LLAlertControllerMsg(msg) [LLAlertView showSystemAlertViewClickBlock:nil message:msg buttonTitles:@"确定", nil]
// 弹出框window级
//#define Alert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]
#define LLAlert(msg) [[[LLAlertView alloc]init]showSystemAlertViewClickBlock:nil message:msg buttonTitles:@"确定", nil]
#define Alert(title,msg) [[[LLAlertView alloc]init]showSystemAlertViewClickBlock:nil AlertViewTitle:title  message:msg buttonTitles:@"确定", nil]
#define LLAlertViewRetry(block,code) [[[LLAlertView alloc]init]showSystemAlertViewClickBlock:block message:ServerError_Description(code) buttonTitles:@"取消",@"重试", nil]
#define LLAlertViewConfirm(code) [[[LLAlertView alloc]init]showSystemAlertViewClickBlock:nil message:ServerError_Description(code) buttonTitles:@"确定", nil]

#endif /* AppMacro_h */
