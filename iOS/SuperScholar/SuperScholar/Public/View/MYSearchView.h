//
//  MYSearchView.h
//  GuDaShi
//
//  Created by ios 3 on 2017/1/23.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSearchView : UIView

@property (strong, nonatomic) UITextField *searchField;

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder;

@end
