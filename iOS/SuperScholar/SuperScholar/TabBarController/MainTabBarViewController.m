//
//  MainTabBarViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "AdsViewController.h"               // 广告页面
#import "ActivityViewController.h"          // 活动页面

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
        UITabBarItem *barItem = [self makeItemWithTitle:@"推荐" normalImage:@"recommend_unSelected" selectedImage:@"recommend" tag:0];
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    // 活动页面
    {
        ActivityViewController *ctrl = [ActivityViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        UITabBarItem *barItem = [self makeItemWithTitle:@"活动" normalImage:@"recommend_unSelected" selectedImage:@"recommend" tag:1];
        nav.tabBarItem = barItem;
        [self.navs addObject:nav];
    }
    
    self.viewControllers = self.navs;
    self.tabBar.backgroundColor =  KColorTheme;
    
    
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
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:kSelectedColor} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0],NSForegroundColorAttributeName:kNoselectColor} forState:UIControlStateNormal];
    return tabBarItem;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
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
