//
//  MYDatePicker.m
//  GuDaShi
//
//  Created by chenweinan on 17/2/27.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYDatePicker.h"
#define RGBColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

static CGFloat const kDatePickerHeight = 215;
static CGFloat const kNaviPickerBarHeight = 44;

@interface MYDatePicker ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIView *contentView;//self的父视图
@property (nonatomic, strong) UIPickerView *datePicker;//自定义pickerview
@property (nonatomic, strong) UIDatePicker *system_datePicker;//系统pickerview
@property (nonatomic, strong) NSLayoutConstraint *constraintY;//self底部相对父视图底部的约束

//以下二者一起可组成顶部导航
@property (strong, nonatomic) UINavigationBar *naviPickerBar;
@property (strong, nonatomic) UINavigationItem *naviPickerItem;

@property (strong, nonatomic) NSString *selectDate;//当前选中的日期

@property (assign, nonatomic) id <MYDatePickerDatasource> datasource;

@end

@implementation MYDatePicker

- (id)initWithContentView:(UIView *)contentView dataSource:( id <MYDatePickerDatasource>)datasource pickerType:(MYDatePickerType) type{
    if (self = [super init]) {
        _type = type;
        self.contentView = contentView;
        self.datasource = datasource;
        self.backgroundColor = [UIColor clearColor];
        [contentView addSubview:self];
        
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *constraintsH1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
        NSArray *constraintsV1 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[self(==%lf)]", kDatePickerHeight + kNaviPickerBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
        self.constraintY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:kDatePickerHeight + kNaviPickerBarHeight];
        
        [contentView addConstraints:constraintsH1];
        [contentView addConstraints:constraintsV1];
        [contentView addConstraint:self.constraintY];
        
        //UIDatePicker初始化，位置在底部216高度；UINavigationBar初始化，位置在picker的顶部
        [self configDatePickerAndNavigationBar];
    }
    
    return self;
}

#pragma mark 控件初始化

- (void)configDatePickerAndNavigationBar{
    if(self.type == MYDatePickerTypeCustomStyle){
        self.datePicker = [[UIPickerView alloc] init];
        [self.datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.datePicker.dataSource = self;
        self.datePicker.delegate = self;
        [self addSubview:self.datePicker];
    }else{
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        self.system_datePicker = [[UIDatePicker alloc] init];
        self.system_datePicker.locale = locale;
        [self.system_datePicker setBackgroundColor:[UIColor whiteColor]];
        self.system_datePicker.datePickerMode = UIDatePickerModeDate;
        [self.system_datePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.system_datePicker addTarget:self action:@selector(onDatePickerSelectedDate:) forControlEvents:UIControlEventValueChanged];
        [self onDatePickerSelectedDate:self.system_datePicker];
        [self addSubview:self.system_datePicker];
    }
    
    self.naviPickerBar = [[UINavigationBar alloc] init];
    [self.naviPickerBar setClipsToBounds:YES];
    [self.naviPickerBar setBackgroundImage:[self changeColorToImage:KColorTheme] forBarMetrics:UIBarMetricsDefault];
    [self.naviPickerBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:self.naviPickerBar];
    
    NSArray *constraintsH2 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[%@]-0-|", self.type == MYDatePickerTypeCustomStyle ? @"_datePicker" : @"_system_datePicker"] options:0 metrics:nil views:self.type == MYDatePickerTypeCustomStyle ? NSDictionaryOfVariableBindings( _datePicker) : NSDictionaryOfVariableBindings( _system_datePicker)];
    NSArray *constraintsH3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_naviPickerBar]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_naviPickerBar)];
    NSArray *constraintsV2 = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_naviPickerBar(==%lf)]-0-[%@(==%lf)]-0-|", kNaviPickerBarHeight,  self.type == MYDatePickerTypeCustomStyle ? @"_datePicker" : @"_system_datePicker",kDatePickerHeight] options:0 metrics:nil views:self.type == MYDatePickerTypeCustomStyle ? NSDictionaryOfVariableBindings(_naviPickerBar, _datePicker) :NSDictionaryOfVariableBindings(_naviPickerBar, _system_datePicker)];
    
    [self addConstraints:constraintsH2];
    [self addConstraints:constraintsH3];
    [self addConstraints:constraintsV2];
    
    [self configNavigationItem];
}

- (void)configNavigationItem{
    self.naviPickerItem = [[UINavigationItem alloc] init];
    [_naviPickerBar pushNavigationItem:_naviPickerItem animated:NO];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.backgroundColor = [UIColor whiteColor];
    [leftBtn setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    leftBtn.layer.cornerRadius = 4;
    [leftBtn addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    _naviPickerItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [rightBtn setTitleColor:HexColor(0x333333) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    rightBtn.layer.cornerRadius = 4;
    [rightBtn addTarget:self action:@selector(rightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _naviPickerItem.rightBarButtonItem = rightItem;
}

- (void)setCurrentDateRow:(NSInteger)row{
    if(row < [self.datasource numberOfDates] ){
        self.selectDate = [self.datasource titleForRow:row];
    }
    
    [self.datePicker selectRow:row inComponent:0 animated:YES];
}

- (void)setCurrentDate:(NSString *)date format:(NSString *)format{
    if([date length] == 0)
        return;
    
    self.selectDate = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    [self.system_datePicker setDate:[formatter dateFromString:date] animated:YES];
}

- (void)setDatePickerMode:(UIDatePickerMode)mode{
    self.system_datePicker.datePickerMode = mode;
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    [self.system_datePicker setMaximumDate:maximumDate];
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    [self.system_datePicker setMinimumDate:minimumDate];
}

- (void)setToolBarColor:(UIColor *)toolBarColor{
    _toolBarColor = toolBarColor;
    [self.naviPickerBar setBackgroundImage:[self changeColorToImage:KColorTheme] forBarMetrics:UIBarMetricsDefault];
    [self.naviPickerItem.leftBarButtonItem setBackgroundImage:[self changeColorToImage:KColorTheme] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.naviPickerItem.rightBarButtonItem setBackgroundImage:[self changeColorToImage:KColorTheme] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)setConfirmTitle:(NSString *)confirmTitle{
    _confirmTitle = confirmTitle;
    self.naviPickerItem.rightBarButtonItem.title = confirmTitle;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.naviPickerItem.leftBarButtonItem.tintColor = titleColor;
    self.naviPickerItem.rightBarButtonItem.tintColor = titleColor;
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.datasource numberOfDates];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //设置分割线的颜色
    
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = RGBColor(205, 212, 218, 1);
        }
    }
    
    return [self.datasource titleForRow:row];
}

#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectDate = [self.datasource titleForRow:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    CGFloat height = 34;
    if([self.delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]){
        height = [self.delegate pickerView:pickerView rowHeightForComponent:component];
    }
    return height;
}

#pragma mark 事件响应

- (void)onDatePickerSelectedDate:(UIDatePicker *)datePicker{
    NSDate *myDate = datePicker.date;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if(self.system_datePicker.datePickerMode == UIDatePickerModeDate)
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
    else if(self.system_datePicker.datePickerMode == UIDatePickerModeDateAndTime)
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    else if (self.system_datePicker.datePickerMode == UIDatePickerModeTime){
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    self.selectDate = prettyVersion;
}

- (void)leftItemAction:(id)sender{
    [self hidden];
    
    //取消回调
    if(self.selectCanceledBlock){
        self.selectCanceledBlock();
    }
    
    [self.datePicker selectRow:0 inComponent:0 animated:YES];
}

- (void)rightItemAction:(id)sender{
    [self hidden];
    
    if (self.dateSelectedBlock){
        self.dateSelectedBlock(self.selectDate);
    }
}

- (void)show{
    if([self.selectDate length] == 0){
        if(self.maximumDate != nil){
            [self.system_datePicker setDate:self.maximumDate animated:YES];
            [self onDatePickerSelectedDate:self.system_datePicker];
        }
    }
    
    self.isOnShow = YES;
    __weak typeof(self) weakSelf = self;
    self.alpha = 1.0f;
    [self.contentView layoutIfNeeded];
    weakSelf.constraintY.constant = 0.0f;
    [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)hidden{
    self.isOnShow = NO;
    __weak typeof(self) weakSelf = self;
    [self.contentView layoutIfNeeded];
    weakSelf.constraintY.constant = 260.0f;
    [UIView animateWithDuration:0.35f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        weakSelf.alpha = 0.0f;
    }];
}

#pragma mark private methods

- (UIImage *)changeColorToImage:(UIColor *)color{
    UIImage *image;
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context, rect);
    CGContextFillPath(context);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
