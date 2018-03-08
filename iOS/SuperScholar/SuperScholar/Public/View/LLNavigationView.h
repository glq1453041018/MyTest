//
//  LLNavigationView.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLNavigationViewDelegate <NSObject>
@optional
-(void)navigationViewLeftClickEvent;
-(void)navigationViewRightClickEvent;
@end

@interface LLNavigationView : UIView

@property (strong ,nonatomic) UIButton *letfBtn;
@property (strong ,nonatomic) UIButton *rightBtn;
@property (strong ,nonatomic) UILabel *titleLabel;

@property (nonatomic,weak) id <LLNavigationViewDelegate> delegate;

-(void)setTitle:(NSString*)title leftImage:(NSString*)leftImg rightImage:(NSString *)rightImg;



@end
