//
//  MYSearchView.m
//  GuDaShi
//
//  Created by ios 3 on 2017/1/23.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYSearchView.h"
#import "UIView+CWNView.h"

@implementation MYSearchView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.searchField];
        [self.searchField cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(4).rightToSuper(4).centerYtoSuper(0).heights(28);
        }];
        
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.searchField];
        [self.searchField cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(4).rightToSuper(4).centerYtoSuper(0).heights(28);
        }];
        
        self.layer.cornerRadius = CGRectGetHeight(frame) / 2;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder{
    if(![placeHolder length])
        placeHolder = @"";
    
    if(self = [self initWithFrame:frame]){
        [self.searchField setPlaceholder:placeHolder];
    }
    return self;
}

- (UITextField *)searchField{
    if(!_searchField){
        _searchField = [[UITextField alloc] init];
        _searchField.returnKeyType = UIReturnKeySearch;
    
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 12, 12)];
        image.image = [[UIImage imageNamed:@"beiJing"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        image.tintColor = [UIColor lightGrayColor];
        [leftView addSubview:image];
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        
        _searchField.font = [UIFont systemFontOfSize:15];
        [_searchField setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _searchField;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
