//
//  ClassCommentViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentViewController.h"
#import "ClassComDetailViewController.h"        // 评论详情
// !!!: 视图类
#import "ClassCommentTableViewCell.h"
#import "ClassCommentSectionView.h"
// !!!: 管理类
#import "ClassCommentManager.h"

@interface ClassCommentViewController ()<UITableViewDelegate,UITableViewDataSource,ClassCommentSectionViewDelegate>
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong ,nonatomic) ClassCommentSectionView *sectionView;
// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation ClassCommentViewController

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
    [ClassCommentManager requestDataResponse:^(NSArray *resArray, id error) {
        [self.loadingView stopAnimating];
        self.data = resArray.mutableCopy;
        [self.table reloadData];
    }];
}
-(void)loadMoreData{
    [ClassCommentManager requestDataResponse:^(NSArray *resArray, id error) {
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 导航栏
    [self.navigationBar setTitle:self.title?self.title:@"班级评价" leftImage:kGoBackImageString rightText:nil];
    self.isNeedGoBack = YES;
    
    self.constraint.constant = self.navigationBar.bottom;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = NO;
    self.table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.sectionView loadData:@[@"最新",@"有图",@"好评",@"中评",@"差评"] withDelegate:self];
    self.table.tableHeaderView = self.sectionView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>

-(ClassCommentSectionView *)sectionView{
    if (_sectionView==nil) {
        _sectionView = [[[NSBundle mainBundle] loadNibNamed:@"ClassCommentSectionView" owner:nil options:nil] lastObject];
    }
    return _sectionView;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ClassCommentTableViewCell";
    ClassCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassCommentTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = NO;
    }
    [cell loadData:self.data index:indexPath.row pageSize:10];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassCommentModel *ccm = self.data[indexPath.row];
    return ccm.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ClassComDetailViewController *ctrl = [ClassComDetailViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}



#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>
// !!!: 类型视图的爱里
-(void)classCommentSectionViewSelectedIndex:(NSInteger)index content:(NSString*)content{
    
}



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
