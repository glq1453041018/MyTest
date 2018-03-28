//
//  ActivityVideoDetailViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/3/24.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityVideoDetailViewController.h"
#import "ClassSpaceViewController.h"
#import "CommentView.h"                         // 评论视图
#import "MyWebView.h"

@interface ActivityVideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CommentViewDelegate, MyWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong ,nonatomic) CommentView *commentView;                 // 评论视图
@property (weak, nonatomic) IBOutlet MyWebView *webView;
@end

@implementation ActivityVideoDetailViewController

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
    for (int i = 0; i < 20; i ++) {
        [self.data addObject:@"fdasfa"];
        [self.data addObject:@"fagawg"];
    }
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 导航栏
    [self.navigationBar setTitle:@"" leftImage:kGoBackImageString rightText:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:self.commentView];
    
    self.webView.delegate = self;
    self.webView.webView.configuration.allowsInlineMediaPlayback = YES;
    WKWebViewConfiguration *vc = self.webView.webView.configuration;
    vc.allowsInlineMediaPlayback = YES;
//    [self.webView.webView.configuration setValue:@NO forKey:@"fullScreenEnabled"];
     [self.webView loadUrlString:@"http://123.207.65.130/a.html"];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

-(CommentView *)commentView{
    if (_commentView==nil) {
        _commentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CommentView class]) owner:nil options:nil].firstObject;
        _commentView.delegate = self;
        _commentView.y = kScreenHeight - _commentView.viewHeight;
    }
    return _commentView;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

// !!!: 列表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [self.data objectAtIndex:indexPath.row];
    NSString *cellid = @"video_detail_id";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *title = [UILabel new];
    title.backgroundColor = [UIColor whiteColor];
    title.frame = CGRectMake(0, 0, IEW_WIDTH, 30);
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = FontSize_colorgray;
    title.text = @"    精彩评论";
    return title;
}

// !!!: 评论代理
-(void)commentView:(CommentView *)commentView sendMessage:(NSString *)message complete:(void (^)(BOOL))completeBlock{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completeBlock(YES);
    });
}

// !!!: MyWebViewDelegate
- (void)didFinishWebView:(MyWebView *)webView{
//    [webView.webView.scrollView setContentOffset:CGPointMake(0, 48)];
//    if(webView.webView.scrollView.contentSize.height > 200){
//        webView.webView.scrollView.scrollEnabled = NO;
//        webView.webView.hidden = NO;
//    }else{
//        webView.webView.hidden = YES;
//    }
}

#pragma mark - <************************** 点击事件 **************************>
// !!!: 点击进入班级
- (IBAction)onClickComeInClass:(UIButton *)sender {
    ClassSapceViewController *vc = [ClassSapceViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <************************** 私有方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

@end
