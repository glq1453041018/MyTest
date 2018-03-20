//
//  WeakScriptMessageDelegate.h
//  HuiCeLvePE
//
//  Created by 骆亮 on 2018/1/4.
//  Copyright © 2018年 com.chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic,weak)id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
