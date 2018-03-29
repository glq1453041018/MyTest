//
//  MYCitySelectPicker.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MYCitySelectPicker.h"
static CGFloat const kCitySelectDatePickerHeight = 215;
static CGFloat const kCitySelectNaviPickerBarHeight = 44;

@interface MYCitySelectPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSMutableArray *dataArray;//全部数据
@property (strong, nonatomic) NSMutableArray *citiesArray;//城市数据

@property (strong, nonatomic) NSString *selectdCity;

@property (strong, nonatomic) NSLayoutConstraint *bottomToSup;//距离父视图的底部，默认0，隐藏设置为259即可;

//以下二者一起可组成顶部导航
@property (strong, nonatomic) UINavigationBar *naviPickerBar;
@property (strong, nonatomic) UINavigationItem *naviPickerItem;
@end
@implementation MYCitySelectPicker

- (instancetype)initWithSuperView:(UIView *)superView{
    if(self = [super init]){
        self.backgroundColor = [UIColor whiteColor];
        
        WeakObj(self);
        [self loadData];
        
        [superView addSubview:self];
        [self cwn_makeConstraints:^(UIView *maker) {
            weakself.bottomToSup = maker.leftToSuper(0).rightToSuper(0).heights(kCitySelectDatePickerHeight + kCitySelectNaviPickerBarHeight).bottomToSuper(kCitySelectDatePickerHeight + kCitySelectNaviPickerBarHeight).lastConstraint;
        }];
        
        _pickView = [[UIPickerView alloc] init];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        [self addSubview:_pickView];
        [_pickView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(kCitySelectNaviPickerBarHeight, 0, 0, 0));
        }];
        
        
        self.naviPickerBar = [[UINavigationBar alloc] init];
        [self.naviPickerBar setClipsToBounds:YES];
        [self.naviPickerBar setBackgroundImage:[self changeColorToImage:KColorTheme] forBarMetrics:UIBarMetricsDefault];
        [self.naviPickerBar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.naviPickerBar];
        [self configToolItem];
        [self.naviPickerBar cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(0).rightToSuper(0).heights(kCitySelectNaviPickerBarHeight);
        }];
    }
    return self;
}

- (void)configToolItem{
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

#pragma mark - loadData
- (void)loadData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    _citiesArray = _dataArray[0][@"cities"];
}

#pragma mark - <*********************** 代理处理 ************************>
#pragma mark - dataSource
//注意这里是几列的意思。我刚刚开始学得时候也在这里出错，没理解
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _dataArray.count;
    }else {
        return _citiesArray.count;
    }
}

#pragma mark - delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 150;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

//返回每行显示的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [self changeSpearatorLineColor];
    if (component == 0) {
        return [NSString stringWithFormat:@"%@",_dataArray[row][@"state"]];
    }else {
        return [NSString stringWithFormat:@"%@",_citiesArray[row]];
    }
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *singleLine in self.pickView.subviews){
        if (singleLine.frame.size.height < 1){
            singleLine.backgroundColor = RGBColor(205, 212, 218, 1);
        }
    }
}

//当改变省份时，重新加载第2列的数据，部分加载
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _citiesArray = _dataArray[row][@"cities"];
        [_pickView reloadComponent:1];
    }else{
        _selectdCity = _citiesArray[row];
    }
}

#pragma mark - <*********************** 事件处理 ************************>

// !!!: 显示动画
- (void)show{
    self.bottomToSup.constant = kCitySelectNaviPickerBarHeight + kCitySelectDatePickerHeight;
    [self.superview layoutIfNeeded];
    self.bottomToSup.constant = 0;
    self.alpha = 1;
    [UIView animateWithDuration:0.33 animations:^{
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
            self.isOnShow = YES;
    }];
}

// !!!: 隐藏动画
- (void)hide{
    self.bottomToSup.constant = 0;
    [self.superview layoutIfNeeded];
    self.bottomToSup.constant = kCitySelectNaviPickerBarHeight + kCitySelectDatePickerHeight;
    [UIView animateWithDuration:0.33 animations:^{
        [self.superview layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.isOnShow = NO;
        self.alpha = 0;
    }];
}

- (void)leftItemAction:(id)sender{
    [self hide];
    
    //取消回调
    if(self.selectCanceledBlock){
        self.selectCanceledBlock();
    }
}

- (void)rightItemAction:(id)sender{
    [self hide];
    
    if (self.dateSelectedBlock){
        self.dateSelectedBlock(self.selectdCity);
    }
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
