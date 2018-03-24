//
//  MyCMViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MyCMViewController.h"
#import "MyCommentTableViewCell.h"

@interface MyCMViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MyCMViewController

#pragma mark - <************************** 页面生命周期 **************************>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    for (int i = 0; i < 20; i ++) {
        [self.data addObject:[TESTDATA randomContent]];
    }
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configTableView];
}

- (void)configTableView{
    self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    [self.table cwn_makeConstraints:^(UIView *maker) {
        maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.table setDataSource:self];
    [self.table setDelegate:self];
    self.table.tableFooterView = [[UIView alloc] init];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>

- (NSMutableArray *)data{
    if(!_data){
        _data = [NSMutableArray array];
    }
    return _data;
}




#pragma mark - <************************** 代理方法 **************************>

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.data count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [self.data objectAtIndex:indexPath.row];
    
    if(indexPath.section % 2 == 0){//图片或视频
        NSString *identifier = @"mycommentid";
        MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyCommentTableViewCell class]) owner:nil options:nil];
            for (MyCommentTableViewCell *obj in cells) {
                if([obj isKindOfClass:[MyCommentTableViewCell class]]){
                    cell = obj;
                    break;
                }
            }
            cell.shiPeiAllSubViews();
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LineSpace];//调整行间距
        NSMutableAttributedString *attr = [cell.replayLabel.attributedText mutableCopy];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attr length])];
        [cell.replayLabel setAttributedText:attr];
        
        [cell.messageContent setAttributedText:[self adjustLineSpace:text font:FontSize_12 color:FontSize_colorlightgray lineSpace:2.0]];
        [cell.contentLabel setAttributedText:[self adjustLineSpace:text font:FontSize_16 color:FontSize_colorgray lineSpace:LineSpace]];
        cell.videoPlayImage.hidden = indexPath.section % 4;
        return cell;
    }else{//文本
        NSString *identifier = @"mycommentid1";
        MyCommentTableViewCell_NOImage *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyCommentTableViewCell class]) owner:nil options:nil];
            for (MyCommentTableViewCell_NOImage *obj in cells) {
                if([obj isKindOfClass:[MyCommentTableViewCell_NOImage class]]){
                    cell = obj;
                    break;
                }
            }
            cell.shiPeiAllSubViews();
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LineSpace];//调整行间距
        NSMutableAttributedString *attr = [cell.replayLabel.attributedText mutableCopy];
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attr length])];
        [cell.replayLabel setAttributedText:attr];
        
        [cell.messageContent setAttributedText:[self adjustLineSpace:text font:FontSize_12 color:FontSize_colorlightgray lineSpace:2.0]];
        [cell.contentLabel setAttributedText:[self adjustLineSpace:text font:FontSize_16 color:FontSize_colorgray lineSpace:LineSpace]];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ShiPei(259);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}




#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>

- (NSMutableAttributedString *)adjustLineSpace:(NSString *)text font:(CGFloat)font color:(UIColor *)color lineSpace:(CGFloat)lineSpace{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];//调整行间距
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributStr length])];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, attributStr.length)];
    
    return attributStr;
}



#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    NSLog(@"%@释放掉",[self class]);
}


@end
