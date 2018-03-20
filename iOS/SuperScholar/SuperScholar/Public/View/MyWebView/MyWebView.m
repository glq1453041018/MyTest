//
//  MyWebView.m
//  MyWebView
//
//  Created by LOLITA on 2017/7/18.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import "MyWebView.h"
#import "IndicatorView.h"

@interface MyWebView()<WKNavigationDelegate,MyWebViewDelegate>

@property (strong ,nonatomic) UIProgressView *progress;
@property (strong ,nonatomic) IndicatorView *loading;


@end

@implementation MyWebView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
        [self insertSubview:self.progress aboveSubview:self.webView];
        [self.webView addSubview:self.loading];
        
        
        [self.webView cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).rightToSuper(0).topToSuper(0).bottomToSuper(0);
        }];
        
        [self.progress cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).rightToSuper(0).topToSuper(0).height(2);
        }];
        
        self.needLoading = YES;
        [self.loading cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).centerYtoSuper(0);
        }];
    }
    return self;
}

-(void)setNeedLoading:(BOOL)needLoading{
    _needLoading = needLoading;
    if (needLoading==NO) {
        self.loading.hidden = YES;
        self.progress.hidden = YES;
    }
}


-(WKWebView *)webView{
    if (_webView==nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.bounds];
        _webView.navigationDelegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.opaque = NO;
        _webView.allowsBackForwardNavigationGestures = YES;
        [_webView goBack];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _webView;
}


-(UIProgressView *)progress{
    if (_progress==nil) {
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progress.trackTintColor = [UIColor lightGrayColor];
        _progress.progressTintColor = kDarkOrangeColor;
        _progress.frame = CGRectMake(0, 0, self.bounds.size.width, 2);
    }
    return _progress;
}

-(IndicatorView *)loading{
    if (_loading==nil) {
        _loading = [[IndicatorView alloc] initWithType:IndicatorTypeBounceSpot1 tintColor:KColorTheme];
        _loading.center = CGPointMake(self.webView.bounds.size.width/2.0, self.webView.bounds.size.height/2.0);
    }
    return _loading;
}

#pragma mark - <************************** 代理 **************************>
/// 开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    DLog(@"url:%@",webView.URL.absoluteString);
    [self.loading startAnimating];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didStartWebView:)]) {
        [self.delegate didStartWebView:self];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loading stopAnimating];
    });
}
/// 获取到网页内容
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"获取到内容");
}
/// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"加载完成");
    [self.loading stopAnimating];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didFinishWebView:)]) {
        [self.delegate didFinishWebView:self];
    }
}
/// 加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"加载失败");
    [self.loading stopAnimating];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didFailWebView:)]) {
        [self.delegate didFailWebView:self];
    }
}



#pragma mark - <************************** kvo监听 **************************>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 监听标题
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(didGetTitle:)]) {
                [self.delegate didGetTitle:self.webView.title];
            }
        }
        else
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    // 监听进度
    else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            NSLog(@"%f",self.webView.estimatedProgress);
            [self.progress setProgress:self.webView.estimatedProgress animated:YES];
            self.progress.hidden = self.progress.progress==1?YES:NO;
            self.progress.progress = self.progress.progress==1?0:self.progress.progress;
            if (self.progress.progress==1) {
                [self.loading stopAnimating];
            }
        }
        else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}




#pragma mark - <************************** 私有方法 **************************>
-(void)loadUrlString:(NSString *)urlString{
    urlString = ![urlString hasPrefix:@"http"] ? [@"http://" stringByAppendingString:urlString] : urlString;
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}



#pragma mark - <************************** dealloc **************************>
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self deleteWebCache];
}


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


@end
