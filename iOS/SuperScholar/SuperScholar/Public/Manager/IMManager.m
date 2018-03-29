//
//  IMManager.m
//  SuperScholar
//
//  Created by cwn on 2018/3/28.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "IMManager.h"

@implementation IMManager
+ (void)callThisInDidFinishLaunching{
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
}

+ (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)loginId{
    //应用登陆成功后，调用SDK
    [[SPKitExample sharedInstance] callThisAfterISVAccountLoginSuccessWithYWLoginId:@"visitor1"
                                                                           passWord:@"taobao1234"
                                                                    preloginedBlock:^{
                                                                        /// 可以显示会话列表页面
                                                                    } successBlock:^{
                                                                        //  到这里已经完成SDK接入并登录成功，你可以通过exampleMakeConversationListControllerWithSelectItemBlock获得会话列表
                                                                        /// 可以显示会话列表页面
                                                                        UIViewController *ctrl =  [IMManager exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
                                                                            [IMManager exampleOpenConversationViewControllerWithConversation:aConversation fromNavigationController:[(UITabBarController *)[[[UIApplication sharedApplication].delegate window] rootViewController] selectedViewController]];
                                                                        }];
                                                                        UINavigationController *nav = [[(UITabBarController *)[[[UIApplication sharedApplication].delegate window] rootViewController] childViewControllers] objectAtIndex:3];
                                                                        UIViewController *vc = [nav.childViewControllers firstObject];
                                                                        [vc.navigationBar setTitle:@"交流" leftImage:nil rightText:nil];
                                                                        [vc addChildViewController:ctrl];
                                                                        [vc.view addSubview:ctrl.view];
                                                                        [ctrl.view cwn_makeConstraints:^(UIView *maker) {
                                                                            maker.edgeInsetsToSuper(UIEdgeInsetsMake(kNavigationbarHeight, 0, kTabBarHeight, 0));
                                                                        }];
                                                                    } failedBlock:^(NSError *aError) {        
                                                                        if (aError.code == YWLoginErrorCodePasswordError || aError.code == YWLoginErrorCodePasswordInvalid || aError.code == YWLoginErrorCodeUserNotExsit) {
                                                                            /// 可以显示错误提示
                                                                        }
                                                                    }];
}

+(void)callThisBeforeISVAccountLogout{
    [[SPKitExample sharedInstance] callThisBeforeISVAccountLogout];
}

+ (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock{
    YWConversationListViewController *result = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
    [result setDidSelectItemBlock:aSelectItemBlock];
    return result;
}

+ (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController{
    __block YWConversationViewController *alreadyController = nil;
    [aNavigationController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[YWConversationViewController class]]) {
            YWConversationViewController *c = obj;
            if (aConversation.conversationId && [c.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                alreadyController = c;
                *stop = YES;
            }
        }
    }];
    
    if (alreadyController) {
        /// 必须判断当前是否已有该会话，如果有，则直接显示已有会话
        /// @note 目前IMSDK不允许同时存在两个相同会话的Controller
        [aNavigationController popToViewController:alreadyController animated:YES];
        [aNavigationController setNavigationBarHidden:NO];
        return;
    } else {
        YWConversationViewController *conversationController = [[SPKitExample sharedInstance].ywIMKit makeConversationViewControllerWithConversationId:aConversation.conversationId];
        
        __weak typeof(conversationController) weakController = conversationController;
        [conversationController setViewWillAppearBlock:^(BOOL aAnimated) {
            [weakController.navigationController setNavigationBarHidden:NO animated:aAnimated];
        }];
        
        [conversationController.navigationBar setTitle:@"" leftImage:kGoBackImageString rightText:nil];
        
        [aNavigationController pushViewController:conversationController animated:YES];
        
        /// 添加自定义插件
        [[SPKitExample sharedInstance] exampleAddInputViewPluginToConversationController:conversationController];
        
        /// 添加自定义表情
        [[SPKitExample sharedInstance] exampleShowCustomEmotionWithConversationController:conversationController];
        
        /// 设置显示自定义消息
        [[SPKitExample sharedInstance] exampleShowCustomMessageWithConversationController:conversationController];
    }
}

+(void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController{
    YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

+ (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController{
    YWConversation *conversation = [YWTribeConversation fetchConversationByTribe:aTribe createIfNotExist:YES baseContext:[SPKitExample sharedInstance].ywIMKit.IMCore];
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}
@end
