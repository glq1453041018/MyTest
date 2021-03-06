//
//  ClassCommentViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentViewController.h"
#import "ClassComDetailViewController.h"        // 评论详情
#import "SpeechViewController.h"                // 发表
#import "PersonalInfoViewController.h"
// !!!: 视图类
#import "ClassSpaceTableViewCell.h"             // cell
#import "ClassCommentSectionView.h"
#import "LLListPickView.h"                      // 弹窗列表视图
// !!!: 管理类
#import "ClassCommentManager.h"

@interface ClassCommentViewController ()<UITableViewDelegate,UITableViewDataSource,ClassCommentSectionViewDelegate,LLListPickViewDelegate,ClassSpaceTableViewCellDelegate>
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong ,nonatomic) ClassCommentSectionView *sectionView;
@property (strong ,nonatomic) LLListPickView *pickView;
// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *data;
@property (strong ,nonatomic) ClassCommentManager *manager;
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
    [self.navigationBar setTitle:self.title?self.title:@"班级评价" leftImage:kGoBackImageString rightImage:@"camera"];
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
        _sectionView = [ClassCommentSectionView new];
    }
    return _sectionView;
}

-(LLListPickView *)pickView{
    if (_pickView==nil) {
        _pickView = [LLListPickView new];
        _pickView.delegate = self;
    }
    return _pickView;
}

-(ClassCommentManager *)manager{
    if (_manager==nil) {
        _manager = [ClassCommentManager new];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassSpaceModel *csm = self.data[indexPath.row];
    return csm.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ClassComDetailViewController *ctrl = [ClassComDetailViewController new];
    ctrl.messageType = MessageTypeComment;
    [self.navigationController pushViewController:ctrl animated:YES];
}


// !!!: LLListPickView代理事件
-(void)lllistPickViewItemSelected:(NSInteger)index{
    SpeechViewController *ctrl = [SpeechViewController new];
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




#pragma mark - <************************** 其他方法 **************************>
// !!!: 类型视图的爱里
-(void)classCommentSectionViewSelectedIndex:(NSInteger)index content:(NSString*)content{
    
}


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
