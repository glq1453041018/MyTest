//
//  ClassViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewController.h"
#import "MySelfViewController.h"
#import "LLNavigationView.h"

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTitle:@"急死哦飞机司法及司法 i 计算机房手机哦的" leftImage:@"public_left" rightText:@"确定"];
    
    [self.loadingView startAnimating];
}


-(void)navigationViewLeftClickEvent{
    
}

-(void)navigationViewRightClickEvent{
    [self.navigationController pushViewController:[MySelfViewController new] animated:YES];
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
