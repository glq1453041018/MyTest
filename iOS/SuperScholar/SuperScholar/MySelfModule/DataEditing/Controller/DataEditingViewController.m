//
//  DataEditingViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/16.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "DataEditingViewController.h"
#import "DataEditTableViewCell.h"
#import "RemotePushManager.h"
#import <SVProgressHUD.h>
#import "MYDatePicker.h"
#import "MYCitySelectPicker.h"
#import <TZImagePickerController.h>
#import "MYInfoInputView.h"
#import "IMManager.h"

@interface DataEditingViewController ()<UITableViewDelegate, UITableViewDataSource, MYDatePickerDatasource, TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;

@property (strong, nonatomic) NSMutableArray *data;

@property (strong, nonatomic) UIView *backgroundView;//黑色背景图
@property (strong, nonatomic) MYDatePicker *birthDatePicker;//生日选择器
@property (strong, nonatomic) MYDatePicker *sexPicker;//性别选择器
@property (strong, nonatomic) MYCitySelectPicker *cityPicker;//城市选择器

@property (strong, nonatomic) NSString *photoUrl;//待发送相册图片链接
@property (strong, nonatomic) UIImage *photoImage;//待发送相册图片

@property (strong, nonatomic) MYInfoInputView *usernameInputView;//用户名修改
@property (strong, nonatomic) MYInfoInputView *introduceInputView;//介绍修改


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
        _birthDatePicker.alpha = 0;
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
        _sexPicker.alpha = 0;
        [_sexPicker setCurrentDateRow:0];
        [_sexPicker setDateSelectedBlock:^(NSString *selectSex){
            UserModel *origin_model = [UserModel new];
            origin_model.useName = [AppInfo share].user.useName;
            origin_model.userId = [AppInfo share].user.userId;
            origin_model.img = [AppInfo share].user.img;
            origin_model.address = [AppInfo share].user.address;
            origin_model.gender = [AppInfo share].user.gender;
            origin_model.desc = [AppInfo share].user.desc;
            origin_model.uuid = [AppInfo share].user.uuid;
            origin_model.account = [AppInfo share].user.account;
            
            
            //提交，成功才回调
            [AppInfo share].user.gender = selectSex;
            [[AppInfo share] editUserInfoWithCompletion:^(BOOL successed){
                if(!successed){
                    [AppInfo share].user = origin_model;
                    [weakself hideBackgrounView];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"设置成功"];
                    [weakself hideBackgrounView];
                }
            }];
        }];
        [_sexPicker setSelectCanceledBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _sexPicker;
}

- (MYCitySelectPicker *)cityPicker{
    WeakObj(self);
    if(!_cityPicker){
        _cityPicker = [[MYCitySelectPicker alloc] initWithSuperView:self.backgroundView];
         _cityPicker.alpha = 0;
        [_cityPicker setDateSelectedBlock:^(NSString *selectCity){
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [weakself hideBackgrounView];
        }];
        [_cityPicker setSelectCanceledBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _cityPicker;
}

- (MYInfoInputView *)usernameInputView{
    WeakObj(self);
    if(!_usernameInputView){
        _usernameInputView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MYInfoInputView class]) owner:nil options:nil] firstObject];
        _usernameInputView.inputType = MYInfoInputTypeUserName;
        _usernameInputView.alpha = 0;
        [self.backgroundView addSubview:_usernameInputView];
        [_usernameInputView setInfoInputDownBlock:^(NSString *username){
            [[weakself.data objectAtIndex:0] replaceObjectAtIndex:1 withObject:username] ;
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [weakself hideBackgrounView];
        }];
        [_usernameInputView setInfoInputCancelBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _usernameInputView;
}

- (MYInfoInputView *)introduceInputView{
    WeakObj(self);
    if(!_introduceInputView){
        _introduceInputView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MYInfoInputView class]) owner:nil options:nil] firstObject];
        _introduceInputView.inputType = MYInfoInputTypeIntroduce;
        _introduceInputView.alpha = 0;
        [self.backgroundView addSubview:_introduceInputView];
        [_introduceInputView setInfoInputDownBlock:^(NSString *username){
            [[weakself.data objectAtIndex:0] replaceObjectAtIndex:2 withObject:username] ;
            [SVProgressHUD showSuccessWithStatus:@"设置成功"];
            [weakself hideBackgrounView];
        }];
        [_introduceInputView setInfoInputCancelBlock:^(){
            [weakself hideBackgrounView];
        }];
    }
    return _introduceInputView;
}

- (UIView *)backgroundView{
    if(!_backgroundView){
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.view addSubview:_backgroundView];
        [_backgroundView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.view layoutIfNeeded];
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
    
    NSString *rightLabel = @"待完善";
    if(indexPath.section == 0 && indexPath.row == 0 && [[AppInfo share].user.img length]){
        [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[AppInfo share].user.img] placeholderImage:[UIImage imageNamed:@"bgImage"]];
    }
    else if(indexPath.section == 0 && indexPath.row == 1 && [[AppInfo share].user.useName length])
        rightLabel = [AppInfo share].user.useName;
    else if(indexPath.section == 0 && indexPath.row == 2 && [[AppInfo share].user.desc length]){
        rightLabel = [AppInfo share].user.desc;
    }else if(indexPath.section == 1 && indexPath.row == 0 && [[AppInfo share].user.gender length]){
        rightLabel = [AppInfo share].user.gender;
    }else if(indexPath.section == 1 && indexPath.row == 2 && [[AppInfo share].user.address length]){
        rightLabel = [AppInfo share].user.address;
    }
    cell.rightLabel.text = rightLabel;
    
    if([rightLabel isEqualToString:@"待完善"]){
        cell.rightLabel.textColor = KColorTheme;
    }else{
        cell.rightLabel.textColor = [UIColor lightGrayColor];
    }
    
    if(indexPath.section == 0 && indexPath.row == 0){
        cell.headerImage.hidden = NO;
        cell.headerImage.image = self.photoImage ? self.photoImage : cell.headerImage.image;
    }else{
        cell.headerImage.hidden = YES;
    }
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
            [self.sexPicker setCurrentDateRow:[[AppInfo share].user.gender isEqualToString:@"女"] ? 1 : 0];
            [self showBackgrounView];
        }else{
            [self.sexPicker hidden];
            [self hideBackgrounView];
        }
    }else if([text isEqualToString:@"地区"]){
        if(self.cityPicker.isOnShow == NO){
            [self.cityPicker show];
            [self showBackgrounView];
        }else{
            [self.cityPicker hide];
            [self hideBackgrounView];
        }
    } else if([text isEqualToString:@"头像"]){
        [self pushImagePickerController];
    }else if([text isEqualToString:@"用户名"]){
        if(self.usernameInputView.isOnShow == NO){
            [self.usernameInputView.textView setText:[AppInfo share].user.useName];
            [self.usernameInputView show];
            [self showBackgrounView];
        }else{
            [self.usernameInputView hide];
            [self hideBackgrounView];
        }
    }else if([text isEqualToString:@"介绍"]){
        if(self.introduceInputView.isOnShow == NO){
            [self.introduceInputView.textView setText:[AppInfo share].user.desc];
            [self.introduceInputView show];
            [self showBackgrounView];
        }else{
            [self.introduceInputView hide];
            [self hideBackgrounView];
        }
    }else{
        text = [NSString stringWithFormat:@"跳转%@", text];
        [LLAlertView showSystemAlertViewMessage:text buttonTitles:@[@"确定"] clickBlock:nil];
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

#pragma mark TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    WeakObj(self);
//    [photos enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [TeacherSpaceManager uploadImage:obj response:^(NSString *imageUrlString, id error) {
//            weakself.photoUrl = imageUrlString;
//            weakself.photoImage = obj;
//            [weakself textFieldShouldReturn:weakself.textField];
//        }];
//    }];
    
    UIImage *image = [photos firstObject];
    
    [[AppInfo share] uploadHeaderWithImage:image Completion:^(BOOL successed) {
        if(successed){
            weakself.photoImage = image;
            [weakself.tableView reloadData];
        }
    }];
}


#pragma mark - <************************** 点击事件 **************************>
- (IBAction)onClickExit:(id)sender{
    [[AppInfo share] logoutEventTestWithCompletion:^{
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        [[RemotePushManager defaultManager] unBindAccountToAliPushServer];
        [IMManager callThisBeforeISVAccountLogout];
        [[AppInfo share] clearUserInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.birthDatePicker.isOnShow)
        [self.birthDatePicker hidden];
    if(self.sexPicker.isOnShow)
        [self.sexPicker hidden];
    if(self.cityPicker.isOnShow)
        [self.cityPicker hide];
    if(self.usernameInputView.isOnShow)
        [self.usernameInputView hide];
    if(self.introduceInputView.isOnShow)
        [self.introduceInputView hide];
    
    [self hideBackgrounView];
}


#pragma mark - <************************** 其他方法 **************************>

- (void)showBackgrounView{
    [UIView animateWithDuration:0.22 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)hideBackgrounView{
    [UIView animateWithDuration:0.22 animations:^{
        self.backgroundView.alpha = 0;
    }];
}

// !!!: push到第三方图片选择控制器中
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    //    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    // 设置目前已经选中的图片数组
    //    imagePickerVc.selectedAssets = self.selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.navigationBar.barTintColor = KColorTheme;
    imagePickerVc.navigationBar.tintColor = [UIColor whiteColor];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0, IEW_HEGHT / 2.0 - IEW_WIDTH / 2.0, IEW_WIDTH, IEW_WIDTH);
    imagePickerVc.needCircleCrop = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
