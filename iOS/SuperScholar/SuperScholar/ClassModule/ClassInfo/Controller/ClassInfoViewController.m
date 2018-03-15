//
//  ClassInfoViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "ClassInfoHeadView.h"
#import "ClassInfoTableViewCell.h"

#import "ClassInfoModel.h"

@interface ClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
// !!!: 视图类
@property (strong ,nonatomic) UITableView *table;
@property (strong ,nonatomic) ClassInfoHeadView *headView;
// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *data;

@end

@implementation ClassInfoViewController

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
    self.data = self.data;
    [self.table reloadData];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 导航栏
    [self.navigationBar setTitle:nil leftImage:kGoBackImageString rightImage:@""];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;
    [self.view insertSubview:self.table belowSubview:self.navigationBar];
    
    self.table.tableHeaderView = self.headView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = NO;
        _table.tableFooterView = [UIView new];
        _table.showsVerticalScrollIndicator = NO;
    }
    return _table;
}

-(ClassInfoHeadView *)headView{
    if (_headView==nil) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"ClassInfoHeadView" owner:nil options:nil] firstObject];
    }
    return _headView;
}


-(NSMutableArray *)data{
    if (_data==nil) {
        ClassInfoModel_Item *cimi = [ClassInfoModel_Item new];
        cimi.icon = @"testImg";
        cimi.key = @"联系方式";
        cimi.value = @"18093872047";
        _data = [NSMutableArray arrayWithArray:@[@[cimi],@[cimi],@[cimi,cimi,cimi]]];
    }
    return _data;
}



#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *items = self.data[section];
    return items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = self.data[indexPath.section];
    if (indexPath.section==0) {
        static NSString *cellId = @"CSCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        ClassInfoModel_Item *cim = items[indexPath.row];
        cell.textLabel.text = cim.key;
        return cell;
    }
    else if (indexPath.section==1){
        static NSString *cellId = @"ClassInfoTableViewCell_PingJia";
        ClassInfoTableViewCell_PingJia *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil];
            for (id cellItem in cells) {
                if ([cellItem isKindOfClass:ClassInfoTableViewCell_PingJia.class]) {
                    cell = cellItem;
                    break;
                }
            }
        }
        return cell;
    }
    else{
        static NSString *cellId = @"ClassInfoTableViewCell_Item";
        ClassInfoTableViewCell_Item *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil];
            for (id cellItem in cells) {
                if ([cellItem isKindOfClass:ClassInfoTableViewCell_Item.class]) {
                    cell = cellItem;
                    break;
                }
            }
        }
        ClassInfoModel_Item *cimi = items[indexPath.row];
        cell.iconImageView.image = [UIImage imageNamed:cimi.icon];
        cell.titleLabel.text = cimi.key;
        cell.detailLabel.text = cimi.value;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptedWidthValue(44);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 10;
    }
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headView.scrollView scrollViewDidScroll:scrollView];
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
