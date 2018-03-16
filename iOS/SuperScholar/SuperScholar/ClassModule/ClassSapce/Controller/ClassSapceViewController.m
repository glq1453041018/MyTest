//
//  ClassSapceViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

// !!!: 控制器类
#import "ClassSapceViewController.h"
#import "ClassInfoViewController.h"
// !!!: 视图类
#import "ClassSapceTableViewCell.h"
// !!!: 管理类
#import "ClassSapceManager.h"

@interface ClassSapceViewController ()<UITableViewDelegate,UITableViewDataSource>
// !!!: 视图类
@property (strong ,nonatomic) UITableView *table;
// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *data;
@end

@implementation ClassSapceViewController

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
    [self.loadingView startAnimating];
    [ClassSapceManager requestDataStyle:self.style response:^(NSArray *resArray, id error) {
        [self.loadingView stopAnimating];
        self.data = resArray.mutableCopy;
        [self.table reloadData];
    }];
}
-(void)loadMoreData{
    [ClassSapceManager requestDataStyle:self.style response:^(NSArray *resArray, id error) {
        [self.table.mj_footer endRefreshing];
        if (error==nil) {
            [self.data addObjectsFromArray:resArray];
            [self.table reloadData];
        }
    }];
}

#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 导航栏
    [self.navigationBar setTitle:self.title?self.title:@"班级动态" leftImage:kGoBackImageString rightText:@"发布"];
    self.isNeedGoBack = YES;
    
    [self.view addSubview:self.table];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, kScreenWidth, kScreenHeight-self.navigationBar.bottom)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = NO;
        _table.tableFooterView = [UIView new];
        _table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _table;
}



#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigationViewRightClickEvent{
    
}

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"CSCellID";
    ClassSapceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSapceTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = NO;
    }
    [cell loadData:self.data index:indexPath.row pageSize:10];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassSapceModel *csm = self.data[indexPath.row];
    return csm.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>




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
