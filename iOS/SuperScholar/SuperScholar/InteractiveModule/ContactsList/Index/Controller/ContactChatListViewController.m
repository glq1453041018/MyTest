//
//  ContactChatListViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ContactChatListViewController.h"
#import "NewFriendViewController.h"
#import "LolitaTableView.h"
#import "ChatListIndexViewController.h"

@interface ContactChatListViewController ()<LolitaTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) LolitaTableView *mainTable;
@property (strong, nonatomic) ChatListIndexViewController *chatListVC;
@end

@implementation ContactChatListViewController
#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configMainTable];
}

- (void)configMainTable{
    [self.view addSubview:self.mainTable];
    [self.mainTable cwn_makeConstraints:^(UIView *maker) {
        maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.mainTable.tableHeaderView = [UIView new];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
- (LolitaTableView *)mainTable{
    if(!_mainTable){
        _mainTable = [[LolitaTableView alloc] init];
        _mainTable.delegate_StayPosition = self;
        _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTable.separatorColor = SeparatorLineColor;
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.type = LolitaTableViewTypeMain;
    }
    return _mainTable;
}

- (ChatListIndexViewController *)chatListVC{
    if(!_chatListVC){
        _chatListVC = [[ChatListIndexViewController alloc] init];
        _chatListVC.tableFrame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight - kTabBarHeight);;
        _chatListVC.view.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight - kTabBarHeight);
//         _subTable.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight - kTabBarHeight);
//        _subTable.backgroundColor = [UIColor lightGrayColor];
//        _subTable.dataSource = self;
//        _subTable.delegate = self;
//        _subTable.type = LolitaTableViewTypeSub;
    }
    return _chatListVC;
}



#pragma mark - <************************** 代理方法 **************************>

#pragma mark LolitaTableViewDelegate
- (CGFloat)lolitaTableViewHeightForStayPosition:(LolitaTableView *)tableView{
    return CGRectGetMaxY([tableView rectForFooterInSection:0]);
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return section == 0 ? 2 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"main"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"main"];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [cell.contentView addSubview:self.chatListVC.view];
        [self addChildViewController:self.chatListVC];
    }
    if(indexPath.section == 0){
        cell.textLabel.text = indexPath.row == 0 ? @"新朋友" :  @"创建群聊";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 50;
    return IEW_HEGHT - kNavigationbarHeight - kTabBarHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0)
        return 10;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView == self.mainTable && section == 0){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IEW_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        
        //top分割线
        UIView *top_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IEW_WIDTH, 0.5)];
        top_line.backgroundColor = SeparatorLineBoldColor;
        [view addSubview:top_line];
        //bottom分割线
        UIView *bottom_line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) - 0.5, IEW_WIDTH, 0.5)];
        bottom_line.backgroundColor = SeparatorLineBoldColor;
        [view addSubview:bottom_line];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0://新朋友
                    [self pushToNewFriend];
                    break;
                case 1://创建群聊
                    
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView==self.mainTable&&self.chatListVC.segmentController.containerView.isDragging==NO) {
        self.chatListVC.segmentController.containerView.scrollEnabled = NO;
    }
    if (self.chatListVC.segmentController.containerView.isDragging) {
        self.mainTable.scrollEnabled=NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.mainTable.scrollEnabled = YES;
    self.chatListVC.segmentController.containerView.scrollEnabled = YES;
}

#pragma mark - <************************** 点击事件 **************************>

- (void)pushToNewFriend{
    NewFriendViewController *vc = [NewFriendViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

@end
