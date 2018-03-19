//
//  MYInfoInputView.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《用户名弹窗、介绍输入弹窗》

#import <UIKit/UIKit.h>
typedef void (^MYInfoInputDownBlock)(NSString *intput_text);//确认日期按钮事件回调

@interface MYInfoInputView : UIView
@property (assign, nonatomic) BOOL isOnShow;//datePicker是否正在显示，调用
@property (copy, nonatomic) MYInfoInputDownBlock infoInputDownBlock;//确定按钮点击回调
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)show;
- (void)hide;
@end
