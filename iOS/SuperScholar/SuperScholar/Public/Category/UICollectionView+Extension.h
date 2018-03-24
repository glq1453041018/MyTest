//
//  UICollectionView+Extension.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (Extension)

-(void)showEmptyViewWithImage:(NSString*)image tip:(NSString*)tip;

-(void)showEmptyViewWithImage:(NSString*)image tip:(NSString*)tip btnTitle:(NSString*)title action:(SEL)action target:(id)target;

-(void)hideEmptyView;

@end
