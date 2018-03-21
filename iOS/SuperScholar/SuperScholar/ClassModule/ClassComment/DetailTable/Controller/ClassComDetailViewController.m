//
//  ClassComDetailViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassComDetailViewController.h"
#import "CommentDetailViewController.h"         // 评论详情
// !!!: 视图类
#import "ClassSpaceTableViewCell.h"             // 消息主题cell
#import "ClassComDetailTableViewCell.h"         // 回复cell
// !!!: 数据
#import "ClassComDetailManager.h"

@interface ClassComDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;

// !!!: 数据类
//@property (copy ,nonatomic) NSArray *data;
@property (strong ,nonatomic) ClassComDetailManager *manager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation ClassComDetailViewController

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
    self.table.showsVerticalScrollIndicator = NO;
//    self.table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(ClassComDetailManager *)manager{
    if (_manager==nil) {
        _manager = [ClassComDetailManager new];
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
    if (section==0) {
        if (self.manager.dataModel.mainModel) {
            return 1;
        }
    }
    return self.manager.dataModel.responses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        static NSString *cellId = @"ClassSpaceTableViewCell";
        ClassSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = NO;
        }
        cell.starView.hidden = !self.messageType;       // 星星默认是隐藏的
        [self.manager loadCell:cell];
        return cell;
    }
    else{
        static NSString *cellId = @"ClassComDetailTableViewCell";
        ClassComDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = NO;
        }
        [self.manager loadResponseCell:cell index:indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01;
    }
    if (self.manager.dataModel.responses.count) {
        return AdaptedWidthValue(30);
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return self.manager.dataModel.mainModel.cellHeight;
    }
    ClassComItemModel *ccim = self.manager.dataModel.responses[indexPath.row];
    return ccim.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 5;
    }
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0||self.manager.dataModel.responses==0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptedWidthValue(30))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10*2, AdaptedWidthValue(30))];
    label.textColor = KColorTheme;
    label.font = [UIFont systemFontOfSize:FontSize_12];
    label.text = @"最新评论";
    [view addSubview:label];
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom-1, kScreenWidth, 1)];
    rowView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:rowView];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CommentDetailViewController *ctrl = [CommentDetailViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
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
