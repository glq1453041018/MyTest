//
//  WeakScriptMessageDelegate.m
//  HuiCeLvePE
//
//  Created by 骆亮 on 2018/1/4.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import "WeakScriptMessageDelegate.h"

@implementation WeakScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
