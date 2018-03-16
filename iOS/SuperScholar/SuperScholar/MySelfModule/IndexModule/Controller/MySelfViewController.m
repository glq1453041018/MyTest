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

@interface MySelfViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
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
    self.backImageView.image = [UIImage imageNamed:@"timg.jpg"];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MYAutoScaleView *scale = [[MYAutoScaleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 175)];
    [scale setContentView:self.topView scrollview:self.tableView];
    self.tableView.tableHeaderView = scale;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>




#pragma mark - <************************** 代理方法 **************************>
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"这是第%ld行", indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickMSMBtn:(UIButton *)sender {
    LoginInterfaceViewController *loginVc = [LoginInterfaceViewController new];
    [self presentViewController:loginVc animated:YES completion:nil];
}




#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}

@end
