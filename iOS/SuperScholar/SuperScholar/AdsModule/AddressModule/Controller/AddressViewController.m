//
//  AddressViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressSearchViewController.h"
// !!!: 视图类
#import "AddressTableViewCell.h"
// !!!: 数据类
#import "AddressViewManager.h"

#import "UIImage+ImageEffects.h"
#import <objc/runtime.h>

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource,AddressSearchDelegate>
// !!!: 视图类
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong ,nonatomic) UISearchBar *searchBar;

// !!!: 数据类
@property (strong ,nonatomic) NSMutableArray *addressData;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation AddressViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    
    // 地图
    [[MapManager share] locationCompletionBlock:^(AMapGeocode *currentAddress, BOOL needUpdate, NSError *error) {
        if (needUpdate&&error==nil) {
            NSString *newCity = currentAddress.city;
            if ([newCity hasSuffix:@"市"]) {
                newCity = [self removeLastOneChar:newCity];
            }
            newCity = newCity.length?newCity:@"";
            AddressModel *am = [AddressModel new];
            am.typeName = @"定位";
            am.cityName = newCity;
            am.cellHeight = 44;
            [self.addressData replaceObjectAtIndex:0 withObject:@[am]];
            [self.table reloadData];
        }
    }];
    
    [AddressViewManager requestDataResponse:^(NSArray *resArray, id error) {
        if (error) {
            DLog(@"获取城市地址错误");
            return ;
        }
        NSMutableArray *tmp = [NSMutableArray arrayWithArray:@[self.addressData.firstObject]];
        [tmp addObjectsFromArray:resArray];
        self.addressData = tmp.mutableCopy;
        [self.table reloadData];
    }];

}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.navigationBar.letfBtn.frame = CGRectMake(0, 0, 22, 22);
    [self.navigationBar.letfBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.navigationBar setCenterView:self.searchBar leftView:self.navigationBar.letfBtn rightView:nil];
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    

    self.table.tableFooterView = [UIView new];
    self.table.sectionIndexColor = KColorTheme;
    
    self.definesPresentationContext=YES;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(UISearchBar *)searchBar{
    if (_searchBar==nil) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, AdaptedWidthValue(250), 30)];
        _searchBar.placeholder = @"城市名/首字母";
        _searchBar.backgroundImage = [UIImage new];
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor groupTableViewBackgroundColor] size:_searchBar.viewSize andCornerRadius:_searchBar.viewHeight] forState:UIControlStateNormal];
        UIButton *tapBtn = [[UIButton alloc] initWithFrame:_searchBar.bounds];
        [_searchBar addSubview:tapBtn];
        [tapBtn addTarget:self action:@selector(tapBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBar;
}

-(NSMutableArray *)addressData{
    if (_addressData==nil) {
        _addressData = [NSMutableArray array];
        NSString *location = @"定位中...";
        AddressModel *am = [AddressModel new];
        am.typeName = @"定位";
        am.cityName = location;
        am.cellHeight = 45;
        [_addressData addObject:@[am]];
    }
    return _addressData;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航代理
-(void)navigationViewLeftClickEvent{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// !!!: 列表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 1;
    }
    NSArray *items = self.addressData[section];
    return items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = self.addressData[indexPath.section];
    if (indexPath.section<=1) {
        static NSString *cellId = @"UITableViewCell1";
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell==nil) {
            cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectionStyle = NO;
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        [cell.subViews removeAllObjects];
        CGFloat space = 10;
        CGFloat itemWidth = ((kScreenWidth - 30) - space*4) / 3.0;
        CGFloat itemHeight = 35;
        if (indexPath.section<=1) {
            for (int i=0; i<items.count; i++) {
                AddressModel *am = items[i];
                NSInteger column = i%3;
                NSInteger row = i/3;
                CGFloat centerX = space*(column+1) + itemWidth/2.0 * (2*column+1);
                CGFloat centerY = space*row + itemHeight/2.0*(2*row+1) + 5;
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
                btn.center = CGPointMake(centerX, centerY);
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitle:am.cityName.length?am.cityName:@"-" forState:UIControlStateNormal];
                [btn setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_15]];
                btn.titleLabel.adjustsFontSizeToFitWidth = YES;
                btn.tag = i;
                btn.layer.masksToBounds = YES;
                [cell.subViews addObject:btn];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                objc_setAssociatedObject(btn, @"addressData", am, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [cell addSubview:btn];
            }
        }
        return cell;
    }
    else{
        AddressModel *am = items[indexPath.row];
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
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *items = self.addressData[section];
    AddressModel *am = items.firstObject;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgView.viewWidth-10*2, bgView.viewHeight)];
    label.textColor = KColorTheme;
    label.font = [UIFont systemFontOfSize:FontSize_14];
    label.text = am.typeName;
    [bgView addSubview:label];
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *items = self.addressData[indexPath.section];
    AddressModel *am = items.firstObject;
    return am.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *items = self.addressData[indexPath.section];
    AddressModel *am = items[indexPath.row];
    [self selectCity:am];
}
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<self.addressData.count; i++) {
        NSArray *items = self.addressData[i];
        AddressModel *am = items.firstObject;
        NSString *title = am.typeName;
        if (am.typeName.length>2) {
            title = [am.typeName substringToIndex:2];
        }
        [titles addObject:title];
    }
    return titles;
}


// !!!: 城市搜索代理
-(void)addressSearchController:(UIViewController *)ctrl cityModel:(AddressModel *)am{
    [self selectCity:am];
}


#pragma mark - <************************** 点击事件 **************************>
// !!!: 点击事件
-(void)btnAction:(UIButton*)btn{
    AddressModel *am = objc_getAssociatedObject(btn, @"addressData");
    [self selectCity:am];
}

-(void)tapBtnAction{
    AddressSearchViewController *ctrl = [AddressSearchViewController new];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (int i=2; i<self.addressData.count; i++) {
        NSArray *items = self.addressData[i];
        [tmpArray addObjectsFromArray:items];
    }
    ctrl.originArray = tmpArray;
    ctrl.delegate = self;
    [self presentViewController:ctrl animated:NO completion:nil];
}



#pragma mark - <************************** 其他方法 **************************>
-(void)selectCity:(AddressModel*)am{
    if ([am.typeName isEqualToString:@"定位"]&&[am.cityName containsString:@"定位"]) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(addressSearchController:cityModel:)]) {
        [self.delegate addressSearchController:self cityModel:am];
        // 重新设置城市
        [[MapManager share] setCity:am.cityName];
    }
    [self navigationViewLeftClickEvent];
}


-(NSString*)removeLastOneChar:(NSString*)origin{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];
    }else{
        cutted = origin;
    }
    return cutted;
}


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
