//
//  ContactSearchViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/3.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ContactSearchViewController.h"
#import "SPKitExample.h"
#import "SPUtil.h"
#import "ContactChatListTableViewCell.h"
#import "ContactChatListManager.h"
#import "MYSearchView.h"
#import "UIControl+AddBlock.h"

@interface ContactSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MYSearchView *searchView;
@property (weak, nonatomic) IBOutlet LLNavigationView *navigationView;

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSMutableDictionary *cachedDisplayNames;
@property (strong, nonatomic) NSMutableDictionary *cachedAvatars;
@end

@implementation ContactSearchViewController

#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.searchView.searchField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchView.searchField resignFirstResponder];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.navigationView setTitle:@"" leftText:@"" rightText:@"取消"];
    self.isNeedGoBack = YES;
    
    WeakObj(self);
    [self.navigationView.rightBtn addBlock:^(UIControl *sender) {
        [weakself.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.navigationItem.title = @"搜索联系人";
    
    
    self.searchView.searchField.delegate = self;
    self.searchView.searchField.enablesReturnKeyAutomatically = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ContactChatListTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"ContactChatListTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
    self.cachedAvatars = [NSMutableDictionary dictionary];
    self.cachedDisplayNames = [NSMutableDictionary dictionary];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>




#pragma mark - <************************** 代理方法 **************************>

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchView.searchField) {
        [self onSearch:nil];
        [textField endEditing:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.results = nil;
    [self.tableView reloadData];
    
    return YES;
}

#pragma mark - UIScrollviewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    
    NSString *name = nil;
    UIImage *avatar = nil;
    
    // 使用服务端的资料
    name = self.cachedDisplayNames[person.personId];
    if (!name) {
        name = person.personId;
    }
    avatar = self.cachedAvatars[person.personId];
    if (!avatar) {
        avatar = [UIImage imageNamed:@"demo_head_120"];
    }
    
    ContactChatListTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"ContactChatListTableViewCell"
                                                         forIndexPath:indexPath];
    if([avatar isMemberOfClass:[UIImage class]])
        [cell configureWithAvatar:avatar title:name subtitle:nil];
    else
        [cell configureWithAvatarUrl:(NSString *)avatar title:name subtitle:nil];
    
    
    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    BOOL isFriend = [[[self ywIMCore] getContactService] ifPersonIsFriend:person];
    
    if (isMe || isFriend) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        cell.accessoryView = label;
        if (isMe) {
            label.text = @"自己";
        }
        else {
            label.text = @"好友";
        }
        [label sizeToFit];
    }
    else {
        cell.accessoryView = nil;
        CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect accessoryViewFrame = CGRectMake(windowWidth - 100, (cell.frame.size.height - 30)/2, 80, 30);
        UIButton *button = [[UIButton alloc] initWithFrame:accessoryViewFrame];
        [button setTitle:@"添加好友" forState:UIControlStateNormal];
        UIColor *color = [UIColor colorWithRed:0 green:180./255 blue:1.0 alpha:1.0];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        button.layer.borderColor = color.CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 4.0f;
        button.backgroundColor = [UIColor clearColor];
        button.clipsToBounds = YES;
        [button addTarget:self
                   action:@selector(addContactButtonTapped:event:)
         forControlEvents:UIControlEventTouchUpInside];
        //        cell.accessoryView = button;
        [cell.contentView addSubview:button];;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    YWPerson *person = self.results[indexPath.row];
    
    WeakObj(self);
    YWConversationViewController * vc =[[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
    [vc.navigationBar setTitle:[self.cachedDisplayNames objectForKey:person.personId] leftImage:kGoBackImageString rightText:nil];
    [vc.navigationBar.letfBtn addBlock:^(UIControl *sender) {
        [weakself.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    BOOL isMe = [person.personId isEqualToString:[[[self ywIMCore] getLoginService] currentLoginedUserId]];
    return !isMe;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    YWPerson *person = self.results[indexPath.row];
    [[ContactChatListManager defaultManager] addContact:person];
    
    [self.tableView reloadData];
}



#pragma mark - <************************** 点击事件 **************************>

- (void)addContactButtonTapped:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}


#pragma mark - <************************** 其他方法 **************************>
- (IBAction)onSearch:(id)sender {
    if( [self.searchView.searchField.text length] == 0 ){
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
  id<IYWDBModel> result =   [[[self ywIMCore] getContactService] DBModelWithSearchKeyword:self.searchView.searchField.text needIsFriend:NO];
    NSArray *arr = result.ywFetchResult;
    
    [[[self ywIMCore] getContactService] getProfileForPersons:arr withTribe:nil expireInterval:0 withProgress:nil andCompletionBlock:^(BOOL aIsSuccess, NSArray *profileItems) {
        if (aIsSuccess && [arr count] > 0 && [profileItems count] == [arr count]) {
            [profileItems enumerateObjectsUsingBlock:^(YWProfileItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.displayName) {
                        weakSelf.cachedDisplayNames[[arr[idx]personId]] = obj.displayName;
                    }
                    if (obj.avatar) {
                        weakSelf.cachedAvatars[[arr[idx] personId]] = obj.avatar;
                    }else
                    if(obj.avatarUrl){
                        weakSelf.cachedAvatars[[arr[idx] personId]] = obj.avatarUrl;
                    }
            }];
            
            weakSelf.results = [arr mutableCopy];
            [weakSelf.tableView reloadData];
        }else if([weakSelf.results count] == 0){
            weakSelf.results = [NSMutableArray array];
            [weakSelf.tableView reloadData];
            [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.navigationController
                                                                title:@"未找到该用户，请确认帐号后重试"
                                                             subtitle:nil
                                                                 type:SPMessageNotificationTypeError];
            
        }
    }];
}

#pragma mark - Utility
- (YWIMCore *)ywIMCore {
    return [SPKitExample sharedInstance].ywIMKit.IMCore;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchView.searchField resignFirstResponder];
}



@end
