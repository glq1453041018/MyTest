//
//  SuggestionViewController.m
//  SuperScholar
//
//  Created by cwn on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "SuggestionViewController.h"
#import "ShareManager.h"
#import <SVProgressHUD.h>

@interface SuggestionViewController ()<UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@end

@implementation SuggestionViewController

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
    [self.navigationBar setTitle:@"意见反馈" leftImage:@"public_left" rightText:nil];
    self.isNeedGoBack = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.commitBtn.backgroundColor = [KColorTheme colorWithAlphaComponent:0.8];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>


#pragma mark - <************************** 代理方法 **************************>
#pragma mark NavigationBarDelegate
// !!!: 返回
-(void)navigationViewLeftClickEvent{
//    [self.navigationController popViewControllerAnimated:YES];
    
    [ShareManager showShareViewWithTitle:@"【某某班级简介】，复制这条信息￥zXsp0KDWbbY￥后打开😊https://itunes.apple.com/cn/app/%E6%85%A7%E7%AD%96%E7%95%A5%E5%A4%A7%E9%98%B3%E7%BA%BF/id1314137172?mt=8😊" body:nil image:nil link:nil withCompletion:^(OSMessage *message, NSError *error) {
        
    }];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.commitBtn.enabled = [textView.text length] > 0;
    self.commitBtn.backgroundColor = [KColorTheme colorWithAlphaComponent:self.commitBtn.enabled ? 1 : 0.8];
}

#pragma mark UITextFieldDelegate

#pragma mark - <************************** 点击事件 **************************>
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)onClickCommitBtn:(UIButton *)sender {
    // !!!: 提交按钮点击事件
    [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <************************** 私有方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}

@end
