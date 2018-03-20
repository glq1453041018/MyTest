//
//  AdsWebViewViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsWebViewViewController.h"
#import <WebKit/WebKit.h>
@interface AdsWebViewViewController ()<WKNavigationDelegate>
{
    float weHeight;
    BOOL isfinished;
}
@property(strong,nonatomic)WKWebView *wkWebView;
@end

@implementation AdsWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.loadingView startAnimating];
}

#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
//        DLog(@"%lf,%lf",self.view.viewWidth,self.view.viewHeight);
    self.view.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT);
//        DLog(@"%lf,%lf",self.view.viewWidth,self.view.viewHeight);
//    [self.navigationBar setTitle:@"详情" leftBtnImage:@"zhiboLeft" rightBtnImage:@""];
//    self.isNeedGoBack = YES;
// [self.loadingView startAnimating];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:self.wkWebView];
    DLog(@"%lf,%lf",self.view.viewWidth,self.view.viewHeight);
//    self.loadingView.center = CGPointMake(100, 100);
    [self.loadingView cwn_reMakeConstraints:^(UIView *maker) {
        maker.centerXtoSuper(0).centerYtoSuper(0).width(maker.viewWidth).height(maker.viewHeight);
    }];

}

#pragma mark - <*********************** navigationViewLeftDelegate **********************>
-(void)navigationViewLeftDlegate
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <*********************** 初始化控件/数据 **********************>
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        //        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 100, MAIN_WIDTH, MAIN_HEIGHT-kNavigationbarHeight-100)];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT)];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.scrollEnabled = NO;
    }
    return _wkWebView;
}

#pragma mark - <************************** 获取数据 **************************>

#pragma mark - <************************** 代理方法 **************************>


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
    //    NSLog(@"加载失败");
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate;
{
    [self.wkWebView setNeedsLayout];
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//
//    //    DLog(@"%@",request.URL);
//    return YES;
//}
#pragma mark - <************************** 监听事件 **************************>
//// !!!: 清除直播网页缓存
- (void)deleteWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        WKWebsiteDataTypeLocalStorage,
                                                        WKWebsiteDataTypeCookies,
                                                        WKWebsiteDataTypeSessionStorage,
                                                        WKWebsiteDataTypeIndexedDBDatabases,
                                                        WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.wkWebView.scrollView && [keyPath isEqual:@"contentSize"]) {
        // we are here because the contentSize of the WebView's scrollview changed.

        weHeight = self.wkWebView.scrollView.contentSize.height;
        CGRect frame = self.wkWebView.frame;
        frame.size.height = weHeight;
        self.wkWebView.frame = frame;
        DLog(@"webview ====== %lf",weHeight);

    }
}

#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
    //    [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    
    [self deleteWebCache];
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
