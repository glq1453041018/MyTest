//
//  ShareManager.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ShareManager.h"
#import "MYImageButton.h"
#import "OpenShareHeader.h"

static const CGFloat kShareViewHeight = 218;

@interface ShareManager ()
@property (assign, nonatomic) BOOL isOnShow;
@property (strong, nonatomic) UIControl *backgoundView;
@property (strong, nonatomic) UIView *backWhiteView;

@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) void (^completion)(OSMessage *, NSError *);
@end
@implementation ShareManager
+ (void)applicationDidFinishLaunching{
    //全局注册appId，别忘了#import "OpenShareHeader.h"
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f" miniAppId:@"gh_d43f693ca31f"];
    [OpenShare connectRenrenWithAppId:@"228525" AndAppKey:@"1dd8cba4215d4d4ab96a49d3058c1d7f"];
}
+ (BOOL)applicationOpenURL:(NSURL *)url{
    if([OpenShare handleOpenURL:url]){
        return YES;
    }
    return NO;
}
+ (void)shareToPlatform:(SharePlatform)plateform title:(NSString *)title body:(NSString *)body  image:(UIImage *)image link:(NSString *)link withCompletion:(void (^)(OSMessage *message, NSError *error))completion{
    OSMessage *msg=[[OSMessage alloc] init];
    
    msg.title=title ? title : @"";
    if ([title length] && ![link length] && !image && ![body length]){
    }else{
        msg.title=title ? title : @"";
        msg.desc = body ? body : @"";
        msg.link = link ? link : @"";
        msg.image = image ? image : kPlaceholderHeadImage;
        msg.multimediaType = OSMultimediaTypeNews;
        msg.thumbnail = msg.image;
    }
    
    switch (plateform) {
        case SharePlatformQQ:{
            [OpenShare shareToQQFriends:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformQZone:{
            [OpenShare shareToQQZone:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformWeChat:{
            [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        case SharePlatformWeChatTimeline:{
            [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
                if(completion)
                    completion(message, nil);
            } Fail:^(OSMessage *message, NSError *error) {
                if(completion)
                    completion(message, error);
            }];
        }
            break;
        default:
            break;
    }
}

+ (void)showShareViewWithTitle:(NSString *)title body:(NSString *)body image:(UIImage *)image link:(NSString *)link withCompletion:(void (^)(OSMessage *, NSError *))completion{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    ShareManager *manager = objc_getAssociatedObject(window, @selector(showShareViewWithTitle:body:image:link:withCompletion:));
    if(!manager){
        manager = [ShareManager new];
        
        //黑色背景
        manager.backgoundView = [[UIControl alloc] init];
        manager.backgoundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [manager.backgoundView addTarget:manager action:@selector(onClickBackView) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:manager.backgoundView];
        [manager.backgoundView cwn_makeConstraints:^(UIView *maker) {
            maker.edgeInsetsToSuper(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //白色背景
        manager.backWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(window.frame), IEW_WIDTH, kShareViewHeight)];
        manager.backWhiteView.backgroundColor = [UIColor whiteColor];
        [window addSubview:manager.backWhiteView];
        [manager.backgoundView addSubview:manager.backWhiteView];
        
        //布局按钮
        NSArray *images = @[@"my_qq", @"my_kj", @"my_wx", @"my_wxpyq"];
        NSArray *titles = @[@"QQ", @"QQ空间", @"微信", @"朋友圈"];
        for (int i = 0; i < 4; i ++) {
            CGFloat width = 60;
            CGFloat height = 60 + 10;
            CGFloat row = i / 4;
            CGFloat col = i % 4;
            CGFloat colspace = (IEW_WIDTH - width * 4) / 5;
            CGFloat linespace = (IEW_WIDTH - height * 4) / 5;
            
            MYImageButton *btn = [[MYImageButton alloc] initWithFrame:CGRectMake(colspace + col * (colspace + width), linespace + row * (linespace + height), width, height)];
            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            btn.tag = i;
            [btn addTarget:manager action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.imageBounds = CGRectMake(width / 2 - (width - 15) / 2, 10, width - 15, width - 15);
            btn.titleBounds = CGRectMake(0, CGRectGetMaxY(btn.imageBounds) + 5, width, 15);
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:FontSize_colordarkgray forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:FontSize_12]];
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [manager.backWhiteView addSubview:btn];
        }
        
        //取消按钮
        UIButton *cancel = [[UIButton alloc] init];
        [cancel setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel.titleLabel setFont:[UIFont systemFontOfSize:FontSize_16]];
        [cancel addTarget:manager action:@selector(onClickBackView) forControlEvents:UIControlEventTouchUpInside];
        [manager.backWhiteView addSubview:cancel];
        [cancel cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).rightToSuper(0).bottomToSuper(0).height(44);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = SeparatorLineColor;
        [manager.backWhiteView addSubview:line];
        [line cwn_makeConstraints:^(UIView *maker) {
            maker.leftToLeft(cancel, 1, 0).rightToRight(cancel, 1, 0).bottomTo(cancel, 1, 0).height(0.5);
        }];

        
        objc_setAssociatedObject(window, @selector(showShareViewWithTitle:body:image:link:withCompletion:), manager, OBJC_ASSOCIATION_RETAIN);
    }
    
    if(manager.isOnShow == YES)
        return;
    manager.isOnShow = YES;
    
    manager.image = image;
    manager.title = title;
    manager.link = link;
    manager.body = body;
    manager.completion = completion;

    manager.backgoundView.alpha = 0;
    [UIView animateWithDuration:0.11 animations:^{
        manager.backgoundView.alpha = 1;
    } completion:nil];
    
    [manager.backWhiteView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[MYImageButton class]]){
            obj.viewOrigin = CGPointMake(obj.viewOrigin.x, obj.viewOrigin.y + obj.superview.viewHeight);
            [UIView animateWithDuration:0.66 delay:0.1 + idx * 0.08 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                obj.viewOrigin = CGPointMake(obj.viewOrigin.x, obj.viewOrigin.y - obj.superview.viewHeight);
            } completion:nil];
        }
    }];
    
    [UIView animateWithDuration:0.33 animations:^{
        manager.backWhiteView.viewOrigin = CGPointMake(0, CGRectGetMaxY(window.frame) - kShareViewHeight);
    } completion:nil];
}


#pragma mark - <*********************** 事件处理 ************************>
- (void)onClickBackView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    ShareManager *manager = objc_getAssociatedObject(window, @selector(showShareViewWithTitle:body:image:link:withCompletion:));
    if(!manager || manager.isOnShow == NO)
        return;
    
    [self hideShareView];
}

- (void)onClickBtn:(UIButton *)btn{
    [[self class] shareToPlatform:btn.tag title:self.title body:self.body image:self.image link:self.link withCompletion:self.completion];
}

- (void)hideShareView{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    ShareManager *manager = objc_getAssociatedObject(window, @selector(showShareViewWithTitle:body:image:link:withCompletion:));
    if(!manager)
        return;
   
    [UIView animateWithDuration:0.22 animations:^{
        manager.backWhiteView.viewOrigin = CGPointMake(0, CGRectGetMaxY(window.frame));
        manager.backgoundView.alpha = 0;
    } completion:^(BOOL finished) {
        manager.isOnShow = NO;
    }];
}
@end
