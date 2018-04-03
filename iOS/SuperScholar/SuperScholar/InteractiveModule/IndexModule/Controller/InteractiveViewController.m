//
//  InteractiveViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

//controller
#import "InteractiveViewController.h"
#import "MYSegmentController.h"
#import "ContactChatListViewController.h"
#import "MessageListViewController.h"

@interface InteractiveViewController ()
@property (strong, nonatomic) MYSegmentController *segmentController;
@property (strong, nonatomic) ContactChatListViewController *contactListVc;
@property (strong, nonatomic) MessageListViewController *msgListVc;
@property (assign, nonatomic) BOOL childControllerDidLoad;
@end

@implementation InteractiveViewController

#pragma mark - <*********************** 页面生命周期 ************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configTableView];
    
    [self.view bringSubviewToFront:self.navigationBar];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.childControllerDidLoad == NO){
        self.childControllerDidLoad = YES;
        [self.view addSubview:self.segmentController.view];
        [self addChildViewController:self.segmentController];
        [self.view bringSubviewToFront:self.navigationBar];
    }
}

#pragma mark - <*********************** 页面ui搭建和数据初始化 ************************>

- (void)configNavigationBar{
    self.navigationController.navigationBar.hidden=YES;
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"消息", @"联系人"]];
    segment.tintColor = [UIColor whiteColor];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(onClickSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [self.navigationBar setCenterView:segment leftView:nil rightView:nil];
}

- (void)configTableView{
    self.segmentController = [MYSegmentController segementControllerWithFrame:CGRectMake(0, kNavigationbarHeight - kscrollerbarHeight, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight + kscrollerbarHeight - kTabBarHeight) titles:@[@"消息", @"联系人"] withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor clearColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:[UIColor clearColor] withArticleY:38];
    
    [self.segmentController.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }];
    
    [self.segmentController setReturnString:@"0"];
    [self.segmentController setSegementTintColor: [UIColor clearColor]];
    self.segmentController.segementView.backgroundColor = [UIColor clearColor];
    self.segmentController.indicateView.backgroundColor = [UIColor clearColor];
    
    [self.segmentController setSegementViewControllers:@[self.msgListVc, self.contactListVc]];
    self.segmentController.style = GLQSegementStyleFlush;
    self.segmentController.containerView.scrollEnabled = NO;
//    [self.segmentController setSegementTintColor:KColorTheme];
    self.segmentController.downLineLabel.hidden = YES;
    
    [self.segmentController selectedAtIndex:^(NSInteger index) {
    }];
}

#pragma mark - <*********************** 控件get/set方法 ************************>
- (ContactChatListViewController *)contactListVc{
    if(!_contactListVc){
        _contactListVc = [[ContactChatListViewController alloc] init];
    }
    return _contactListVc;
}
- (MessageListViewController *)msgListVc{
    if(!_msgListVc){
        _msgListVc = [[MessageListViewController alloc] init];
    }
    return _msgListVc;
}

#pragma mark - <*********************** 列表数据请求 ************************>

- (void)refreshTableView{
    // !!!: 数据请求和列表刷新事件
    
}

#pragma mark - <*********************** 各种代理事件处理 ************************>

#pragma mark UITableViewDataDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - <*********************** 其他事件处理 ************************>

- (void)onClickSegmentControl:(UISegmentedControl *)segment{
    [self.segmentController setSelectedItemAtIndex:segment.selectedSegmentIndex];
}

- (void)didReceiveMemoryWarning {
    //TODO: 内存警告检测事件
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
