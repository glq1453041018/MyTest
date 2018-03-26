//
//  PersonalInfoViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MYSegmentController.h"
#import "PersonalInfoListViewController.h"
/// !!!: 嵌套列表
#import "LolitaTableView.h"
#import "MYAutoScaleView.h"

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,LolitaTableViewDelegate>
@property (nonatomic,strong) MYSegmentController *segement;
/// !!!: 视图类
@property (strong ,nonatomic) LolitaTableView *mainTable;
@property (assign, nonatomic) BOOL viewDidLayout;

@property (weak, nonatomic) IBOutlet UIView *topBackView;//头部背景视图
@property (weak, nonatomic) IBOutlet UIView *topView;//头部视图
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;//高斯模糊背景图
@property (weak, nonatomic) IBOutlet UIView *didLoginView;//已登录视图
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (strong, nonatomic) NSLayoutConstraint *top;
@property (strong, nonatomic) NSLayoutConstraint *top1;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化视图
    [self initUI];
    // 获取数据
    [self getDataFormServer];
}

- (void)viewDidLayoutSubviews{
    if(self.viewDidLayout == NO){
        self.viewDidLayout = YES;
        [self addChildViewController:self.segement];
    }
}


#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[TESTDATA randomUrlString]] placeholderImage:kPlaceholderHeadImage];
    [self.headImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[TESTDATA randomUrlString]] forState:UIControlStateNormal placeholderImage:kPlaceholderImage];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationBar setTitle:self.title leftImage:kGoBackImageString rightText:@"私信"];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    [self.view insertSubview:self.mainTable belowSubview:self.navigationBar];
    WeakObj(self);
    [self.backImageView cwn_makeConstraints:^(UIView *maker) {
        weakself.top = maker.leftToSuper(0).rightToSuper(0).bottomToSuper(0).topToSuper(0).lastConstraint;
    }];
    [self.topBackView cwn_makeConstraints:^(UIView *maker) {
        weakself.top1 = maker.leftToSuper(0).rightToSuper(0).bottomToSuper(0).topToSuper(0).lastConstraint;
    }];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(LolitaTableView *)mainTable{
    if (_mainTable==nil) {
        _mainTable = [[LolitaTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.delegate_StayPosition = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.showsVerticalScrollIndicator = NO;
        _mainTable.type = LolitaTableViewTypeMain;
        _mainTable.tableHeaderView = self.topView;
//        [_mainTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _mainTable;
}

-(MYSegmentController *)segement{
    if (_segement==nil) {
        NSMutableArray *vc_array = [NSMutableArray array];
        PersonalInfoListViewController *comment0 = [PersonalInfoListViewController new];
        PersonalInfoListViewController *comment1 = [PersonalInfoListViewController new];
        PersonalInfoListViewController *comment2 = [PersonalInfoListViewController new];
        [vc_array addObject:comment0];
        [vc_array addObject:comment1];
        [vc_array addObject:comment2];

        NSArray *titles = @[@"动态", @"评论", @"收藏"];
        
        _segement = [MYSegmentController segementControllerWithFrame:CGRectMake(0, 0, IEW_WIDTH, kScreenHeight-self.navigationBar.bottom) titles:titles withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor groupTableViewBackgroundColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:KColorTheme withArticleY:38];
        
        [_segement.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
            [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
        }];
        
        [_segement setReturnString:@"0"];
        [_segement setSegementTintColor:KColorTheme];
        [_segement setSegementViewControllers:vc_array];
        _segement.style = GLQSegementStyleDefault;
    }
    return _segement;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.segement.view];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenHeight-self.navigationBar.bottom;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 100;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navigationBar.backgroundColor = [KColorTheme colorWithAlphaComponent:alpha];
}

// !!!: 悬停的位置
-(CGFloat)lolitaTableViewHeightForStayPosition:(LolitaTableView *)tableView{
    return [tableView rectForSection:0].origin.y-self.navigationBar.bottom;
}


#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGPoint point = [change[@"new"] CGPointValue];
    self.top.constant = MIN(0, point.y);
    self.top1.constant = MIN(0, point.y);
}


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    if(self.mainTable)
        //[self removeObserver:self.mainTable forKeyPath:@"contentOffset"];
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
