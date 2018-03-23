//
//  LLNoDataView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLNoDataView : UIView

@property (strong ,nonatomic) UIImageView *imageView;
@property (strong ,nonatomic) UILabel *tipLabel;
@property (strong ,nonatomic) UIButton *tipBtn;

-(void)setImage:(NSString*)image tip:(NSString*)tip btnTitle:(NSString*)title;

@end





