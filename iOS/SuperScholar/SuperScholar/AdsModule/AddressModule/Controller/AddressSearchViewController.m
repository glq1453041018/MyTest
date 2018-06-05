//
//  AddressSearchViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/28.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressSearchViewController.h"
#import "AddressModel.h"
#import "UIImage+ImageEffects.h"

@interface AddressSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong ,nonatomic) UISearchBar *searchBar;
@property (strong ,nonatomic) UITableView *table;
@property (strong ,nonatomic) UIButton *cancelBtn;

@property (strong ,nonatomic) NSMutableArray *resultArray;

@end

@implementation AddressSearchViewController

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
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.searchBar becomeFirstResponder];
    [self.view addSubview:self.searchBar];
    
    [self.view addSubview:self.cancelBtn];
    
    [self.view addSubview:self.table];
    
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.table.top, kScreenWidth, 0.5)];
    rowView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:rowView];
    
    
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UISearchBar *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, kStatusBarHeight, kScreenWidth-10*2-40, 30)];
        _searchBar.centerY = kStatusBarHeight + 44/2.0;
        _searchBar.placeholder = @"城市名/首字母";
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.delegate = self;
        UIOffset offect = {10, 0};//第一个值是水平偏移量，第二个是竖直方向的偏移量
        _searchBar.searchTextPositionAdjustment = offect;
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor] size:_searchBar.viewSize andCornerRadius:_searchBar.viewHeight/2.0] forState:UIControlStateNormal];
    }
    return _searchBar;
}

-(UIButton *)cancelBtn{
    if (_cancelBtn==nil) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchBar.right, kStatusBarHeight, 40, 30)];
        _cancelBtn.centerY = kStatusBarHeight + 44/2.0;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:KColorTheme forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_14]];
        [_cancelBtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationbarHeight, kScreenWidth, kScreenHeight-kNavigationbarHeight)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _table;
}


-(NSMutableArray *)resultArray{
    if (_resultArray==nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}


#pragma mark - <************************** 代理方法 **************************>

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressModel *am = self.resultArray[indexPath.row];
    static NSString *cellId = @"UITableViewCell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = FontSize_colorgray;
        cell.textLabel.font = [UIFont systemFontOfSize:AdaptedWidthValue(FontSize_16)];
    }
    cell.textLabel.text = am.cityName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AddressModel *am = self.resultArray[indexPath.row];
    if ([am.typeName isEqualToString:@"ERROR"]) {
        [LLAlertView showSystemAlertViewMessage:@"您的选择不再服务范围" buttonTitles:@[@"确定"] clickBlock:nil];
    }
    else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(addressSearchController:cityModel:)]) {
            [self dismissViewControllerAnimated:NO completion:^{
                [self.delegate addressSearchController:self cityModel:am];
            }];
        }
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName contains [cd] %@ or typeName contains [cd] %@ or cityLetter contains [cd] %@",searchText,searchText,searchText];
    self.resultArray = [[self.originArray filteredArrayUsingPredicate:predicate] mutableCopy];
    if (self.resultArray.count||[searchText length]==0) {
        [self.table reloadData];
    }else{
        AddressModel *am = [AddressModel new];
        am.cityName = @"抱歉，未找到相关城市，可修改后重试";
        am.typeName = @"ERROR";
        [self.resultArray addObject:am];
        [self.table reloadData];
    }
}

#pragma mark - <************************** 点击事件 **************************>
-(void)cancelButtonClicked:(UIButton*)cancal{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
