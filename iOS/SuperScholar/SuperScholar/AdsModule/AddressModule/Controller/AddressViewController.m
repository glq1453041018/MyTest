//
//  AddressViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressViewManager.h"

@interface AddressViewController ()
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong ,nonatomic) UISearchBar *searchBar;

// !!!: 数据类
@property (strong ,nonatomic) NSArray *data;
@property (strong ,nonatomic) AddressViewManager *addrManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation AddressViewController

-(void)loadView{
    [super loadView];
    [self.addrManager locationCompletionBlock:^(AMapLocationReGeocode *regeocode, NSError *error) {
        
    }];
}

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
    
    self.data = @[@"",@"",@""];

}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationBar.letfBtn.frame = CGRectMake(0, 0, 22, 22);
    [self.navigationBar.letfBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.navigationBar setCenterView:self.searchBar leftView:self.navigationBar.letfBtn rightView:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.table.tableFooterView = [UIView new];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UISearchBar *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, AdaptedWidthValue(280), 35)];
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundImage = [UIImage new];
    }
    return _searchBar;
}

-(AddressViewManager *)addrManager{
    if (_addrManager==nil) {
        _addrManager = [AddressViewManager new];
    }
    return _addrManager;
}

#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航代理
-(void)navigationViewLeftClickEvent{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = self.data[indexPath.section];
    static NSString *cellId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
