//
//  AdressDetailViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsDetailViewController.h"
#import "AdsWebViewViewController.h"

#import "MYBannerScrollView.h"
#import "ZhaoShengTableViewCell.h"
#import "AdsDetailTableViewCell.h"

#import "PhotoBrowser.h"

@interface AdsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MYBannerScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *centerImage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet MYBannerScrollView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tablefootView;



@end

@implementation AdsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];

    
    
}
#pragma mark - <************************** navigationDelaGate **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    [self creatTableView];
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航栏
    
    self.centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.centerImage sd_setImageWithURL:[NSURL URLWithString:@"http://pic33.photophoto.cn/20141023/0017030062939942_b.jpg"] placeholderImage:[UIImage imageNamed:@""]];
    [self.navigationBar setTitle:@"" leftImage:kGoBackImageString rightImage:@""];
//    [self.navigationBar setCenterView:self.centerImage leftView:kGoBackImageString rightView:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;

}

#pragma mark - <*********************** 初始化控件/数据 **********************>

-(void)creatTableView{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , IEW_WIDTH, IEW_HEGHT-44) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }
    [self.tableView setSeparatorColor:SeparatorLineColor];
    self.tableView.backgroundColor=[UIColor redColor];
//    MJDIYHeader *header = [MJDIYHeader headerWithRefreshingTarget:self refreshingAction:@selector(RefreshNewData)];
//    self.tableView.mj_header = header;
    
    MJDIYAutoFooter *footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置尾部
    self.tableView.mj_footer = footer;
    [self.tableView.mj_footer setHidden:YES];
    [self creatScrollerView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    DLog(@"%lf",IEW_HEGHT-44);
    [self.tablefootView adjustFrame];
    self.tablefootView.frame = CGRectMake(0, IEW_HEGHT-self.tablefootView.frame.size.height, self.tablefootView.frame.size.width, self.tablefootView.frame.size.height);
    [self.view addSubview:self.tablefootView];
}
-(void)creatScrollerView{
    [self.tableHeadView adjustFrame];

    NSArray *picsUrl = @[
                         @"http://pic33.photophoto.cn/20141023/0017030062939942_b.jpg",
                         @"http://pic14.nipic.com/20110427/5006708_200927797000_2.jpg",
                         @"http://pic23.nipic.com/20120803/9171548_144243306196_2.jpg",
                         @"http://pic39.nipic.com/20140311/8821914_214422866000_2.jpg",
                         @"http://pic7.nipic.com/20100609/3143623_160732828380_2.jpg",
                         @"http://pic9.photophoto.cn/20081128/0020033015544930_b.jpg",
                         @"http://pic2.16pic.com/00/35/74/16pic_3574684_b.jpg",
                         @"http://pic42.nipic.com/20140605/9081536_142458626145_2.jpg",
                         @"http://pic35.photophoto.cn/20150626/0017029557111337_b.jpg"
                         ];
    [self.tableHeadView loadImages:picsUrl estimateSize:CGSizeMake(self.tableHeadView.frame.size.width , self.tableHeadView.frame.size.height)];
    self.tableHeadView.location = locationCenter;
    self.tableHeadView.backgroundColor = [UIColor cyanColor];
    self.tableHeadView.useScaleEffect = YES;
    self.tableHeadView.needBgView = YES;
    self.tableHeadView.useVerticalParallaxEffect = YES;

 
    self.tableHeadView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeadView;
}
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - <************************** 获取数据 **************************>
//下拉
-(void)RefreshNewData{
    self.page = 1;
    [self getDataFormServer];
}
//上拉加载
-(void)loadMoreData{
    [self getDataFormServer];
}
// !!!: 获取数据
-(void)getDataFormServer{
    
    //    NSString *url = [NSString stringWithFormat:@"%@%@",YuMing3,JingDianAnLi];
    //
    //    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
    //                         [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"userid",
    //                         self.channelid,@"channel_id",
    //                         [NSNumber numberWithInteger:self.page],@"page",
    //                         [NSNumber numberWithInt:10],@"pagesize",
    //                         nil];
    //    __weak typeof(self) weakself = self;
    //    service *servi = [[service alloc]init];
    //
    //    [servi requestWithURLString:url parameters:dic type:HttpRequestTyepPost success:^(id responseObject) {
    //
    //        NSArray *resultArr = [responseObject objectForKey:@"table"];
    //
    //        if (weakself.page==1) {
    //            [weakself.dataArray removeAllObjects];
    //        }
    //        [resultArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            JingDianAnLiModel *model = [JingDianAnLiModel objectWithModuleDic:obj hintDic:nil];
    //            [weakself.dataArray addObject:model];
    //        }];
    //        [weakself.tableView reloadData];
    //
    //        weakself.tableView.mj_footer.hidden = NO;
    //        //        // 拿到当前的下拉刷新控件，结束刷新状态
    //        [weakself.tableView.mj_footer endRefreshing];
    //        [weakself.tableView.mj_header endRefreshing];
    //
    //        if(weakself.dataArray.count == 0){
    //            weakself.tableView.mj_footer.hidden = YES;
    //            NoDaTaFootView *footview = [[NoDaTaFootView alloc]initWithFrame:CGRectMake(0, (MAIN_HEIGHT-170-64-30)/2.0, MAIN_WIDTH, 170)];
    //            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT-64)];
    //            [view addSubview:footview];
    //            [footview SetImageWithImage:@"NodataImage" andTitle:@"暂无相关数据，请耐心等待！"];
    //            weakself.tableView.tableFooterView = view;
    //
    //        }
    //        else{
    //            UIView *View = [[UIView alloc]initWithFrame:CGRectZero];
    //            weakself.tableView.tableFooterView =View ;
    //        }
    //        if(weakself.dataArray.count != 0&&resultArr.count == 0){
    //            [weakself.tableView.mj_footer endRefreshingWithNoMoreData] ;
    //        }
    //        weakself.page++;
    //    } failure:^(NSError *error) {
    //        [weakself.tableView.mj_header endRefreshing];
    //        [weakself.tableView.mj_footer endRefreshing];
    //        if ([error isKindOfClass:[NSError class]]) {
    //            NSError * err = (NSError *)error;
    //            [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
    //                if (index == 1) {
    //                    [self getDataFormServer];
    //                }
    //            } message:ServerError_Description(err.code) buttonTitles:@"取消",@"重试",nil];
    //        }
    //        [weakself.loadingView stopAnimating];
    //    }];
    
    
}


#pragma mark - <************************** tableView代理方法 **************************>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return CGFLOAT_MIN;
    }else{
        return 10;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
         return [[UIView alloc]init];
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, IEW_WIDTH, 10)];
        view.backgroundColor = TableBackGroundColor;
        return view;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 98*MAIN_SPWPW;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
           return 44*MAIN_SPWPW;
        }else{
         return 50*MAIN_SPWPW;
        }
        
    }else{
        return IEW_HEGHT;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        static NSString *cellId = @"AdsDetailcell";
        AdsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AdsDetailTableViewCell" owner:self options:nil];
            for (id cellItem in nibs) {
                if ([cellItem isKindOfClass:AdsDetailTableViewCell.class]) {
                    cell = cellItem;
                    cell.selectionStyle = NO;
                    break;
                }
            }
            [cell adjustFrame];
            
            
        }
        //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //        [paragraphStyle setLineSpacing:LineSpace];//调整行间距
        //
        //        NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:@"新爱婴早教莆田教育中心新爱婴早教莆田教育中心新爱婴早教婴早教莆田教育婴早教莆田教育莆田教育中心新爱婴早教莆田教育中心"];
        //
        //        //    if (fenxianTip.length>5) {
        //        [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributStr length])];
        //        //设置文字颜色
        //        [attributStr addAttribute:NSForegroundColorAttributeName value:FontSize_colorgray range:NSMakeRange(0, attributStr.length)];
        //        //设置文字大小
        //        [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize_16] range:NSMakeRange(0, attributStr.length)];
        //
        //        //    }
        //
        //        //赋值
        //        cell.contentLable.attributedText = attributStr;
        //        cell.contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
        
        //        Adsdetail_PingJia
        
        return cell;
    }else if (indexPath.section==1){
        
        if (indexPath.row == 0) {
            static NSString *cellId = @"Adsdetail_PingJia";
            AdsDetailTableViewCell_comment *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell==nil) {
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"AdsDetailTableViewCell" owner:nil options:nil];
                for (id cellItem in cells) {
                    if ([cellItem isKindOfClass:AdsDetailTableViewCell_comment.class]) {
                        cell = cellItem;
                        cell.selectionStyle = NO;
                        break;
                    }
                }
                [cell adjustFrame];
            }
            //            ClassInfoModel_PingJia *cimpj = items.firstObject;
            cell.starView.scorePercent = 4.5 / 5.0;
            cell.starLabel.text = [NSString stringWithFormat:@"%.1f分",4.5];
            cell.commentLabel.text = [NSString stringWithFormat:@"%d人评价",200];
            return cell;
        }else{
            static NSString *cellId = @"Adsdetail_address";
            AdsDetailTableViewCell_adress *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell==nil) {
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"AdsDetailTableViewCell" owner:nil options:nil];
                for (id cellItem in cells) {
                    if ([cellItem isKindOfClass:AdsDetailTableViewCell_adress.class]) {
                        cell = cellItem;
                        cell.selectionStyle = NO;
                        break;
                    }
                }
                [cell adjustFrame];
            }
            
            return cell;

        }

    }else if (indexPath.section == 2){
        static NSString *cellId = @"Adsdetail_webView";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT)];
            AdsWebViewViewController *webview = [[AdsWebViewViewController alloc]initWithNibName:@"AdsWebViewViewController" bundle:nil];
            webview.urlString = @"https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=%E9%A2%9C%E8%89%B2&oq=podfile.lock&rsv_pq=d4e26e5e00017958&rsv_t=dd1bkgpFm6Zi3rX473AXC%2FBFcQJJOiOHhX1R63Zp4Arqw%2BPiJ09kKy0lcSk&rqlang=cn&rsv_enter=1&inputT=856&rsv_sug3=6&rsv_sug1=5&rsv_sug7=100&bs=podfile.lock";

            [cell addSubview:webview.view];
            [self addChildViewController:webview];
        }
        return cell;
//          return [[UITableViewCell alloc]init];
    }
    
    
    return [[UITableViewCell alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdsWebViewViewController *webview = [[AdsWebViewViewController alloc]initWithNibName:@"AdsWebViewViewController" bundle:nil];
    webview.urlString = @"https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&rsv_idx=1&tn=baidu&wd=%E9%A2%9C%E8%89%B2&oq=podfile.lock&rsv_pq=d4e26e5e00017958&rsv_t=dd1bkgpFm6Zi3rX473AXC%2FBFcQJJOiOHhX1R63Zp4Arqw%2BPiJ09kKy0lcSk&rqlang=cn&rsv_enter=1&inputT=856&rsv_sug3=6&rsv_sug1=5&rsv_sug7=100&bs=podfile.lock";
    [self.navigationController pushViewController:webview animated:YES];
    
}
#pragma mark - <************************** MYBannerScrollView 代理 **************************>
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    DLog(@"%lf",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y>150){
        [self.navigationBar setTitle:@"详情页" leftImage:kGoBackImageString rightText:nil];
        
    }else{
       [self.navigationBar setTitle:@" " leftImage:kGoBackImageString rightText:nil];
    }
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 150;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navigationBar.backgroundColor = RGBColor(116, 208, 198, alpha);
    [self.tableHeadView scrollViewDidScroll:scrollView];
}

// !!!: 滚动视图的代理事件
-(void)bannerScrollView:(MYBannerScrollView *)bannerScrollView didClickScrollView:(NSInteger)pageIndex{
    [PhotoBrowser showURLImages:bannerScrollView.imagePaths placeholderImage:[UIImage imageNamed:@"zhanweifu"] selectedIndex:pageIndex];
}

//// !!!: 标题视图的代理事件
//-(void)classInfoTableViewCell_TitleClickEvent:(NSInteger)index data:(ClassInfoModel *)model{
//    DLog(@"点击了:%@",model.key);
//    
//}

#pragma mark - <************************** 点击事件 **************************>



#pragma mark - <************************** 其他方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
