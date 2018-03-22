//
//  AdsWebViewViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsWebViewViewController.h"
#import <WebKit/WebKit.h>
@interface AdsWebViewViewController ()<WKNavigationDelegate,UIScrollViewDelegate>
{
    float weHeight;
    BOOL isfinished;
}
@property(strong,nonatomic)WKWebView *wkWebView;
@property (nonatomic, assign) BOOL canScroll;
@end

@implementation AdsWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //增加观测者,播放状态切换时处理
//    [self.wkWebView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:@"DJWebKitContext"];
    // 初始化视图

    [self initUI];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];

//    self.isNeedGoBack = YES;

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:self.wkWebView];
    [self.navigationBar setTitle:nil leftImage:kGoBackImageString rightText:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
}

#pragma mark - <*********************** navigationViewLeftDelegate **********************>

-(void)navigationViewLeftClickEvent{
 [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - <*********************** 初始化控件/数据 **********************>
-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        //        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 100, MAIN_WIDTH, MAIN_HEIGHT-kNavigationbarHeight-100)];
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT)];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.delegate = self;
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
//        _wkWebView.scrollView.scrollEnabled = NO;
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
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if (object == self.wkWebView && [keyPath isEqual:@"scrollView.contentSize"]) {
//        // we are here because the contentSize of the WebView's scrollview changed.
//
//        weHeight = self.wkWebView.scrollView.contentSize.height;
//        CGRect frame = self.wkWebView.frame;
//        frame.size.height = weHeight;
//        self.wkWebView.frame = frame;
//        DLog(@"webview ====== %lf,ro ===== %lf",weHeight,self.wkWebView.scrollView.contentOffset.y);
//
//    }
//}

#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
//    [self.wkWebView removeObserver:self forKeyPath:@"scrollView.contentSize" context:@"DJWebKitContext"];
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
