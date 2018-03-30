//
//  ActivityDetailWebViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityDetailWebViewController.h"
#import "CommentDetailViewController.h"         // 评论详情
// !!!: 视图类
#import "ClassSpaceTableViewCell.h"             // 消息主题cell
#import "ClassComDetailTableViewCell.h"         // 回复cell
#import "CommentView.h"                         // 评论视图
#import "ArrowMenuView.h"
#import "LLAlertView.h"
#import <SVProgressHUD.h>
// !!!: 数据
#import "ClassComDetailManager.h"
#import "ShareManager.h"

@interface ActivityDetailWebViewController ()<UITableViewDelegate,UITableViewDataSource,CommentViewDelegate, MyWebViewDelegate>
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong ,nonatomic) CommentView *commentView;                 // 评论视图
@property (strong, nonatomic) ArrowMenuView *menu;
@property (strong, nonatomic) LLAlertView *alert;
// !!!: 数据类
//@property (copy ,nonatomic) NSArray *data;
@property (strong ,nonatomic) ClassComDetailManager *manager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@end

@implementation ActivityDetailWebViewController

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
    [self.navigationBar setTitle:self.title?self.title:@"班级评价" leftImage:kGoBackImageString rightText:@"设置"];
    
    self.isNeedGoBack = YES;
    
    self.constraint.constant = self.navigationBar.bottom;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = NO;
    self.table.showsVerticalScrollIndicator = NO;
    //    self.table.mj_footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:self.commentView];
    
    self.webView.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight);
    self.webView.needLoading = NO;
    self.webView.delegate = self;
    [self.webView loadUrlString:@"https://www.jianshu.com/p/99627f3e58dd"];
    self.table.tableHeaderView = self.webView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(CommentView *)commentView{
    if (_commentView==nil) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommentView class]) owner:nil options:nil].firstObject;
        _commentView.delegate = self;
        _commentView.y = kScreenHeight - _commentView.viewHeight;
    }
    return _commentView;
}
-(ClassComDetailManager *)manager{
    if (_manager==nil) {
        _manager = [ClassComDetailManager new];
    }
    return _manager;
}



#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    if(_alert.isShow)
        [self navigationViewRightClickEvent];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)navigationViewRightClickEvent{
    WeakObj(self);
    if(!_menu){
        _alert = [[LLAlertView alloc] initWithFrame:CGRectMake(0, kNavigationbarHeight, IEW_WIDTH, IEW_HEGHT - kNavigationbarHeight)];
        [_alert setTouchBgView:^{//背景点击事件
            [weakself navigationViewRightClickEvent];//调自己收起来
        }];
        [self.view addSubview:_alert];
        
        _menu = [[ArrowMenuView alloc] initWithFrame:CGRectZero withSelectionBlock:^(NSInteger index) {
            switch (index) {
                case 0://分享
                    [weakself onClickShare];
                    break;
                case 1://收藏
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    break;
                case 2://点赞
                    [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
                    break;
                default:
                    break;
            }
            [weakself navigationViewRightClickEvent];//调自己收起来
        }];
        _alert.contentView = _menu;
        _menu.frame = CGRectMake(IEW_WIDTH - 8 - IEW_WIDTH * 4 / 9, -6, IEW_WIDTH * 4 / 9, 176);
        _menu.titles = [@[@"分享", @"收藏", @"点赞"] mutableCopy];
        [_menu reloadData];
        
        [_alert show];
    }else{
        [_alert hideWithBlock:^{
            [weakself.alert removeFromSuperview];
            weakself.alert = nil;
            weakself.menu.hidden = YES;
            weakself.menu = nil;
        }];
    }
}
// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.manager.dataModel.responses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellId = @"ClassComDetailTableViewCell";
        ClassComDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:self options:nil] firstObject];
            cell.selectionStyle = NO;
        }
        cell.rowView.hidden = indexPath.row==self.manager.dataModel.responses.count-1;
        [self.manager loadResponseCell:cell index:indexPath.row];
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.manager.dataModel.responses.count) {
        return AdaptedWidthValue(30);
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassComItemModel *ccim = self.manager.dataModel.responses[indexPath.row];
    return ccim.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, AdaptedWidthValue(30))];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-10*2, AdaptedWidthValue(30))];
    label.textColor = kDarkCyanColor;
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



// !!!: 评论代理
-(void)commentView:(CommentView *)commentView sendMessage:(NSString *)message complete:(void (^)(BOOL))completeBlock{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completeBlock(YES);
    });
}


// !!!: MyWebView代理
- (void)didStartWebView:(MyWebView *)webView{
    [self.loadingView startAnimating];
}
- (void)didFinishWebView:(MyWebView *)webView{
    if(webView.webView.scrollView.contentSize.height > 0){
        self.webView.viewHeight = webView.webView.scrollView.contentSize.height;
        self.table.tableHeaderView = self.webView;
    }else{
        DLog(@"%lf", webView.webView.scrollView.contentSize.height);
    }
    [self.loadingView stopAnimating];
}
- (void)didFailWebView:(MyWebView *)webView{
    [self.loadingView stopAnimating];
}


#pragma mark - <************************** 点击事件 **************************>
- (void)onClickShare{
    NSString *url = [self.webView.webView.URL absoluteString];
    [ShareManager showShareViewWithTitle:@"没有人生来勇敢，天赋过人" body:@"其实这个世界上，没有那么多与生俱来就很优秀的人" image:kPlaceholderImage link:url withCompletion:^(OSMessage *message, NSError *error) {
        if(!error)
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        else
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
    }];
}



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
