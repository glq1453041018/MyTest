//
//  DataEditingViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "DataEditingViewController.h"
#import "DataEditTableViewCell.h"
#import <SVProgressHUD.h>
#import "MYDatePicker.h"

@interface DataEditingViewController ()<UITableViewDelegate, UITableViewDataSource, MYDatePickerDatasource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) UIView *backgroundView;//黑色背景图
@property (strong, nonatomic) MYDatePicker *birthDatePicker;//生日选择器
@property (strong, nonatomic) MYDatePicker *sexPicker;//性别选择器


@end

@implementation DataEditingViewController

#pragma mark - <************************** 页面生命周期 **************************>

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
    self.data = [NSMutableArray arrayWithObjects:@[@"头像", @"用户名", @"介绍"],@[@"性别", @"生日", @"地区"], nil];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configNavigationBar];
    [self configTableView];
}

- (void)configNavigationBar{
    [self.navigationBar setTitle:@"编辑资料" leftImage:@"public_left" rightText:nil];
    self.isNeedGoBack = YES;
}

- (void)configTableView{
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IEW_WIDTH, CGFLOAT_MIN)];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DataEditTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"DataEditingCellid"];
    
    self.tableFooterView.viewWidth = IEW_WIDTH;
    self.tableView.tableFooterView = self.tableFooterView;
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}

- (MYDatePicker *)birthDatePicker{
    WeakObj(self);
    if(!_birthDatePicker){
        _birthDatePicker = [[MYDatePicker alloc] initWithContentView:self.backgroundView dataSource:nil pickerType:MYDatePickerTypeSystemStyle];
        _birthDatePicker.datePickerMode = UIDatePickerModeDate;
        _birthDatePicker.maximumDate = [NSDate date];
        [_birthDatePicker setDateSelectedBlock:^(NSString *date){
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [weakself hideBackgrounView];
        }];
        [_birthDatePicker setSelectCanceledBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _birthDatePicker;
}

- (MYDatePicker *)sexPicker{
    WeakObj(self);
    if(!_sexPicker){
        _sexPicker = [[MYDatePicker alloc] initWithContentView:self.backgroundView dataSource:self pickerType:MYDatePickerTypeCustomStyle];
        [_sexPicker setCurrentDateRow:0];
        [_sexPicker setDateSelectedBlock:^(NSString *selectSex){
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [weakself hideBackgrounView];
        }];
        [_sexPicker setSelectCanceledBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _sexPicker;
}

- (UIView *)backgroundView{
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.view addSubview:_backgroundView];
        [_backgroundView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _backgroundView.alpha = 0;
    }
    [self.view bringSubviewToFront:_backgroundView];
    return _backgroundView;
}


#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
- (void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.data objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    DataEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DataEditingCellid"];
    cell.leftLabel.text = text;
    cell.headerImage.hidden = !(indexPath.section == 0 && indexPath.row == 0);
    cell.rightLabel.hidden = !cell.headerImage.hidden;
    cell.rightLabel.text = @"待完善";
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([text isEqualToString:@"生日"]){
        if(self.birthDatePicker.isOnShow == NO){
            [self.birthDatePicker show];
            [self showBackgrounView];
        }else{
            [self.birthDatePicker hidden];
            [self hideBackgrounView];
        }
    }else if([text isEqualToString:@"性别"]){
        if(self.sexPicker.isOnShow == NO){
            [self.sexPicker show];
            [self showBackgrounView];
        }else{
            [self.sexPicker hidden];
            [self hideBackgrounView];
        }
    }else{
        text = [NSString stringWithFormat:@"跳转%@", text];
        LLAlert(text);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark MYDatePickerDatasource
- (NSInteger)numberOfDates{
    return 2;
}
- (NSString *)titleForRow:(NSInteger)row{
    return row == 0 ? @"男" : @"女";
}
 

#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickExit:(id)sender{
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
    SaveInfoForKey(nil, UserId_NSUserDefaults);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.birthDatePicker.isOnShow)
    [self.birthDatePicker hidden];
    if(self.sexPicker.isOnShow)
    [self.sexPicker hidden];
    
    [self hideBackgrounView];
}


#pragma mark - <************************** 其他方法 **************************>

- (void)showBackgrounView{
    [UIView animateWithDuration:0.33 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)hideBackgrounView{
    [UIView animateWithDuration:0.33 animations:^{
        self.backgroundView.alpha = 0;
    }];
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
