//
//  MYCitySelectPicker.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MYCityPickerSelectedDownBlock)(NSString *selectDate);//确认日期按钮事件回调
typedef void (^MYCityPickerSelectedCancelBlock)();//取消按钮事件回调

@interface MYCitySelectPicker : UIView
@property (assign, nonatomic) BOOL isOnShow;//datePicker是否正在显示，调用
@property (copy, nonatomic) MYCityPickerSelectedDownBlock dateSelectedBlock;//确定按钮点击回调
@property (copy, nonatomic) MYCityPickerSelectedCancelBlock selectCanceledBlock;//取消按钮点击回调

- (instancetype)initWithSuperView:(UIView *)superView;

- (void)show;
- (void)hide;
@end
