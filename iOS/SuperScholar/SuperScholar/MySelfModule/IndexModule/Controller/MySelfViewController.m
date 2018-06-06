//
//  MySelfViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MySelfViewController.h"
#import "DataEditingViewController.h"
#import "LoginInterfaceViewController.h"
#import "SuggestionViewController.h"
#import "MessageRemindViewController.h"
#import "MyMessageCenterViewController.h"

#import "MYAutoScaleView.h"

#import "UIImage+ImageEffects.h"

@interface MySelfViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;//数据

@property (weak, nonatomic) IBOutlet UIView *tabelHeaderView;//列表header
@property (weak, nonatomic) IBOutlet MYAutoScaleView*topBackView;//头部背景视图
@property (weak, nonatomic) IBOutlet UIView *topView;//头部视图
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//高斯模糊背景图

//已登录
@property (weak, nonatomic) IBOutlet UIView *didLoginView;//已登录视图
@property (weak, nonatomic) IBOutlet UIView *titleButtonsBackView;//已登录，评论、收藏、历史背景视图
//未登录
@property (weak, nonatomic) IBOutlet UIButton *loginButtton;//未登录，短信登录按钮
@end

@implementation MySelfViewController
#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger userid = [AppInfo share].user.userId;
    BOOL isLogin = userid > 0;
    
    self.loginButtton.hidden = isLogin;//登录按钮显隐
    self.navigationBar.hidden = isLogin;//导航栏显隐
    self.didLoginView.hidden = !isLogin;//已登录视图显隐
    self.titleButtonsBackView.hidden = !isLogin;//评论、收藏、历史背景视图显隐
    self.titleButtonsBackView.heightConstraint.constant = isLogin ? 70 : 0;//评论、收藏、历史背景视图显隐
    self.tabelHeaderView.viewHeight =  IEW_WIDTH * 483 / 1024.0 + (isLogin ?  70 : 0);
    self.tableView.tableHeaderView = self.tabelHeaderView;
    
    if(isLogin){//登录状态
        //背景图
        UIImage *image = [UIImage imageNamed:@"timg"];
        self.backImageView.image = image;
    }else{//未登录状态
        self.backImageView.image = nil;
    }
    
    // 获取数据
    [self getDataFormServer];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    NSInteger userid = [AppInfo share].user.userId;
    BOOL islogin = userid > 0;
    if(islogin)
        self.data = [NSMutableArray arrayWithObjects:@[@"消息通知", @"我的动态"],  @[@"用户反馈", @"当前版本"], nil];
    else
        self.data = [NSMutableArray arrayWithObjects:@[@"用户反馈", @"当前版本"], nil];
    [self.tableView reloadData];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    [self configNavigationBar];
    [self configTableView];
}
- (void)configNavigationBar{
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.isNeedGoBack = YES;
    [self.navigationBar setTitle:@"登录推荐更准确" leftText:nil rightImage:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
}
- (void)configTableView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.topBackView setContentView:self.topView scrollview:self.tableView];
    self.topBackView.viewHeight = IEW_WIDTH * 483 / 1024.0;
    self.tabelHeaderView.frame = CGRectMake(0, 0, IEW_WIDTH, self.topBackView.viewHeight);
    self.tableView.tableHeaderView = self.tabelHeaderView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}



#pragma mark - <************************** 代理方法 **************************>
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.data objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellid"];
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize_16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:FontSize_16];
        cell.textLabel.textColor = HexColor(0x333333);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    if([text isEqualToString:@"当前版本"]){
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = version;
    }else
        cell.detailTextLabel.text = @"";
    [cell.textLabel setText:text];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger userid = [AppInfo share].user.userId;
    BOOL islogin = userid > 0;
    return section == 0 ? (islogin ? 10 : CGFLOAT_MIN) : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(![text isEqualToString:@"当前版本"]){
        if([text isEqualToString:@"用户反馈"]){
            SuggestionViewController *vc = [SuggestionViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if([text isEqualToString:@"消息通知"]){
            MessageRemindViewController *vc = [MessageRemindViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = text;
            vc.listType = MessageRemindListTypeDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([text isEqualToString:@"我的动态"]){
            MessageRemindViewController *vc = [MessageRemindViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = text;
            vc.listType = MessageRemindListTypeDefault;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickMSMBtn:(UIButton *)sender {
    LoginInterfaceViewController *loginVc = [LoginInterfaceViewController new];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:loginVc];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)onClickTitleButtons:(UIControl *)sender {
    // !!!: 评论、收藏、历史点击事件
    MyMessageCenterViewController *vc = [MyMessageCenterViewController new];
    vc.title = @"评论/收藏/历史";
    vc.hidesBottomBarWhenPushed = YES;
    switch (sender.tag) {
        case 0://评论
            vc.defaultType = MessageRemindListTypeComment;
            break;
        case 1://收藏
            vc.defaultType = MessageRemindListTypeCollection;
            break;
        case 2://历史
            vc.defaultType = MessageRemindListTypeHistory;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onClickHeaderImage:(UIButton *)sender {
    // !!!: 头像点击事件
    DataEditingViewController *vc = [DataEditingViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

@end
