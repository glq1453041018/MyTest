//
//  UICollectionView+Extension.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "UICollectionView+Extension.h"
#import "LLNoDataView.h"
#import <objc/runtime.h>
@interface UICollectionView ()
@property (strong, nonatomic) LLNoDataView *noDataView;
@end
@implementation UICollectionView (Extension)

-(void)showEmptyViewWithImage:(NSString *)image tip:(NSString *)tip{
    [self showEmptyViewWithImage:image tip:tip btnTitle:nil action:nil target:nil];
}

-(void)showEmptyViewWithImage:(NSString *)image tip:(NSString *)tip btnTitle:(NSString *)title action:(SEL)action target:(id)target{
    if([self.subviews containsObject:self.noDataView])
        return;
    [self.noDataView setImage:image tip:tip btnTitle:title];
    if (title&&action&&target) {
        [self.noDataView.tipBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:self.noDataView];
}


- (void)hideEmptyView{
    [self.noDataView removeFromSuperview];
}

- (LLNoDataView *)noDataView{
    LLNoDataView *view = objc_getAssociatedObject(self, _cmd);
    if(view == nil){
        view = [[LLNoDataView alloc] initWithFrame:self.bounds];
        objc_setAssociatedObject(self, _cmd, view, OBJC_ASSOCIATION_RETAIN);
    }
    return view;
}

@end
