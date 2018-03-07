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
#import "ClassViewController.h"             // 班级页面
#import "InteractiveViewController.h"       // 互动页面
#import "MySelfViewController.h"            // 个人中心

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
    NSDictionary *item0 = @{
                            @"title":@"推荐",
                            @"selected":@"recommend",
                            @"unSelected":@"recommend_unSelected",
                            @"class":[AdsViewController class]
                            };
    NSDictionary *item1 = @{
                            @"title":@"活动",
                            @"selected":@"activity",
                            @"unSelected":@"activity_unSelected",
                            @"class":[ActivityViewController class]
                            };
    NSDictionary *item2 = @{
                            @"title":@"班级",
                            @"selected":@"class",
                            @"unSelected":@"class_unSelected",
                            @"class":[ClassViewController class]
                            };
    NSDictionary *item3 = @{
                            @"title":@"交流",
                            @"selected":@"interactive",
                            @"unSelected":@"interactive_unSelected",
                            @"class":[InteractiveViewController class]
                            };
    NSDictionary *item4 = @{
                            @"title":@"我",
                            @"selected":@"myself",
                            @"unSelected":@"myself_unSelected",
                            @"class":[MySelfViewController class]
                            };
    
    NSArray *items = @[item0,item1,item2,item3,item4];
    
    
    for (NSDictionary *item in items) {
        NSString *title = [item objectForKey:@"title"];
        NSString *icon_selected = [item objectForKey:@"selected"];
        NSString *icon_unSelected = [item objectForKey:@"unSelected"];
        UIViewController *ctrl = [[item objectForKey:@"class"] new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        UITabBarItem *barItem = [self makeItemWithTitle:title normalImage:icon_unSelected selectedImage:icon_selected tag:0];
        nav.tabBarItem = barItem;
        nav.navigationBar.hidden = YES;
        [self.navs addObject:nav];
    }
    
    self.viewControllers = self.navs;
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
