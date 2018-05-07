//
//  ChatListIndexViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/4.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ChatListIndexViewController.h"
#import "SingleChatListViewController.h"
#import "GroupChatListViewController.h"

@interface ChatListIndexViewController ()
@property (strong, nonatomic) SingleChatListViewController *single_vc;
@property (strong, nonatomic) GroupChatListViewController *group_vc;

@property (assign, nonatomic) BOOL childControllerDidLoad;
@end

@implementation ChatListIndexViewController

#pragma mark - <*********************** 页面生命周期 ************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.childControllerDidLoad == NO){
        self.childControllerDidLoad = YES;
        [self.view addSubview:_segmentController.view];
        [self addChildViewController:_segmentController];
    }
}

#pragma mark - <*********************** 页面ui搭建和数据初始化 ************************>

- (void)configNavigationBar{
    self.navigationController.navigationBar.hidden=YES;
    [self setIsNeedGoBack:NO];
}

- (void)configTableView{
    self.segmentController = [MYSegmentController segementControllerWithFrame:self.tableFrame.size.height ? self.tableFrame : self.view.bounds titles:@[@"好友", @"群聊"] withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor groupTableViewBackgroundColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:KColorTheme withArticleY:38];
    
    [_segmentController.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
        [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }];
    
    [_segmentController setReturnString:@"2"];
    [_segmentController setSegementTintColor: KColorTheme];
    _segmentController.indicateView.backgroundColor = KColorTheme;
    
    self.single_vc = [[SingleChatListViewController alloc] init];    
    self.group_vc = [[GroupChatListViewController alloc] init];
    
    [_segmentController setSegementViewControllers:@[self.single_vc, self.group_vc]];
    _segmentController.style = GLQSegementStyleDefault;
    _segmentController.downLineLabel.hidden = YES;
    
    [_segmentController selectedAtIndex:^(NSInteger index) {
        //        if(([weakSelf.vcDidLoad_switches[index] unsignedIntegerValue] & weakSelf.vcDidLoad_states) == 0){//数据未加载
        //            switch (index) {
        //                case 0:
        //                    break;
        //                case 1:
        //                    [vc2 refreshTableView];//请求数据
        //                    break;
        //                case 2:
        //                    [vc3 getDataFormServer];//请求数据
        //                    break;
        //                default:
        //                    break;
        //            }
        //            weakSelf.vcDidLoad_states |= [weakSelf.vcDidLoad_switches[index] unsignedIntegerValue];//将对应状态开关开启
        //        }
    }];
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

- (void)didReceiveMemoryWarning {
    //TODO: 内存警告检测事件
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
