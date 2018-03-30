//
//  ArrowMenuView.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/29.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ArrowMenuView.h"

@interface ArrowMenuView ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) void(^selectionblock)(NSInteger);
@end
@implementation ArrowMenuView

- (instancetype)initWithFrame:(CGRect)frame withSelectionBlock:(void (^)(NSInteger))block{
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectZero;
        self.selectionblock = block;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tableView];
        [self.tableView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(13, 2, 2, 2));
        }];
    }
    return self;
}

// !!!: 刷新列表
- (void)reloadData{
    if([self.titles count] > 0){
        CGFloat top = 13;
        CGFloat bottom = 2;
        self.viewHeight = [self tableView:self.tableView numberOfRowsInSection:0] * [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] + top + bottom;
    }
    
    [self layoutIfNeeded];
    [self.tableView reloadData];
}

// !!!: 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [self.titles count];
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"arrowmenuid";
    ArrowMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ArrowMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:FontSize_16]];
    }
    [cell layoutIfNeeded];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, indexPath.row == [self.titles count] - 1 ? cell.viewWidth : 0);
    NSString *text = [self.titles objectAtIndex:indexPath.row];
    [cell.button setTitle:text forState:UIControlStateNormal];
    return cell;
}

// !!!: 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectionblock){
        self.selectionblock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

// !!!: 控件初始化
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)titles{
    if(!_titles){
        _titles = [NSMutableArray array];
    }
    return _titles;
}

// !!!: 绘制边框
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat space = 4;
    CGPoint left_top = CGPointMake(space, 13);
    CGPoint right_top = CGPointMake(rect.size.width - space, 13);
    CGPoint left_bottom = CGPointMake(space, rect.size.height - space);
    CGPoint right_bottom = CGPointMake(rect.size.width - space, rect.size.height - space);

    //左上角
    CGContextMoveToPoint(context, left_top.x, left_top.y + space);
    CGContextAddArc(context, left_top.x + space, left_top.y + space, space, -M_PI / 2.0, -M_PI, YES);
    CGContextAddLineToPoint(context, left_top.x + space, left_top.y);
    
    
    //绘三角形(宽6)
    CGPoint arrTop = CGPointMake(rect.size.width - space - 12 - 6, space);
    CGPoint arrLeft = CGPointMake(rect.size.width - space - 12 - 6 * 2, 13);
    CGPoint arrRight= CGPointMake(rect.size.width - space - 12, 13);
    CGContextAddLineToPoint(context, arrLeft.x, arrLeft.y);
    CGContextAddLineToPoint(context, arrTop.x, arrTop.y);
    CGContextAddLineToPoint(context, arrRight.x, arrRight.y);
    
    //右上角
    CGContextAddLineToPoint(context, right_top.x - space, right_top.y);
    CGContextAddArc(context, right_top.x - space, right_top.y + space, space, - M_PI / space, 0, NO);
    CGContextAddLineToPoint(context, right_top.x, right_top.y + space);
    
    //右下角
    CGContextAddLineToPoint(context, right_bottom.x, right_bottom.y - space);
    CGContextAddArc(context, right_bottom.x - space, right_bottom.y - space, space, 0, M_PI / 2.0, NO);
    CGContextAddLineToPoint(context, right_bottom.x - space, right_bottom.y);
    
    //左下角
    CGContextAddLineToPoint(context, left_bottom.x + space, left_bottom.y);
    CGContextAddArc(context, left_bottom.x + space, left_bottom.y - space, space, M_PI / 2.0, M_PI, NO);
    CGContextAddLineToPoint(context, left_bottom.x, left_bottom.y - space);
    
    CGContextClosePath(context);
    

    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4, [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end





@implementation ArrowMenuTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self addSubview:self.button];
        
        [self.button cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (MYImageButton *)button{
    if(!_button){
        _button = [[MYImageButton alloc] init];
        [_button setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"yizan"] forState:UIControlStateNormal];
        [_button setUserInteractionEnabled:NO];
        [_button.titleLabel setFont:[UIFont systemFontOfSize:FontSize_16]];
    }
    return _button;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.button.imageBounds = CGRectMake(22, self.button.viewHeight / 2 - 10, 20, 20);
    self.button.titleBounds = CGRectMake(self.button.imageBounds.origin.x + self.button.imageBounds.size.width + 20, 0, self.button.viewWidth - (self.button.imageBounds.origin.x + self.button.imageBounds.size.width + 20), self.button.viewHeight);
}

@end
