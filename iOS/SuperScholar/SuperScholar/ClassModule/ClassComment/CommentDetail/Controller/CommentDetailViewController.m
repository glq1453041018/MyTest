//
//  CommentDetailViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "CommentDetailViewController.h"

#import "ClassComDetailTableViewCell.h"         // cell

#import "CommentDetailManager.h"                // 数据管理类

@interface CommentDetailViewController ()
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
// !!!: 数据
@property (strong ,nonatomic) CommentDetailManager *manager;            // 数据管理
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation CommentDetailViewController

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
    [self.manager requestDataResponse:^(BOOL succeed, id error) {
        [self.loadingView stopAnimating];
        [self.table reloadData];
    }];
}

-(void)loadMoreData{
    [self.table.mj_footer endRefreshing];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 导航栏
    [self.navigationBar setTitle:self.title?self.title:@"班级评价" leftImage:kGoBackImageString rightText:nil];
    self.isNeedGoBack = YES;
    
    self.constraint.constant = self.navigationBar.bottom;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = NO;
//    self.table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(CommentDetailManager *)manager{
    if (_manager==nil) {
        _manager = [CommentDetailManager new];
    }
    return _manager;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0&&self.manager.mainModel) {
        return 1;
    }
    else if (self.manager.datas.count){
        return self.manager.datas.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ClassComDetailTableViewCell";
    ClassComDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = NO;
    }
    ClassComItemModel *ccim = nil;
    if (indexPath.section==0) {
        ccim = self.manager.mainModel;
        cell.backgroundColor = [UIColor whiteColor];
    }
    else{
        ccim = self.manager.datas[indexPath.row];
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [self.manager loadCell:cell model:ccim];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return self.manager.mainModel.cellHeight;
    }
    else{
       ClassComItemModel *ccim = self.manager.datas[indexPath.row];
        return ccim.cellHeight;
    }
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


@end
