//
//  CommentView.m
//  GuDaShi
//
//  Created by LOLITA on 2017/9/4.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()<UITextViewDelegate>
{
    CGFloat originHeight_TV;
    CGFloat originHeight;
    CGFloat Y;              // 变动
    CGFloat originY;        // 最初的Y
    
    BOOL editable;
}
// !!!: 视图类
@property (strong ,nonatomic) UIButton *bgView; // 用于收起键盘
@property (strong ,nonatomic) UIActivityIndicatorView *indicator;   // 加载指示器
// !!!: 数据类
@property (copy ,nonatomic) NSString *content;
@end
@implementation CommentView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self adjustAllViewsX:YES W:YES];
    
    editable = YES;
    
    self.commentTV.layer.cornerRadius = 3;
    self.commentTV.layer.masksToBounds = YES;
    self.commentTV.delegate = self;
    self.commentTV.scrollEnabled = NO;
    
    self.senderBtn.layer.cornerRadius = 5;
    self.senderBtn.layer.masksToBounds = YES;
    [self hideSenderBtn];
    [self.senderBtn addTarget:self action:@selector(senderBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // 加载指示器
    [self.senderBtn addSubview:self.indicator];
    self.senderBtn.backgroundColor = KColorTheme;
    [self changeSenderStyleUnEidit:self.senderBtn];
    
    // 用于收起键盘
    [self addSubview:self.bgView];
    
    // 监听键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    // 记录下最初高度
    originHeight_TV = self.commentTV.viewHeight;
    originHeight = self.viewHeight;
    // 最初的y
    originY = self.y;
}
#pragma mark - <************************** 初始化 **************************>
-(UIButton *)bgView{
    if (_bgView==nil) {
        _bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
        [_bgView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _bgView.alpha = 0;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
        [_bgView addGestureRecognizer:pan];
    }
    return _bgView;
}
-(UIActivityIndicatorView *)indicator{
    if (_indicator==nil) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.frame = self.senderBtn.bounds;
    }
    return _indicator;
}


#pragma mark - <************************** TextView的代理协议 **************************>
// !!!: TextView的代理方法
-(void)textViewDidChange:(UITextView *)textView{
    self.content = textView.text;
    if ([textView.text isEqualToString:@""]) {
        self.tipLabel.hidden = NO;
        [self changeSenderStyleUnEidit:self.senderBtn];
    }else{
        self.tipLabel.hidden = YES;
        if ([self.content stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
            [self changeSenderStyleEidit:self.senderBtn];
        }
    }
    [self changeTextViewStyle:textView];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([self.content stringByReplacingOccurrencesOfString:@" " withString:@""].length==0) {
            [LLAlertView showSystemAlertViewMessage:@"请输入内容" buttonTitles:@[@"确定"] clickBlock:nil];
            return NO;
        }else{
            [self senderBtnAction];
        }
        return NO;
    }
    return editable;
}



#pragma mark - <************************** 其他事件 **************************>

// !!!: 发送操作
-(void)senderBtnAction{
    if ([self.delegate respondsToSelector:@selector(commentView:sendMessage:complete:)]) {
        // 开启指示器
        [self.indicator startAnimating];
        [self.senderBtn setTitle:@"" forState:UIControlStateNormal];
        // 不可交互
        self.senderBtn.userInteractionEnabled = NO;
        // 不可再输入
        editable = NO;
        // 不可收起
        self.bgView.userInteractionEnabled = NO;
        
        [self.delegate commentView:self sendMessage:self.content complete:^(BOOL success) {
            self.bgView.userInteractionEnabled = YES;
            if (success) {
                // 收起键盘
                self.tipLabel.text = @"评论";
                self.commentTV.text = @" ";
                [self.commentTV deleteBackward];    // 清除内容
                if (self.commentTV.isFirstResponder) {
                    [self.commentTV resignFirstResponder];
                    [self hideView];
                }
                [self changeSenderStyleUnEidit:self.senderBtn];
            }
            else{
                [self changeSenderStyleEidit:self.senderBtn];
            }
            editable = YES;
            // 停止加载
            [self.indicator stopAnimating];
            [self.senderBtn setTitle:@"发送" forState:UIControlStateNormal];
            
        }];
    }
}

// !!!: 键盘显示
-(void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary *dic =notification.userInfo;
    // 获取键盘的frame
    NSNumber *keyboardFrame= dic[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrameNew = keyboardFrame.CGRectValue;
    // 动画时间
//    float animationTime =   [dic[@"UIKeyboardAnimationDurationUserInfoKey"]floatValue];
    // 动画速度
//    int animationCurve =[dic[@"UIKeyboardAnimationCurveUserInfoKey"]intValue];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:animationTime];
//    [UIView setAnimationCurve:animationCurve];
    self.y = keyboardFrameNew.origin.y - originHeight;
    Y = self.y;
    self.bgView.y = -kScreenHeight;
    self.bgView.viewHeight = kScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 1;
    }];
    self.senderBtn.alpha = 1;
    [self showSenderBtn];
//    [UIView commitAnimations];
    [self changeTextViewStyle:self.commentTV];
}

-(void)keyboardDidHide:(NSNotification*)notification{
    [self closeKeyboard];
}

-(void)closeKeyboard{
    self.y = originY;
    self.viewHeight = originHeight;
    self.commentTV.viewHeight = originHeight_TV;
    self.commentTV.centerY = self.viewHeight/2.0;
    self.senderBtn.centerY = self.viewHeight/2.0;
    self.tipLabel.centerY = self.viewHeight/2.0;
    [self hideSenderBtn];
    self.bgView.y = 0;
    self.bgView.viewHeight = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
    }];
}

// !!!: 键盘隐藏
// !!!: 收起键盘事件
-(void)hideView{
    [self.commentTV resignFirstResponder];
    float animationTime = 0.25;
    // 获取动画的速度
    int animationCurve = 7;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    self.y = originY;
    self.viewHeight = originHeight;
    self.commentTV.viewHeight = originHeight_TV;
    self.commentTV.centerY = self.viewHeight/2.0;
    self.senderBtn.centerY = self.viewHeight/2.0;
    self.tipLabel.centerY = self.viewHeight/2.0;
    [self hideSenderBtn];
    self.bgView.y = 0;
    self.bgView.viewHeight = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
    }];
    [UIView commitAnimations];
}


// !!!: 改变TV的样式
-(void)changeTextViewStyle:(UITextView*)TV{
    CGSize size = [TV sizeThatFits:CGSizeMake(TV.viewWidth, MAXFLOAT)];
    // 改变高度
    if(size.height<originHeight_TV){
        size.height = originHeight_TV;
    }
    CGFloat maxHeight = originHeight_TV * 3;
    size.height = MIN(size.height, maxHeight);  // 限制最高高度
    TV.viewHeight = size.height;
    self.viewHeight = size.height + 10;
    TV.centerY = self.viewHeight/2.0;
    self.senderBtn.centerY = self.viewHeight/2.0;
    self.tipLabel.centerY = self.viewHeight/2.0;
    // 当达到最高时可滚动
    TV.scrollEnabled = maxHeight==size.height?YES:NO;
    if (self.y == Y - (self.viewHeight - originHeight)) {
        return;
    }
    DLog(@"self.y:%f,Y:%f,self.viewHeight:%f,originHeight:%f",self.y,Y,self.viewHeight,originHeight);
    self.y = Y - (self.viewHeight - originHeight);
}

// !!!: 改变按钮样式
-(void)changeSenderStyleUnEidit:(UIButton*)sender{
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
}
-(void)changeSenderStyleEidit:(UIButton*)sender{
    sender.userInteractionEnabled = YES;
    sender.backgroundColor = KColorTheme;
}

// !!!: 显隐发送按钮
-(void)hideSenderBtn{
    self.senderBtn.hidden = YES;
    self.commentTV.viewWidth = self.viewWidth - 10*2;
}
-(void)showSenderBtn{
    self.senderBtn.hidden = NO;
    self.commentTV.viewWidth = self.viewWidth - 10*2 - self.senderBtn.viewWidth - 10;
}

// !!!: 超过父视图的子视图可以点击
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSArray *subViews = self.subviews;
    if ([subViews count] > 1)
    {
        for (UIView *aSubView in subViews)
        {
            if ([aSubView pointInside:[self convertPoint:point toView:aSubView] withEvent:event])
            {
                return YES;
            }
        }
    }
    if (point.x > 0 && point.x < self.frame.size.width && point.y > 0 && point.y < self.frame.size.height)
    {
        return YES;
    }
    return NO;
}


-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pag{
    [self.commentTV resignFirstResponder];
    [self closeKeyboard];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end
