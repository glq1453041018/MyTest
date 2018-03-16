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
#import "ClassInfoFootView.h"
#import "PhotoBrowser.h"

#import "ClassInfoModel.h"
#import "ClassInfoManager.h"

@interface ClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,MYBannerScrollViewDelegate,ClassInfoTableViewCell_TitleDelegate>
// !!!: 视图类
@property (strong ,nonatomic) UITableView *table;
@property (strong ,nonatomic) ClassInfoHeadView *headView;
@property (strong ,nonatomic) ClassInfoFootView *footView;
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
    [ClassInfoManager requestDataResponse:^(NSArray *resArray, id error) {
        if (error) {
            return;
        }
        self.data = resArray.mutableCopy;
        [self.table reloadData];
    }];
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
    
    [self.view addSubview:self.footView];
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
        _headView.scrollView.delegate = self;
    }
    return _headView;
}

-(ClassInfoFootView *)footView{
    if (_footView==nil) {
        _footView = [[[NSBundle mainBundle] loadNibNamed:@"ClassInfoFootView" owner:nil options:nil] firstObject];
        _footView.frame = CGRectMake(0, kScreenHeight-AdaptedWidthValue(50), kScreenWidth, AdaptedWidthValue(50));
        [_footView.advisoryBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}


-(NSMutableArray *)data{
    if (_data==nil) {
        _data = [NSMutableArray array];
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
        static NSString *cellId = @"ClassInfoTableViewCell_Title";
        ClassInfoTableViewCell_Title *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil];
            for (id cellItem in cells) {
                if ([cellItem isKindOfClass:ClassInfoTableViewCell_Title.class]) {
                    cell = cellItem;
                    cell.selectionStyle = NO;
                    break;
                }
            }
        }
        [cell loadData:items.firstObject];
        cell.delegate = self;
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
                    cell.selectionStyle = NO;
                    break;
                }
            }
        }
        ClassInfoModel_PingJia *cimpj = items.firstObject;
        cell.starView.scorePercent = MIN(cimpj.starNum, 5.0) / 5.0;
        cell.starLabel.text = [NSString stringWithFormat:@"%.1f分",cimpj.starNum];
        cell.commentLabel.text = [NSString stringWithFormat:@"%ld人评价",cimpj.commentNum];
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
                    cell.selectionStyle = NO;
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
    NSArray *items = self.data[indexPath.section];
    ClassInfoModel *cim = nil;
    if (indexPath.section==0) {
        cim = [items firstObject][indexPath.row];
    }
    else{
        cim = items[indexPath.row];
    }
    return cim.cellHeight;
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
    NSArray *items = self.data[indexPath.section];
    if (indexPath.section == 2) {
        ClassInfoModel_Item *cimi = items[indexPath.row];
        if ([cimi.code isEqualToString:@"phone"]) {
            [self callPhone];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.headView.scrollView scrollViewDidScroll:scrollView];
}

// !!!: 滚动视图的代理事件
-(void)bannerScrollView:(MYBannerScrollView *)bannerScrollView didClickScrollView:(NSInteger)pageIndex{
    [PhotoBrowser showURLImages:bannerScrollView.imagePaths placeholderImage:[UIImage imageNamed:@"zhanweifu"] selectedIndex:pageIndex];
}

// !!!: 标题视图的代理事件
-(void)classInfoTableViewCell_TitleClickEvent:(NSInteger)index data:(ClassInfoModel *)model{
    DLog(@"点击了:%@",model.key);
    
}


#pragma mark - <************************** 点击事件 **************************>
// !!!: 拨打电话
-(void)callPhone{
    NSString *phoneNumber = @"10086";
    if (phoneNumber.length) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
        else{
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
// !!!: 私聊



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
