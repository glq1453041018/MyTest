//
//  ClassCommentSectionView.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/19.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassCommentSectionView.h"

@interface ClassCommentSectionView()

@property (strong, nonatomic) UIView *rowLabel;
@property (nonatomic,weak) id <ClassCommentSectionViewDelegate> delegate;
@property (copy ,nonatomic) NSArray *types;
@property (strong ,nonatomic) NSMutableArray *subViews;
@end


@implementation ClassCommentSectionView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self adjustFrame];
}

-(NSMutableArray *)subViews{
    if (_subViews==nil) {
        _subViews = [NSMutableArray array];
    }
    return _subViews;
}

-(void)loadData:(NSArray *)types withDelegate:(id)delegate{
    self.types = types;
    
    if (delegate) {
        self.delegate = delegate;
    }
    
    for (id view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = view;
            [btn removeFromSuperview];
            btn = nil;
        }
    }
    
    CGFloat space = 10;
    CGFloat origin_x = 10;
    CGFloat origin_y = 10;
    
    UIButton *lastBtn = nil;
    for (int i=0; i<types.count; i++) {
        NSString *string = types[i];
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setTitle:string forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            [self changeToSelectedState:btn];
        }else{
            [self changeToNormalState:btn];
        }

        CGFloat width = [self getWidthString:string];
        CGFloat estimateWidth = width + space + origin_x;
        if (estimateWidth > kScreenWidth-space*2) {
            origin_x = space;
            origin_y = origin_y + 30 + space;
            btn.frame = CGRectMake(origin_x, origin_y, width, 30);
        }
        else{
            btn.frame = CGRectMake(origin_x, origin_y, width, 30);
            origin_x = estimateWidth;
        }
        
        btn.layer.cornerRadius = btn.viewHeight/2.0;
        lastBtn = btn;
        [self addSubview:btn];
        [self.subViews addObject:btn];
    }
    
    self.viewHeight = lastBtn.bottom + space;
    self.rowLabel.bottom = self.viewHeight - 1;
    self.heightConstraint.constant = self.viewHeight;
}

-(UIView *)rowLabel{
    if (_rowLabel==nil) {
        _rowLabel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _rowLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_rowLabel];
    }
    return _rowLabel;
}

-(void)btnAction:(UIButton*)btn{
    DLog(@"选择了%@",self.types[btn.tag]);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(classCommentSectionViewSelectedIndex:content:)]) {
        [self.delegate classCommentSectionViewSelectedIndex:btn.tag content:self.types[btn.tag]];
    }
    for (UIButton *btn in self.subViews) {
        [self changeToNormalState:btn];
    }
    [self changeToSelectedState:btn];
}


-(void)changeToNormalState:(UIButton*)btn{
    btn.backgroundColor = [kErrorRedColor colorWithAlphaComponent:0.4];
}
-(void)changeToSelectedState:(UIButton*)btn{
    btn.backgroundColor = kErrorRedColor;
}


-(CGFloat)getWidthString:(NSString*)string{
    if (string.length==0) {
        return 0;
    }
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    return size.width + AdaptedWidthValue(30);
}


@end
