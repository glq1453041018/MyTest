//
//  MYInfoInputView.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《用户名弹窗、介绍输入弹窗》

#import <UIKit/UIKit.h>
typedef  NS_ENUM(NSUInteger, MYInfoInputType){
   MYInfoInputTypeUserName,
    MYInfoInputTypeIntroduce
};

typedef void (^MYInfoInputDownBlock)(NSString *intput_text);//输入文本结束事件回调
typedef void (^MYInfoInputCancelBlock)();//输入文本取消事件回调

@interface MYInfoInputView : UIView
@property (assign, nonatomic) BOOL isOnShow;//datePicker是否正在显示，调用

@property (copy, nonatomic) MYInfoInputDownBlock infoInputDownBlock;//确定按钮点击回调
@property (copy, nonatomic) MYInfoInputCancelBlock infoInputCancelBlock;//取消回调

@property (weak, nonatomic) IBOutlet UITextView *textView;//输入文本框
@property (weak, nonatomic) IBOutlet UIView *textViewBackView;//输入文本框背景
@property (weak, nonatomic) IBOutlet UILabel *placeHolder;//提示语

@property (assign, nonatomic) MYInfoInputType inputType;//用户名、介绍
@property (weak, nonatomic) IBOutlet UILabel *wordTypeTipLabel;//输入文字类型说明
@property (weak, nonatomic) IBOutlet UILabel *wordLimiteLabel;//文字限制

- (void)show;
- (void)hide;
@end
