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
    [ShareManager shareToPlatform:SharePlatformQQ link:@"http://www.baidu.com" title:@"这是标题这是标题这是标题" body:@"这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容这是内容" image:[UIImage imageNamed:@"icon"] withCompletion:^(OSMessage *message, NSError *body) {
        
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
