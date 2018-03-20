//
//  MyWebView.h
//  MyWebView
//
//  Created by LOLITA on 2017/7/18.
//  Copyright © 2017年 LOLITA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WeakScriptMessageDelegate.h"

@protocol MyWebViewDelegate;

@interface MyWebView : UIView

@property (nonatomic,weak) id <MyWebViewDelegate> delegate;

@property(strong,nonatomic)WKWebView *webView;

@property (assign ,nonatomic) BOOL needLoading;

/**
 加载网页
 */
-(void)loadUrlString:(NSString *)urlString;


@end



@protocol MyWebViewDelegate <NSObject>

@optional

/**
 开始加载
 */
- (void)didStartWebView:(MyWebView *)webView;
/**
 完成加载
 */
- (void)didFinishWebView:(MyWebView *)webView;
/**
 加载失败
 */
- (void)didFailWebView:(MyWebView *)webView;

/**
 获取到标题
 */
- (void)didGetTitle:(NSString *)title;


@end

