//
//  ArrowMenuView.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/29.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrowMenuView : UIView

@property (strong, nonatomic) NSMutableArray *titles;

- (instancetype)initWithFrame:(CGRect)frame withSelectionBlock:(void(^)(NSInteger index))block;
- (void)reloadData;//刷新titles
@end
