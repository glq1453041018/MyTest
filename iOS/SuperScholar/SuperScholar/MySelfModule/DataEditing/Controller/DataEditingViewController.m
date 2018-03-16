//
//  DataEditingViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "DataEditingViewController.h"

@interface DataEditingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation DataEditingViewController

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
    self.data = [NSMutableArray arrayWithObjects:@[@"头像", @"用户名", @"介绍"],@[@"性别", @"生日", @"地区"], nil];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configNavigationBar];
    [self configTableView];
}

- (void)configNavigationBar{
    [self.navigationBar setTitle:@"编辑资料" leftImage:@"public_left" rightText:nil];
    self.isNeedGoBack = YES;
}

- (void)configTableView{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IEW_WIDTH, CGFLOAT_MIN)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableFooterView.viewWidth = IEW_WIDTH;
    self.tableView.tableFooterView = self.tableFooterView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}



#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
- (void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize_16];
        cell.textLabel.textColor = HexColor(0x333333);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = text;
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    text = [NSString stringWithFormat:@"跳转%@", text];
    LLAlert(text);
}


#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickExit:(id)sender{
    SaveInfoForKey(nil, UserId_NSUserDefaults);
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
