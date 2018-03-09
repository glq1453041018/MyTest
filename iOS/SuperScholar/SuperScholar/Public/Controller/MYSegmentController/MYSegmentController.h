//
//  MYSegmentController.h
//  GuDaShi
//
//  Created by guolq on 2017/12/4.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GLQSegementStyle) {
    GLQSegementStyleDefault,    /**< 指示杆和按钮的标题齐平*/
    GLQSegementStyleFlush,      /**< 指示杆和按钮宽度齐平*/
};

@interface MYSegmentController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) UIColor *segementTintColor;   /**< 选中时的字体颜色，默认黑色*/

@property (nonatomic, strong) UILabel*verticalLabelColor; /*竖杠｜*/
@property (nonatomic, strong) UIView *indicateView;     /**< 指示杆*/
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIScrollView *segementView;
@property (nonatomic, strong) UIScrollView *containerView;
@property (nonatomic, assign) GLQSegementStyle style;
@property(nonatomic,strong)NSString* returnString;
@property (nonatomic, assign) BOOL needAnimation;
@property(nonatomic,strong) UILabel *downLineLabel;
/*
 Verticalcolor< 按钮中间竖杠颜色
 VerticalHeght< 按钮中间竖杠高度
 downLableFloat< 底部横杠高度
 downColor< 底部横杠颜色
 verticalLabelColorY< 按钮中间竖杠Y
 ArticleY< 字体下部指示杠Y
 segementViewHeght scrollview高度
 */
+ (instancetype)segementControllerWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles withArry:(NSArray *)arry withStr:(NSString *)str withVerticalLabelColor:(UIColor *)Verticalcolor withVerticalHeght:(float)VerticalHeght withVerticalLabelColorY:(float)verticalLabelColorY withSegementView:(float)segementViewHeght withSegementViewWidth:(float)SegementViewWidth withDownlable:(float)downLableFloat withDownColor:(UIColor*)downColor withArticleY:(float)ArticleY;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles withArry:(NSArray *)arry withStr:(NSString *)str withVerticalLabelColor:(UIColor *)Verticalcolor withVerticalHeght:(float)VerticalHeght withVerticalLabelColorY:(float)verticalLabelColorY withSegementView:(float)segementViewHeght withSegementViewWidth:(float)SegementViewWidth withDownlable:(float)downLableFloat withDownColor:(UIColor*)downColor withArticleY:(float)ArticleY;
- (void)setSegementViewControllers:(NSArray <UIViewController *>*)viewControllers;
/**
 返回当前被选中的item的下标
 */
- (NSInteger)selectedAtIndex;
- (void)selectedAtIndex:(void(^)(NSInteger index))indexBlock;
/**
 手动指定选中的item
 */
- (void)setSelectedItemAtIndex:(NSInteger)index;
@end
