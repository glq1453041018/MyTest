//
//  ActivityViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ActivityViewController.h"
#import "MYSegmentController.h"
#import "MessageRemindViewController.h"

@interface ActivityViewController ()
@property (strong, nonatomic) MYSegmentController *segmentController;
@property (assign, nonatomic) BOOL viewDidLayout;
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
    [self.navigationBar setTitle:@"活动列表" leftImage:nil rightImage:nil];
}

- (void)configSegmentController{
    NSMutableArray *vc_array = [NSMutableArray array];
    MessageRemindViewController *comment = [MessageRemindViewController new];
    comment.title = @"精彩演出";
    comment.listType = MessageRemindListTypeComment;
    MessageRemindViewController *collection = [MessageRemindViewController new];
    collection.title = @"活动预告";
    collection.listType = MessageRemindListTypeCollection;
    MessageRemindViewController *history = [MessageRemindViewController new];
    history.title = @"优秀文章";
    history.listType = MessageRemindListTypeHistory;
    [vc_array addObject:comment];
    [vc_array addObject:collection];
    [vc_array addObject:history];
    
    NSArray *titles = @[@"精彩演出", @"活动预告", @"优秀文章"];
    
    self.segmentController = [MYSegmentController segementControllerWithFrame:CGRectMake(0, kNavigationbarHeight, IEW_WIDTH, IEW_HEGHT-kNavigationbarHeight) titles:titles withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor groupTableViewBackgroundColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:KColorTheme withArticleY:38];
    
    [self.segmentController.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
        [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }];
    
    [self.segmentController setReturnString:@"1"];
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


#pragma mark - <************************** 代理方法 **************************>

#pragma mark NavigationBarDelegate
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <************************** 点击事件 **************************>


#pragma mark - <************************** 私有方法 **************************>




#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}


@end
