//
//  MessageRemindViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MessageRemindViewController.h"
#import "ActivityDetailWebViewController.h"
#import "ClassComDetailViewController.h"
#import "ShareManager.h"
#import "ZhaoShengTableViewCell.h"
#import "TESTDATA.h"

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
        [self.data addObject:[TESTDATA randomContent]];
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
    NSString *text = [self.data objectAtIndex:indexPath.row];
    
    NSString *cellid = indexPath.row % 4 ? @"zhaoshengcell2" : @"zhaoshengcell";
    ZhaoShengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        if(indexPath.row % 4)
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][1];
        else
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentLable setAttributedText:[self adjustLineSpace:text]];
        
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row % 2 == 0){//网页文章
        ActivityDetailWebViewController *vc = [ActivityDetailWebViewController new];
        vc.title = self.title;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else{//普通文章
        ClassComDetailViewController *ctrl = [ClassComDetailViewController new];
        ctrl.title = self.title;
        ctrl.messageType = MessageTypeDefault;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>

- (NSMutableAttributedString *)adjustLineSpace:(NSString *)text{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LineSpace];//调整行间距
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributStr length])];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:FontSize_colorgray range:NSMakeRange(0, attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize_16] range:NSMakeRange(0, attributStr.length)];
    
    return attributStr;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

@end
