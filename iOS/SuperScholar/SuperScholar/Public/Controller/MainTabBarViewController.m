//
//  MainTabBarViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "AdsViewController.h"               // 广告页面

@interface MainTabBarViewController ()
@property(copy,nonatomic)NSMutableArray *navs;
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化视图
    [self initUI];
}

#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // 广告页面
    {
        AdsViewController *ctrl = [AdsViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        UITabBarItem *barItem = [self makeItemWithTitle:@"推荐" normalImage:@"toolUnSelect" selectedImage:@"toolSelect" tag:0];
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    self.viewControllers = self.navs;
    self.tabBar.backgroundColor = [UIColor whiteColor];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(NSMutableArray *)navs{
    if (_navs==nil) {
        _navs = [NSMutableArray array];
    }
    return _navs;
}



#pragma mark - <************************** 代理方法 **************************>




#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>
-(UITabBarItem*)makeItemWithTitle:(NSString*)title normalImage:(NSString *)normal selectedImage:(NSString *)selected tag:(NSInteger)tag{
    UITabBarItem *tabBarItem = nil;
    UIImage *normalImage = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [[UIImage imageNamed:selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if ([UIDevice currentDevice].systemVersion.floatValue >=7.0) {
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    }
    else{
        tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage tag:tag];
    }
    tabBarItem.tag = tag;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor purpleColor]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:[UIColor purpleColor]} forState:UIControlStateNormal];
    return tabBarItem;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
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
