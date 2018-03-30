//
//  ActivityViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityViewController.h"
#import "MYSegmentController.h"
#import "ActivitySubViewController.h"
#import "SpeechViewController.h"
#import "LLListPickView.h"

@interface ActivityViewController ()<LLListPickViewDelegate>
@property (strong, nonatomic) MYSegmentController *segmentController;
@property (assign, nonatomic) BOOL viewDidLayout;

@property (strong ,nonatomic) LLListPickView *pickView;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化视图
    [self initUI];
    
    // 获取数据
    [self getDataFormServer];
    
}

- (void)viewDidLayoutSubviews{
    if(self.viewDidLayout == NO){
        self.viewDidLayout = YES;
        [self configSegmentController];
    }
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    [self.navigationBar setTitle:@"活动列表" leftImage:nil rightImage:@"camera"];
    [self.navigationBar.rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
}

- (void)configSegmentController{
    NSMutableArray *vc_array = [NSMutableArray array];
    ActivitySubViewController *show = [ActivitySubViewController new];
    show.listType = ActivityListTypeActivityShow;
    show.title = @"精彩演出";
    show.hidesBottomBarWhenPushed = YES;
    ActivitySubViewController *activityPre = [ActivitySubViewController new];
    activityPre.listType = ActivityListTypeActivityPre;
    activityPre.title = @"活动预告";
    activityPre.hidesBottomBarWhenPushed = YES;
    ActivitySubViewController *article = [ActivitySubViewController new];
    article.listType = ActivityListTypeGoodArticle;
    article.title = @"优秀文章";
    article.hidesBottomBarWhenPushed = YES;
    [vc_array addObject:show];
    [vc_array addObject:activityPre];
    [vc_array addObject:article];
    
    NSArray *titles = @[@"精彩演出", @"活动预告", @"优秀文章"];
    
    self.segmentController = [MYSegmentController segementControllerWithFrame:CGRectMake(0, kNavigationbarHeight, IEW_WIDTH, IEW_HEGHT-kNavigationbarHeight) titles:titles withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor groupTableViewBackgroundColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:KColorTheme withArticleY:38];
    
    [self.segmentController.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
        [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }];
    
    [self.segmentController setReturnString:@"0"];
    [self.segmentController setSegementTintColor:KColorTheme];
    
    [self.segmentController setSegementViewControllers:vc_array];
    self.segmentController.style = GLQSegementStyleDefault;
    
    
    [self.segmentController selectedAtIndex:^(NSInteger index) {
        
    }];
    
//    if(self.defaultType == MessageRemindListTypeCollection)
//        [self.segmentController setSelectedItemAtIndex:1];
//    else if(self.defaultType == MessageRemindListTypeHistory)
//        [self.segmentController setSelectedItemAtIndex:2];
//    self.segmentController.containerView.bounces = NO;
    [self addChildViewController:self.segmentController];
    [self.view addSubview:self.segmentController.view];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(LLListPickView *)pickView{
    if (_pickView==nil) {
        _pickView = [LLListPickView new];
        _pickView.delegate = self;
    }
    return _pickView;
}

#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationViewRightClickEvent{
    [self.pickView showItems:@[@"拍照",@"录像",@"去相册选择"]];
}

#pragma mark LLListPickViewDelegate
// !!!: LLListPickView代理事件
-(void)lllistPickViewItemSelected:(NSInteger)index{
    SpeechViewController *ctrl = [SpeechViewController new];
    [self presentViewController:ctrl animated:NO completion:nil];
    [ctrl lllistPickViewItemSelected:index];
}
#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}


@end
