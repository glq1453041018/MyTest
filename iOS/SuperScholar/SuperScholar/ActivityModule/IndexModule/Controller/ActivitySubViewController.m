//
//  ActivitySubViewController.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivitySubViewController.h"
#import "ActivityDetailWebViewController.h"
#import "ClassComDetailViewController.h"
#import "ActivityVideoDetailViewController.h"


#import "ActivitySubViewManager.h"
#import "NSArray+ExtraMethod.h"

#import "ZhaoShengTableViewCell.h"
#import "ActivityTableViewCell.h"

@interface ActivitySubViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ActivitySubViewManager *manager;

//待适配约束，默认64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTop;
@end

@implementation ActivitySubViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self.loadingView startAnimating];
    [self getDataFormServer_isReset:YES];
    
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer_isReset:(BOOL)isReset{
    WeakObj(self);
   [self.manager requestFromServer:isReset withCompletion:^(BOOL isLastData, NSError *error) {
       [weakself.tableView.mj_header endRefreshing];
       [weakself.tableView.mj_footer endRefreshing];
       [weakself.loadingView stopAnimating];
       [weakself.tableView reloadData];
    
       if(isReset == NO && isLastData == YES){//上拉加载更多
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
       }
   }];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //约束适配
    self.viewTop.constant = 0;
    
    //配置列表
    [self configTable];
}

- (void)configTable{
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
    WeakObj(self);
    self.tableView.mj_header = [MJDIYHeader headerWithRefreshingBlock:^{
        [weakself getDataFormServer_isReset:YES];
    }];
    self.tableView.mj_footer = [MJDIYAutoFooter footerWithRefreshingBlock:^{
        [weakself getDataFormServer_isReset:NO];
    }];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - <*********************** 初始化控件/数据 **********************>
- (ActivitySubViewManager *)manager{
    if(!_manager){
        _manager= [ActivitySubViewManager new];
    }
    return _manager;
}

#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.manager.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellid;
    ActivityModel *model = [self.manager.data objectAtIndexNotOverFlow:indexPath.row];
    
    if(self.listType == ActivityListTypeGoodArticle){
        if(indexPath.row % 4 == 0){//模型判断是带图片的cell
                cellid = @"articleid";
                __block ActivityTableViewCell_Image *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                if(cell == nil){
                    NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ActivityTableViewCell class]) owner:nil options:nil];
                    for(UITableViewCell *obj in cells){
                        if([obj isMemberOfClass:[ActivityTableViewCell_Image class]]){
                            cell = (ActivityTableViewCell_Image *)obj;
                        }
                    }
                }
                //加载数据
                [cell.content setAttributedText:[self adjustLineSpace:model.title]];
                [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kPlaceholderImage];
                return cell;
        }else{//模型判断是不带图片的cell
            cellid = @"articleid2";
            __block ActivityTableViewCell_NO_Image *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if(cell == nil){
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ActivityTableViewCell class]) owner:nil options:nil];
                for(UITableViewCell *obj in cells){
                    if([obj isMemberOfClass:[ActivityTableViewCell_NO_Image class]]){
                        cell = (ActivityTableViewCell_NO_Image *)obj;
                    }
                }
            }
            //加载数据
            [cell.content setAttributedText:[self adjustLineSpace:model.title]];
            return  cell;
        }
    }else if(self.listType == ActivityListTypeActivityShow){
        if(indexPath.row == 2){
            cellid = @"activity";
            __block ActivityTableViewCell_Video *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if(cell == nil){
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ActivityTableViewCell class]) owner:nil options:nil];
                for(UITableViewCell *obj in cells){
                    if([obj isMemberOfClass:[ActivityTableViewCell_Video class]]){
                        cell = (ActivityTableViewCell_Video *)obj;
                    }
                }
            }
            //加载数据
            [cell.content setAttributedText:[self adjustLineSpace:model.title]];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kPlaceholderImage];
            return  cell;
        }
    }
    
    
    
    
    
    
    

    if(indexPath.row % 4 == 0){//模型判断是带图片的cell
        cellid = @"zhaoshengcell";
        __block ZhaoShengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];;
        if(cell == nil){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil];
            for(UITableViewCell *obj in cells){
                if([obj isMemberOfClass:[ZhaoShengTableViewCell class]]){
                    cell = (ZhaoShengTableViewCell *)obj;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell adjustFrame];
        }
        //加载数据
        [cell.contentLable setAttributedText:[self adjustLineSpace:model.title]];
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:kPlaceholderImage];
        return cell;
    }else{//模型判断是不带图片的cell
        cellid = @"zhaoshengcell2";
        __block ZhaoShengTableViewCell_NOImage *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if(cell == nil){
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil];
            for(UITableViewCell *obj in cells){
                if([obj isMemberOfClass:[ZhaoShengTableViewCell_NOImage class]]){
                    cell = (ZhaoShengTableViewCell_NOImage *)obj;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell adjustFrame];
        }
        //加载数据
        [cell.contentLable setAttributedText:[self adjustLineSpace:model.title]];
        return cell;
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.listType == ActivityListTypeGoodArticle){
        return indexPath.row % 4 == 0 ? ShiPei(278) : ShiPei(152);
    }else if(self.listType == ActivityListTypeActivityShow){
        return indexPath.row == 2 ? ShiPei(288) : ShiPei(134);
    }
    return ShiPei(134);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.listType == ActivityListTypeActivityShow && indexPath.row == 2){//视频文章
        ActivityVideoDetailViewController *vc = [ActivityVideoDetailViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    if(indexPath.row % 2 == 0){//网页文章
            ActivityDetailWebViewController *vc = [ActivityDetailWebViewController new];
            vc.title = self.title;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
    } else{//普通文章
        ClassComDetailViewController *ctrl = [ClassComDetailViewController new];
        ctrl.title = self.title;
        ctrl.messageType = MessageTypeDefault;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>

- (NSMutableAttributedString *)adjustLineSpace:(NSString *)text{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LineSpace];//调整行间距
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:text];

    [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributStr length])];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:FontSize_colorgray range:NSMakeRange(0, attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize_16] range:NSMakeRange(0, attributStr.length)];

    return attributStr;
}




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}


@end
