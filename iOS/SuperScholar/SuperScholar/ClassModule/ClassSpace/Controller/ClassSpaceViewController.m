//
//  ClassSapceViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/14.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

// !!!: 控制器类
#import "ClassSpaceViewController.h"
#import "SpeechViewController.h"                // 发表
#import "ClassInfoViewController.h"             // 班级信息
#import "ClassComDetailViewController.h"        // 班级评论列表
#import "PersonalInfoViewController.h"          // 个人信息中心
// !!!: 视图类
#import "ClassSpaceTableViewCell.h"
#import "ClassSpaceVideoTableViewCell.h"
#import "ClassSpaceHeadView.h"
#import "LLListPickView.h"                      // 弹窗列表视图
// !!!: 管理类
#import "ClassSpaceManager.h"

@interface ClassSpaceViewController ()<UITableViewDelegate,UITableViewDataSource,LLListPickViewDelegate,ClassSpaceTableViewCellDelegate>
// !!!: 视图类
@property (strong ,nonatomic) UITableView *table;
@property (strong ,nonatomic) ClassSpaceHeadView *headView;
@property (strong ,nonatomic) LLListPickView *pickView;
// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *data;
@property (strong ,nonatomic) ClassSpaceManager *manager;
@end

@implementation ClassSpaceViewController

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
    [ClassSpaceManager requestDataResponse:^(NSArray *resArray, id error) {
        [self.loadingView stopAnimating];
        self.data = resArray.mutableCopy;
        [self.table reloadData];
    }];
    
    NSString *iconUrlString = [TESTDATA randomUrlString];
    NSString *detailString = [TESTDATA randomContent];
    [self.headView.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrlString] placeholderImage:kPlaceholderImage];
    [self.headView.detailLabel setText:detailString];
    
}
-(void)loadMoreData{
    [ClassSpaceManager requestDataResponse:^(NSArray *resArray, id error) {
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
    self.hidesBottomBarWhenPushed = YES;
    // 导航栏
    [self.navigationBar setTitle:self.title?self.title:@"班级动态" leftImage:kGoBackImageString rightImage:@"camera"];
    [self.navigationBar.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    self.isNeedGoBack = YES;
    
    self.table.tableHeaderView = self.headView;
    [self.view addSubview:self.table];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, kScreenWidth, kScreenHeight-self.navigationBar.bottom) style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = NO;
        _table.tableFooterView = [UIView new];
        _table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _table;
}

-(ClassSpaceHeadView *)headView{
    if (_headView==nil) {
        _headView = [[NSBundle mainBundle] loadNibNamed:@"ClassSpaceHeadView" owner:nil options:nil].lastObject;
        [_headView.clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

-(LLListPickView *)pickView{
    if (_pickView==nil) {
        _pickView = [LLListPickView new];
        _pickView.delegate = self;
    }
    return _pickView;
}

-(NSMutableArray *)data{
    if (_data==nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(ClassSpaceManager *)manager{
    if (_manager==nil) {
        _manager = [ClassSpaceManager new];
    }
    return _manager;
}

#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigationViewRightClickEvent{
    [self.pickView showItems:@[@"拍照",@"录像",@"去相册选择"]];
}

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassSpaceModel *csm = self.data[indexPath.row];
    if (csm.type==MediaTypePic) {
        static NSString *cellId = @"ClassSpaceTableViewCell";
        ClassSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = NO;
        }
        cell.delegate = self;
        [self.manager loadData:self.data cell:cell index:indexPath.row pageSize:10];
        return cell;
    }
    else{
        static NSString *cellId = @"ClassSpaceVideoTableViewCell";
        ClassSpaceVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassSpaceVideoTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = NO;
        }
        cell.delegate = self;
        [self.manager loadData:self.data cell:cell table:tableView indexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassSpaceModel *csm = self.data[indexPath.row];
    return csm.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ClassComDetailViewController *ctrl = [ClassComDetailViewController new];
    ctrl.messageType = MessageTypeDefault;
    [self.navigationController pushViewController:ctrl animated:YES];
}


// !!!: LLListPickView代理事件
-(void)lllistPickViewItemSelected:(NSInteger)index{
    SpeechViewController *ctrl = [SpeechViewController new];
    ctrl.classId = self.classId;
    [self presentViewController:ctrl animated:NO completion:nil];
    [ctrl lllistPickViewItemSelected:index];
}

// !!!: cell的代理事件
-(void)classSpaceTableViewCellClickEvent:(ClassCellClickEvent)event{
//    NSString *tip = @[@"头像",@"赞",@"评论"][event];
    switch (event) {
        case ClassCellHeadClickEvent:
        {
            [self goToPersionalModule];     // 跳转个人信息页面
        }
            break;
        case ClassCellLikeClickEvent:
        {
            
        }
            break;
        case ClassCellCommentClickEvent:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - <************************** 点击事件 **************************>
// !!!: 头部点击事件
-(void)clickBtnAction:(UIButton*)btn{
    ClassInfoViewController *ctrl = [ClassInfoViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
}




#pragma mark - <************************** 其他方法 **************************>
// !!!: 头像点击
-(void)goToPersionalModule{
    PersonalInfoViewController *ctrl = [PersonalInfoViewController new];
    [self.navigationController pushViewController:ctrl animated:YES];
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
