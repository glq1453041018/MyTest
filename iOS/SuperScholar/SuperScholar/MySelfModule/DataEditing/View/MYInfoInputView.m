//
//  MYInfoInputView.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MYInfoInputView.h"

static int view_height = 154;

@interface MYInfoInputView ()<UITextViewDelegate>
@property (strong, nonatomic) NSLayoutConstraint *inputViewBottom;//底部约束，键盘出来时设置为键盘的高度，键盘消失时设置为-输入视图自身高度即可
@property (assign, nonatomic) NSInteger limite_input;//限制个数
@end
@implementation MYInfoInputView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //监听键盘显示和隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textViewBackView.layer.borderWidth = 0.5;
    self.textViewBackView.layer.borderColor = HexColor(0xcccccc).CGColor;
    
    self.textView.delegate = self;
}

- (void)didMoveToSuperview{
    WeakObj(self);
    [self cwn_makeConstraints:^(UIView *maker) {
         weakself.inputViewBottom = maker.leftToSuper(0).rightToSuper(0).heights(view_height).bottomToSuper(-view_height).lastConstraint;
    }];
    
    switch (self.inputType) {
        case MYInfoInputTypeUserName:{
            [self.placeHolder setText:@"请输入用户名"];
            self.limite_input = 14;
            self.wordTypeTipLabel.hidden = NO;
        }
            break;
        case MYInfoInputTypeIntroduce:{
            [self.placeHolder setText:@"请输入个性签名"];
            self.limite_input = 50;
            self.wordTypeTipLabel.hidden = YES;
        }
            break;
        default:{
            [self.placeHolder setText:@"请输入信息"];
            self.limite_input = 50;
            self.wordTypeTipLabel.hidden = YES;
        }
            break;
    }
    
    [self.wordLimiteLabel setText:[NSString stringWithFormat:@"%ld", self.limite_input]];
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
    self.inputViewBottom.constant = view_height;
    [self.superview layoutIfNeeded];
    [CATransaction commit];
    
    self.inputViewBottom.constant = -keyboardFrameNew.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationTime];
    [UIView setAnimationCurve:animationCurve];
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
    
    self.isOnShow = YES;
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
//    if(self.emojiView.emojiViewIsOnShow == NO){//切换表情键盘导致的系统键盘收
    
        self.inputViewBottom.constant = view_height;
       [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationTime];
        [UIView setAnimationCurve:animationCurve];
        [self.superview layoutIfNeeded];
        [UIView commitAnimations];
    
    if(self.infoInputCancelBlock){
        self.infoInputCancelBlock();
    }
    
    self.isOnShow = NO;
//    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if([textView.text length]){
        self.placeHolder.hidden = YES;
    }else{
        self.placeHolder.hidden = NO;
    }
    
        NSString *toBeString = textView.text;
        //获取高亮部分
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0]; // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSInteger length = [textView.text length];
            [self.wordLimiteLabel setText:[NSString stringWithFormat:@"%ld", MAX(0, self.limite_input - length)]];
            
            if(length >= self.limite_input){
                if (toBeString.length > self.limite_input) {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limite_input];
                    if (rangeIndex.length == 1) {
                        textView.text = [toBeString substringToIndex:self.limite_input];
                    } else {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limite_input)];
                        self.textView.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"] ){
        [self onClickCommitBtn:nil];
        return NO;
    }
    return YES;
}

#pragma mark 事件处理
- (IBAction)onClickCommitBtn:(UIButton *)sender {
// !!!: 点击确定按钮
    if(self.infoInputDownBlock){
        self.infoInputDownBlock(self.textView.text);
    }
    [self hide];
}

- (void)show{
// !!!: 显示
    [self.textView becomeFirstResponder];
    [self textViewDidChange:self.textView];
    
    self.alpha =1;
}

- (void)hide{
// !!!: 隐藏
    [self endEditing:YES];
    [UIView animateWithDuration:0.22 animations:^{
        self.alpha = 0;
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
