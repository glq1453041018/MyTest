//
//  ActivityVideoDetailViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/3/24.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityVideoDetailViewController.h"
#import "ClassSpaceViewController.h"
#import "CommentDetailViewController.h"
#import "ClassComDetailTableViewCell.h"
#import "CommentView.h"                         // 评论视图
#import "MyWebView.h"
#import "ClassComDetailModel.h"

@interface ActivityVideoDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CommentViewDelegate, MyWebViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy ,nonatomic) NSArray <ClassComItemModel*> *responses;    // 评论列表
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
    // 回复数组
    // 创建回复cell
    ClassComDetailTableViewCell *cellDetail = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:nil options:nil] firstObject];
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        ClassComItemModel *itemModel = [ClassComItemModel new];
        itemModel.userName = [NSString stringWithFormat:@"啦啦%d号",i];
        itemModel.icon = [TESTDATA randomUrlString];
        itemModel.comment = [TESTDATA randomContent];
        itemModel.commentAttr = [self changeToAttr:itemModel.comment];
        itemModel.date = @"2018-3-19";
        cellDetail.commentLabel.text = itemModel.comment;
        CGSize size = [cellDetail.commentLabel sizeThatFits:CGSizeMake(AdaptedWidthValue(305), MAXFLOAT)];
        itemModel.commentLabelHeight = size.height;
        itemModel.moreNum = getRandomNumberFromAtoB(1, 20);
        itemModel.more = YES;
        itemModel.cellHeight = cellDetail.commentLabel.y + itemModel.commentLabelHeight + 10;
        itemModel.cellHeight += itemModel.more?cellDetail.moreLabel.viewHeight+5:0;   // 是否有更多
        [items addObject:itemModel];
    }
    
    self.responses = [items mutableCopy];
    [self.tableView reloadData];
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
- (NSArray<ClassComItemModel *> *)responses{
    if(!_responses){
        _responses = [NSMutableArray array];
    }
    return _responses;
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
    return [self.responses count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ClassComDetailTableViewCell";
    ClassComDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassComDetailTableViewCell" owner:self options:nil] firstObject];
        cell.selectionStyle = NO;
    }
    cell.rowView.hidden = indexPath.row==self.responses.count-1;

    ClassComItemModel *ccim = self.responses[indexPath.row];
    [cell.iconImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:ccim.icon] forState:UIControlStateNormal placeholderImage:kPlaceholderHeadImage];
    cell.userNameLabel.text = ccim.userName;
    cell.commentLabel.attributedText = ccim.commentAttr;
    cell.dateLabel.text = ccim.date;
    cell.commentLabel.text = ccim.comment;
    cell.moreLabel.text = [NSString stringWithFormat:@"  查看%ld回复 >",ccim.moreNum];
    
    // frame
    cell.commentLabel.viewHeight = ccim.commentLabelHeight;
    cell.moreLabel.y = cell.commentLabel.bottom + 5;
    cell.moreLabel.hidden = !ccim.more;
    cell.rowView.y = ccim.cellHeight-0.5;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassComItemModel *csm = self.responses[indexPath.row];
    return csm.cellHeight;
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
    ClassSpaceViewController *vc = [ClassSpaceViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - <************************** 私有方法 **************************>

// !!!: 转换为富文本内容
- (NSMutableAttributedString*)changeToAttr:(NSString*)content{
    NSMutableAttributedString *attr = nil;
    if (content.length==0||content==nil) {
        return attr;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 6;
    attr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:FontSize_16],
                                                                                  NSParagraphStyleAttributeName:style
                                                                                  }];
    return attr;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

@end
