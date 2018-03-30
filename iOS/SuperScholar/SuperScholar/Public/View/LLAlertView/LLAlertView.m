//
//  LLAlertView.m
//  GuDaShi
//
//  Created by LOLITA on 2017/11/30.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "LLAlertView.h"

@interface LLAlertView ()
//背景视图
@property (strong ,nonatomic) CABasicAnimation *showHideAnimation;
@property (strong ,nonatomic) CABasicAnimation *showHideAnimation_contentView;
@property (strong ,nonatomic) UIButton *closeBtn;   // 关闭按钮

@property (assign ,nonatomic) BOOL isShowing;

@property (strong ,nonatomic) id object;
@end

@implementation LLAlertView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
    }
    return self;
}


#pragma mark - <************************** 初始化部分 **************************>
-(UIView *)backgroundView{
    if (_backgroundView==nil) {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
    }
    return _backgroundView;
}


-(void)setContentView:(UIView *)contentView{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    _contentView = contentView;
    _contentView.center = self.center;
    [self addSubview:_contentView];
    
    self.closeBtn.centerY = _contentView.bottom + (self.viewHeight - _contentView.bottom)/2.0;
}

-(CAAnimation *)animation{
    if (_animation==nil) {
        CAKeyframeAnimation * animation;
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.25;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        _animation = animation;
    }
    return _animation;
}


-(CABasicAnimation *)showHideAnimation{
    if (_showHideAnimation==nil) {
        _showHideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _showHideAnimation.duration = 0.25;
        _showHideAnimation.removedOnCompletion = NO;
        _showHideAnimation.fillMode = kCAFillModeForwards;
    }
    return _showHideAnimation;
}

-(CABasicAnimation *)showHideAnimation_contentView{
    if (_showHideAnimation_contentView==nil) {
        _showHideAnimation_contentView = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _showHideAnimation_contentView.duration = 0.25;
        _showHideAnimation_contentView.removedOnCompletion = NO;
        _showHideAnimation_contentView.fillMode = kCAFillModeForwards;
    }
    return _showHideAnimation_contentView;
}


-(UIButton *)closeBtn{
    if (_closeBtn==nil) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.backgroundColor = [UIColor clearColor];
        _closeBtn.center = self.center;
        _closeBtn.hidden = YES;
        _closeBtn.layer.cornerRadius = _closeBtn.frame.size.width/2.0;
        _closeBtn.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"LLAlertView.bundle/close.png"];
        if (image) {
            [_closeBtn setImage:image forState:UIControlStateNormal];
        }
    }
    return _closeBtn;
}

-(void)setNeedCloseBtn:(BOOL)needCloseBtn{
    _needCloseBtn = needCloseBtn;
    self.closeBtn.hidden = !needCloseBtn;
    [self addSubview:self.closeBtn];
}

#pragma mark - <************************** 显示/隐藏方法 **************************>
-(void)show{
    if (self.isShow||self.isShowing) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self.transform = CGAffineTransformRotate(self.transform, M_PI/2.0);
            CGPoint rotatePoint = CGPointMake(self.frame.size.width/2.0,self.frame.size.height/2.0);
            // 暂停按钮
            self.layer.position = rotatePoint;
        }else{
            self.transform = CGAffineTransformIdentity;
        }
    }];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [self showBackground];
    [self.contentView.layer addAnimation:self.animation forKey:@"animation"];
    if (self.needCloseBtn) {
        [self.closeBtn.layer addAnimation:self.animation forKey:@"animation"];
    }
    self.userInteractionEnabled = NO;
    self.isShowing = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isShow = YES;
        self.isShowing = NO;
        self.userInteractionEnabled = YES;
    });
}

-(void)hideWithBlock:(void (^)())block{
    if (self.isShow==NO||self.isShowing) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        BOOL transformIdentity = CGAffineTransformIsIdentity(self.transform);
        if (!transformIdentity) {
            self.transform = CGAffineTransformIdentity;
        }
    }];
    [self hideBackgorund];
    self.isShowing = YES;
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
        self.isShow=NO;
        self.isShowing = NO;
        self.userInteractionEnabled = YES;
        if (block) {
            block();
        }
    });
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.touchToClose) {
        [self hideWithBlock:nil];
    }
    if (self.touchBgView) {
        if (self.isShow) {
            self.touchBgView();
            DLog(@"点击了背景视图");
        }
    }
}


#pragma mark - <************************** 私有方法 **************************>
- (void)showBackground{
    self.showHideAnimation.fromValue = @(0);
    self.showHideAnimation.toValue = @(0.5);
    [self.backgroundView.layer addAnimation:self.showHideAnimation forKey:@"opacity"];
    
    self.showHideAnimation_contentView.fromValue = @(0.8);
    self.showHideAnimation_contentView.toValue = @(1.0);
    [self.contentView.layer addAnimation:self.showHideAnimation_contentView forKey:@"opacity"];
    
}

- (void)hideBackgorund{
    self.showHideAnimation.fromValue = @(0.5);
    self.showHideAnimation.toValue = @(0);
    [self.backgroundView.layer addAnimation:self.showHideAnimation forKey:@"opacity"];
    
    self.showHideAnimation_contentView.fromValue = @(1.0);
    self.showHideAnimation_contentView.toValue = @(0);
    [self.contentView.layer addAnimation:self.showHideAnimation_contentView forKey:@"opacity"];
}





#pragma mark - <************************** 弹出系统弹窗 **************************>
+(void)showSystemAlertViewClickBlock:(LLAlertViewBlock)block message:(NSString *)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    NSMutableArray *buttonTitleArray = [NSMutableArray array];
    va_list args;
    va_start(args, buttonTitles);
    if (buttonTitles)
    {
        [buttonTitleArray addObject:buttonTitles];
        while (1)
        {
            NSString *  otherButtonTitle = va_arg(args, NSString *);
            if(otherButtonTitle == nil) {
                break;
            } else {
                [buttonTitleArray addObject:otherButtonTitle];
            }
        }
    }
    va_end(args);
    if (buttonTitleArray.count==0) {
        return;
    }
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i=0; i<buttonTitleArray.count; i++) {
        NSString *title = buttonTitleArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(i);
            }
        }];
        [alertCtrl addAction:action];
    }
    UITabBarController *tab = (UITabBarController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    UINavigationController *nav = tab.selectedViewController;
    [nav presentViewController:alertCtrl animated:YES completion:nil];
}

-(void)showSystemAlertViewClickBlock:(LLAlertViewBlock)block message:(NSString *)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    self.block = block;
    NSMutableArray *buttonTitleArray = [NSMutableArray array];
    va_list args;
    va_start(args, buttonTitles);
    if (buttonTitles)
    {
        [buttonTitleArray addObject:buttonTitles];
        while (1)
        {
            NSString *  otherButtonTitle = va_arg(args, NSString *);
            if(otherButtonTitle == nil) {
                break;
            } else {
                [buttonTitleArray addObject:otherButtonTitle];
            }
        }
    }
    va_end(args);
    if (buttonTitleArray.count==0) {
        return;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in buttonTitleArray) {
        [alertView addButtonWithTitle:title];
    }
    [alertView show];
    self.object = self; // 采用循环引用避免被系统提前释放
}
-(UIAlertView *)showSystemAlertViewClickBlock:(LLAlertViewBlock)block AlertViewTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    self.block = block;
    NSMutableArray *buttonTitleArray = [NSMutableArray array];
    va_list args;
    va_start(args, buttonTitles);
    if (buttonTitles)
    {
        [buttonTitleArray addObject:buttonTitles];
        while (1)
        {
            NSString *  otherButtonTitle = va_arg(args, NSString *);
            if(otherButtonTitle == nil) {
                break;
            } else {
                [buttonTitleArray addObject:otherButtonTitle];
            }
        }
    }
    va_end(args);
    if (buttonTitleArray.count==0) {
        return nil;
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in buttonTitleArray) {
        [alertView addButtonWithTitle:title];
    }
    [alertView show];
    self.object = self; // 采用循环引用避免被系统提前释放
    return alertView;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block(buttonIndex);
        self.object = nil;  // 断掉强引用，让系统释放该对象self
    }
}




-(void)dealloc{
    DLog(@"%@被释放了。。。",self.class);
}




@end
