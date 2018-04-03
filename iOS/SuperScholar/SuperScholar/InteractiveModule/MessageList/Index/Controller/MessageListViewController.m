//
//  MessageListViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MessageListViewController.h"
#import "IMManager.h"

@interface MessageListViewController ()

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *ctrl =  [IMManager exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
    [IMManager exampleOpenConversationViewControllerWithConversation:aConversation fromNavigationController:[(UITabBarController *)[[[UIApplication sharedApplication].delegate window] rootViewController] selectedViewController]];
        
    }];
    
    [self addChildViewController:ctrl];
    [self.view addSubview:ctrl.view];
    [ctrl.view cwn_makeConstraints:^(UIView *maker) {
        maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
