//
//  LLListPickView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "LLListPickView.h"
@interface LLListPickView ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *table;
@property (copy ,nonatomic) NSArray *data;
@property (assign ,nonatomic) BOOL lock;
@end
@implementation LLListPickView

-(void)showItems:(NSArray *)items{
    if (items.count==0||self.lock) {
        return;
    }
    self.lock = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.lock = NO;
    });
    self.data = items;
    [self.table reloadData];
    
    self.isCenterPoint = NO;
    self.animation = [CAAnimation new];
    self.contentView = self.table;
    CGFloat tableHeight = AdaptedWidthValue(50)*(items.count+1) + 10;
    self.table.top = kScreenHeight;
    self.table.viewHeight = tableHeight;
    
    
    [self show];
    [UIView animateWithDuration:0.25 animations:^{
        self.table.transform = CGAffineTransformTranslate(self.table.transform, 0, -self.table.viewHeight);
    } completion:nil];
    
    WS(ws);
    self.touchBgView = ^(LLAlertView *alertView) {
        [ws closeLLAlertViewFinished:nil];
    };
}


-(UITableView *)table{
    if (_table==nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.scrollEnabled = NO;
        _table.backgroundColor = [UIColor clearColor];
    }
    return _table;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.data.count;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = FontSize_colordarkgray;
        cell.textLabel.font = [UIFont systemFontOfSize:FontSize_16];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //分割线补全
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }
    if (indexPath.section==0) {
        cell.textLabel.text = self.data[indexPath.row];
    }else{
        cell.textLabel.text = @"取消";
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 10;
    }
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptedWidthValue(50);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        DLog(@"选择了：%ld项",indexPath.row);
        if (self.delegate&&[self.delegate respondsToSelector:@selector(lllistPickViewItemSelected:)]) {
            [self.delegate lllistPickViewItemSelected:indexPath.row];
        }
    }
    [self closeLLAlertViewFinished:nil];
}



-(void)closeLLAlertViewFinished:(void(^)())finishHide{
    [UIView animateWithDuration:0.25 animations:^{
        if (!CGAffineTransformIsIdentity(self.table.transform)) {
            self.table.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [self hideCompletion:nil];
        if (finishHide) {
            finishHide();
        }
    }];
}




-(void)dealloc{
    
}


@end
