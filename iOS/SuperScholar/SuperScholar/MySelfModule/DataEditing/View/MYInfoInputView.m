//
//  MYInfoInputView.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MYInfoInputView.h"

static int view_height = 100;

@interface MYInfoInputView ()
@property (strong, nonatomic) NSLayoutConstraint *inputViewBottom;//底部约束，键盘出来时设置为键盘的高度，键盘消失时设置为-输入视图自身高度即可
@end
@implementation MYInfoInputView

- (void)awakeFromNib{
    [super awakeFromNib];
    //监听键盘显示和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didMoveToSuperview{
    WeakObj(self);
    [self cwn_makeConstraints:^(UIView *maker) {
         weakself.inputViewBottom = maker.leftToSuper(0).rightToSuper(0).height(view_height).bottomToSuper(-view_height).lastConstraint;
    }];
}

- (void)show{
    [self.textView becomeFirstResponder];
}

- (void)hide{
    [self.textView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)aNotification{
    //TODO: 键盘通知监听-弹出事件
    //键盘坐标发生变化，_inputView的坐标要跟着变 和tableView的高度也要变
    // NSLog(@"%@",noti.userInfo);
    NSDictionary *dic =aNotification.userInfo;
    
    //NSNumber:NSValue  数字类
    //从字典中取出的值 肯定是对象类型
    //1.获取键盘动画结束位置frame
    NSNumber *keyboardFrame= dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameNew = keyboardFrame.CGRectValue;
    
    //2.获取动画时间
    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //3.获取动画的速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
    
    //4.改变_inputView和tableView的坐标
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.inputViewBottom.constant = -view_height;
    [self.superview layoutIfNeeded];
    [CATransaction commit];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    //TODO: 键盘通知监听-收起事件
    NSDictionary *dic =aNotification.userInfo;
    
    //NSNumber:NSValue  数字类
    //从字典中取出的值 肯定是对象类型
    
    //2.获取动画时间
    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    //3.获取动画的速度
    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
    
    //4.改变_inputView和tableView的坐标
//    if(self.emojiView.emojiViewIsOnShow == NO){//切换表情键盘导致的系统键盘收起
//        self.stockViewHeight.constant = ShiPei(35) * [self.stockViewController.stockArray count];
//        self.stockSearchViewHeight.constant = 0;
//        self.keyboardIsOnShow = NO;
//        self.inputToolBarBottom.constant = 10;
//        self.inputViewLeft.constant = 12;
//        self.inputBackView.layer.cornerRadius = 5;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:animationTime];
//        [UIView setAnimationCurve:animationCurve];
//        [self.view layoutIfNeeded];
//        [UIView commitAnimations];
//    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
