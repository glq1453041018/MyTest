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
        self.frame = CGRectMake(frame.origin.x - 2, frame.origin.y - 10, frame.size.width + 4, frame.size.height + 12);
        self.selectionblock = block;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.tableView];
        [self.tableView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(10, 2, 2, 2));
        }];
    }
    return self;
}

// !!!: 刷新列表
- (void)reloadData{
    [self.tableView reloadData];
}

// !!!: 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"arrowmenuid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSString *text = [self.titles objectAtIndex:indexPath.row];
    [cell.textLabel setText:text];
    return cell;
}

// !!!: 代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectionblock){
        self.selectionblock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat space = 2;
    CGPoint left_top = CGPointMake(space, 10);
    CGPoint right_top = CGPointMake(rect.size.width - space, 10);
    CGPoint left_bottom = CGPointMake(space, rect.size.height - space);
    CGPoint right_bottom = CGPointMake(rect.size.width - 2, rect.size.height - space);

    //左上角
    CGContextMoveToPoint(context, left_top.x, left_top.y + space);
    CGContextAddArc(context, left_top.x + space, left_top.y + space, space, -M_PI / 2.0, -M_PI, YES);
    CGContextAddLineToPoint(context, left_top.x + space, left_top.y);
    
    
    //绘三角形(宽6)
    CGPoint arrTop = CGPointMake(rect.size.width - space - 12 - 8, space);
    CGPoint arrLeft = CGPointMake(rect.size.width - space - 12 - 8 * 2, 10);
    CGPoint arrRight= CGPointMake(rect.size.width - space - 12, 10);
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
    

//    CGContextSetLineWidth(context, 2);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 5, [UIColor blackColor].CGColor);
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
