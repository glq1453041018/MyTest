//
//  IMManager.h
//  SuperScholar
//
//  Created by cwn on 2018/3/28.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPKitExample.h"

@interface IMManager : NSObject

/**
 didlaunch里调用
 
 @note 目的：1.初始化    2.设置apnsPush处理回调    3设置全局导航栏颜色
 */
+ (void)callThisInDidFinishLaunching;

/**
 登陆成功调用

 @param loginId 登陆的userid
 @note 目的：登录IMSDK，包含1.监听连接状态    2.设置头像风格    3.提供profile信息   4.设置最大气泡宽度      5.监听新消息   
                        6.监听头像点击事件      7.监听链接点击事件      8.监听预览大图事件      9.自定义皮肤     10.预登陆      11.真正登陆
 */
+ (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)loginId;

/**
 退出登录时调用
 */
+ (void)callThisBeforeISVAccountLogout;

/**
 打开会话列表
 
 @note 如何调用API创建会话列表页面，你需要在你的代码中调用此段代码，取得返回的Controller对象，然后使用Push、Present或者添加到UITabBarController等方式，将其展示出来
 */
+ (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock;

/**
 打开某个会话

 @param aConversation 会话
 @param aNavigationController 当前导航栏
 @note 1.判断该会话页面是否存在    2.创建会话列表    3.添加自定义插件   4.添加自定义表情       5.设置显示自定义消息
 */
+ (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController;

/**
 打开单聊页面
 */
+ (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController;

/**
 *  打开群聊页面
 */
+ (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController;
@end
