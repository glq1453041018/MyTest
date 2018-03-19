//
//  MessageRemindViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MessageRemindViewController.h"
#import "ZhaoShengTableViewCell.h"

@interface MessageRemindViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;

//待适配约束，默认64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@end

@implementation MessageRemindViewController

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
    for (int i=0; i < 10; i ++) {
        [self.data addObject:@"fdas"];
    }
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //是否需要导航
    if(self.listType == MessageRemindListTypeDefault){
        [self.navigationBar setTitle:self.title leftImage:@"public_left" rightText:nil];
        self.isNeedGoBack = YES;
    }
    
    //约束适配
    self.viewTop.constant = self.listType == MessageRemindListTypeDefault  ? 64 : 0;
    
    //配置列表
    [self configTable];
}

- (void)configTable{
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - <*********************** 初始化控件/数据 **********************>

- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid = indexPath.row % 4 ? @"zhaoshengcell2" : @"zhaoshengcell";
    ZhaoShengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        if(indexPath.row % 4)
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][1];
        else
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell cwn_makeShiPeis:^(UIView *maker) {
            maker.shiPeiAllSubViews().shiPeiSelf();
        }];
    }
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ShiPei(134);
}

#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

@end