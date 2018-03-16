//
//  MySelfViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MySelfViewController.h"
#import "MYAutoScaleView.h"
#import "LoginInterfaceViewController.h"
#import "UIImage+ImageEffects.h"

@interface MySelfViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tabelHeaderView;//列表header
@property (weak, nonatomic) IBOutlet MYAutoScaleView*topBackView;//头部背景视图
@property (weak, nonatomic) IBOutlet UIView *topView;//头部视图

@property (strong, nonatomic) NSMutableArray *data;//数据
@end

@implementation MySelfViewController
#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.didLoginView.hidden = GetInfoForKey(UserId_NSUserDefaults) == nil;
    self.loginButtton.hidden = !self.didLoginView.hidden;
    self.navigationBar.hidden = self.loginButtton.hidden;
    UIImage *image = [UIImage imageNamed:@"testimage"];
    self.backImageView.image = [image applyBlurWithRadius:5 tintColor:[KColorTheme colorWithAlphaComponent:0.1] saturationDeltaFactor:1.0 maskImage:nil];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    self.data = [NSMutableArray arrayWithObjects:@[@"消息通知", @"我的动态"],  @[@"用户反馈", @"当前版本"], nil];
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
    self.tabelHeaderView.viewHeight = 245;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize_16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText:text];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 10 : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *tip = [NSString stringWithFormat:@"跳转%@", text];
    LLAlert(tip);
}

#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickMSMBtn:(UIButton *)sender {
    LoginInterfaceViewController *loginVc = [LoginInterfaceViewController new];
    [self presentViewController:loginVc animated:YES completion:nil];
}
- (IBAction)onClickTitleButtons:(UIControl *)sender {
    // !!!: 评论、收藏、历史点击事件
    switch (sender.tag) {
        case 0://评论
            LLAlert(@"跳转评论");
            break;
        case 1://收藏
            LLAlert(@"跳转收藏");
            break;
        case 2://历史
            LLAlert(@"跳转历史");
            break;
        default:
            break;
    }
}
- (IBAction)onClickHeaderImage:(UIButton *)sender {
    LLAlert(@"跳转个人资料");
}




#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

@end
