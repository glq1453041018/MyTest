//
//  NewFriendViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/4.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "NewFriendViewController.h"
#import "ContactSearchViewController.h"
#import <WXOUIModule/YWIMKit.h>
#import <WXOUIModule/YWIndicator.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

#import "ContactChatListTableViewCell.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "UIControl+AddBlock.h"

@interface NewFriendViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YWConversation *conversation;
@end

@implementation NewFriendViewController

#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    //初始化数据
    [self initData];
    
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
    [self configNavigationBar];
    [self configTable];
}

- (void)configNavigationBar{
    [self.navigationBar setTitle:@"新朋友" leftImage:kGoBackImageString rightImage:@"beiJing"];
    self.isNeedGoBack = YES;
}

- (void)configTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, IEW_WIDTH, IEW_HEGHT - self.navigationBar.bottom) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactChatListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ContactChatListTableViewCell"];
    [self.view addSubview:_tableView];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>

- (void)initData{
    _conversation = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] fetchContactSystemConversation];
    
    __weak typeof(self) weakSelf = self;
    [_conversation setOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        [weakSelf.tableView reloadData];
    }];
    [_conversation loadMoreMessages:100 completion:^(BOOL existMore) {
        [weakSelf.tableView reloadData];
    }];
    
    [_conversation setDidChangeContentBlock:^(){
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationViewDelegate
-  (void)navigationViewRightClickEvent{
    ContactSearchViewController *vc = [ContactSearchViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_conversation fetchedObjects].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactChatListTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactChatListTableViewCell"
                                                         forIndexPath:indexPath];
    
    id<IYWMessage> message = [[_conversation fetchedObjects] objectAtIndex:indexPath.row];
    
    YWPerson *person = [message messageFromPerson];
    NSString *personId = person.personId;
    
    cell.identifier = personId;
    
    __block NSString *displayName = nil;
    __block UIImage *avatar = nil;
    //  SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实APP中一般都需要替换为你真实的实现。
    [[SPUtil sharedInstance] syncGetCachedProfileIfExists:person completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
        displayName = aDisplayName;
        avatar = aAvatarImage;
    }];
    
    if (!avatar) {
        avatar = kPlaceholderHeadImage;
    }
    __weak __typeof(self) weakSelf = self;
    
    if (!displayName) {
        displayName = personId;
        
        __weak __typeof(cell) weakCell = cell;
        [[SPUtil sharedInstance] asyncGetProfileWithPerson:person
                                                  progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                      if (aDisplayName && [weakCell.identifier isEqualToString:aPerson.personId]) {
                                                          NSIndexPath *aIndexPath = [weakSelf.tableView indexPathForCell:weakCell];
                                                          if (!aIndexPath) {
                                                              return ;
                                                          }
                                                          [weakSelf.tableView reloadRowsAtIndexPaths:@[aIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                      }
                                                  }];
    }
    
    [cell configureWithAvatar:avatar title:displayName subtitle:nil];
    
    CGRect frame = CGRectMake(0, 15, 60, 34.f);
    YWMessageBodyContactSystem *contactsystem = (YWMessageBodyContactSystem *)[message messageBody];
    if ([contactsystem isKindOfClass:[YWMessageBodyContactSystem class]]) {
        if (contactsystem.requestStatus == YWAddContactRequestStatusAccepted || contactsystem.requestStatus == YWAddContactRequestStatusRefused) {
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = contactsystem.requestStatus == YWAddContactRequestStatusAccepted ? @"已接受"  : @"拒绝" ;
            label.backgroundColor = [UIColor clearColor];
            cell.accessoryView = label;
        } else if (contactsystem.requestStatus == YWAddContactRequestStatusNull) {
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            [button setTitle:@"接受" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:38/255.f green:191/255.f blue:1 alpha:1.f]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 4.f;
            button.clipsToBounds = YES;
            [button addBlock:^(UIControl *sender) {
                [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] responseToAddContact:YES fromPerson:person withMessage:@"" andResultBlock:^(NSError *error, YWPerson *person) {
                    if (error == nil) {
                        [YWIndicator showTopToastTitle:@"操作成功" content:@"通过好友申请" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
                        [weakSelf.tableView reloadData];
                    } else {
                        [YWIndicator showTopToastTitle:@"操作失败" content:@"通过好友申请" userInfo:nil withTimeToDisplay:1.5f andClickBlock:nil];
                    }
                }];

            } forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}




#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
