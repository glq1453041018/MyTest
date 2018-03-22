//
//  AdressDetailViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsDetailViewController.h"
#import "AdsWebViewViewController.h"
#import "ClassInfoViewController.h"

#import "MYBannerScrollView.h"
#import "ZhaoShengTableViewCell.h"
#import "AdsDetailTableViewCell.h"

#import "PhotoBrowser.h"
#import "UIButton+Positon.h"
#import <WebKit/WebKit.h>

@interface AdsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MYBannerScrollViewDelegate,WKNavigationDelegate>
{
    float weHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *centerImage;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet MYBannerScrollView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tablefootView;
@property (weak, nonatomic) IBOutlet UIButton *contectBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
@property (weak, nonatomic) IBOutlet UIButton *SchoolBtn;
- (IBAction)SchoolClick:(UIButton *)sender;



@property(strong,nonatomic)WKWebView *wkWebView;
@property(assign,nonatomic)BOOL HaveMusic;

@property(strong,nonatomic)AdsDetailTableViewCell_footView *footView;


@end

@implementation AdsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    weHeight = IEW_HEGHT;
    self.HaveMusic = YES;
    [self.wkWebView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:@"DJWebKitContext"];
    // 初始化视图
    [self initUI];
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.wkWebView && [keyPath isEqual:@"scrollView.contentSize"]&&weHeight!=self.wkWebView.scrollView.contentSize.height) {
        // we are here because the contentSize of the WebView's scrollview changed.

         weHeight = self.wkWebView.scrollView.contentSize.height;
        CGRect frame = self.wkWebView.frame;
        frame.size.height = weHeight;
        self.wkWebView.frame = frame;
        DLog(@"webview ====== %lf,ro ===== %lf",weHeight,self.wkWebView.scrollView.contentOffset.y);
        [self.tableView reloadData];
    }
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [view addSubview:self.navigationBar.letfBtn];
    self.navigationBar.letfBtn.frame = CGRectMake(0, 0, 15, 44);
    [self.navigationBar.letfBtn setImage:[UIImage imageNamed:kGoBackImageString] forState:UIControlStateNormal];
    [self.navigationBar setCenterView:self.centerImage leftView:view rightView:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.isNeedGoBack = YES;

}

#pragma mark - <*********************** 初始化控件/数据 **********************>

-(UIImageView *)centerImage{
    if (_centerImage == nil) {
        _centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 35, 35)];
        [_centerImage sd_setImageWithURL:[NSURL URLWithString:[TESTDATA randomUrlString]] placeholderImage:[UIImage imageNamed:@""]];
        _centerImage.layer.cornerRadius = 3;
        _centerImage.clipsToBounds = YES;
        _centerImage.alpha = 0;
    }
    return _centerImage;
}


-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        //        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 100, MAIN_WIDTH, MAIN_HEIGHT-kNavigationbarHeight-100)];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT)];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        _wkWebView.userInteractionEnabled = NO;
        _wkWebView.scrollView.scrollEnabled = NO;
    }
    return _wkWebView;
}
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
    self.tableView.backgroundColor = TableBackGroundColor;
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
    
    [self.contectBtn setImagePosition:ZXImagePositionTop spacing:1];
    [self.shoucangBtn setImagePosition:ZXImagePositionTop spacing:1];
    if (self.type == ReCruitTypeSchool) {
        [self.SchoolBtn setTitle:@"了解学校" forState:UIControlStateNormal];
    }else{
         [self.SchoolBtn setTitle:@"了解班级" forState:UIControlStateNormal];
    }
    [self.view addSubview:self.tablefootView];
}
-(void)creatScrollerView{
    [self.tableHeadView adjustFrame];

    NSMutableArray *pics = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        [pics addObject:[TESTDATA randomUrlString]];
    }
    
    [self.tableHeadView loadImages:pics estimateSize:CGSizeMake(self.tableHeadView.frame.size.width , self.tableHeadView.frame.size.height)];
    self.tableHeadView.location = locationCenter;
    self.tableHeadView.failImage = kPlaceholderImage;
//    self.tableHeadView.style = MYPageControlStyleLabel;
//    self.tableHeadView.backgroundColor = [UIColor cyanColor];
    self.tableHeadView.useScaleEffect = YES;
    self.tableHeadView.needBgView = YES;
    self.tableHeadView.useVerticalParallaxEffect = YES;

 
    self.tableHeadView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeadView;
}

-(AdsDetailTableViewCell_footView *)footView{
    if (_footView==nil) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AdsDetailTableViewCell class]) owner:nil options:nil];
        for (id cellItem in cells) {
            if ([cellItem isKindOfClass:[AdsDetailTableViewCell_footView class]]) {
                _footView = cellItem;
                break;
            }
        }
    }
    return _footView;
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
    }else if (section == 1){
        return 40;
    } else{
        return 10;
    }

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
         return [[UIView alloc]init];
    }else if (section == 1){

        return self.footView;
    } else{
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
        return weHeight;
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

        if (self.type == ReCruitTypeSchool) {
            cell.titleLable.text = @"这是一篇以学校为主体的招聘信息，详情页里面的内容也应该以学校为主体";
        }else{
            cell.titleLable.text = @"这是一篇以班级为主体的招聘信息，详情页里面的内容也应该以班级为主体";
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

            [cell.contentView addSubview:self.wkWebView];
//            self.loadingView.center = cell.center;
            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/s/kmQq7UWrFqANpArdvDcIkg"]]];
        }
        return cell;
    }
    
    
    return [[UITableViewCell alloc]init];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdsWebViewViewController *webview = [[AdsWebViewViewController alloc]initWithNibName:@"AdsWebViewViewController" bundle:nil];
    webview.urlString = @"http://u4915226.viewer.maka.im/pcviewer/1WXHYXUH";
    [self presentViewController:webview animated:YES completion:^{
        
    }];
//    [self.navigationController pushViewController:webview animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    // 判断webView所在的cell是否可见，如果可见就layout
    NSArray *cells = self.tableView.visibleCells;
    for (UITableViewCell *cell in cells) {
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        if (path.section==2) {
            [self.wkWebView setNeedsLayout];
        }
        
    }
    CGRect rect = [self.tableView rectForFooterInSection:2];
//    NSLog(@"%lf %lf  %lf",scrollView.contentOffset.y,rect.origin.y,IEW_HEGHT);
    if (scrollView.contentOffset.y>rect.origin.y-IEW_HEGHT+64+44+10) {
        if (self.HaveMusic) {
            AdsWebViewViewController *webview = [[AdsWebViewViewController alloc]initWithNibName:@"AdsWebViewViewController" bundle:nil];
            webview.urlString = @"http://u4915226.viewer.maka.im/pcviewer/1WXHYXUH";
            [self presentViewController:webview animated:YES completion:^{
                
            }];
        }
    }

    
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 150;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navigationBar.backgroundColor = RGBColor(116, 208, 198, alpha);
//    self.navigationBar.backgroundColor = RGBColor(247, 247, 247, alpha);
    self.centerImage.alpha = alpha;
    [self.tableHeadView scrollViewDidScroll:scrollView];
    
}
#pragma mark - <************************** MYBannerScrollView 代理 **************************>

// !!!: 滚动视图的代理事件
-(void)bannerScrollView:(MYBannerScrollView *)bannerScrollView didClickScrollView:(NSInteger)pageIndex{
    [PhotoBrowser showURLImages:bannerScrollView.imagePaths placeholderImage:[UIImage imageNamed:@"zhanweifu"] selectedIndex:pageIndex];
}

//// !!!: 标题视图的代理事件
//-(void)classInfoTableViewCell_TitleClickEvent:(NSInteger)index data:(ClassInfoModel *)model{
//    DLog(@"点击了:%@",model.key);
//    
//}
#pragma mark - <************************** WKwebView代理 **************************>
///  页面开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.loadingView startAnimating];
    
}
///  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.loadingView stopAnimating];
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
        NSLog(@"加载失败");
}
#pragma mark - <************************** 点击事件 **************************>
- (IBAction)SchoolClick:(UIButton *)sender {
    if (self.type == ReCruitTypeSchool) {
        ClassInfoViewController *ctrl = [ClassInfoViewController new];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else{
        ClassInfoViewController *ctrl = [ClassInfoViewController new];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}


#pragma mark - <************************** 其他方法 **************************>


#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:@"scrollView.contentSize" context:@"DJWebKitContext"];
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
