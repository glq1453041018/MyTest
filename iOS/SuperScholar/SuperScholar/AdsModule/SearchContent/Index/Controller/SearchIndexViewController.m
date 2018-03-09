//
//  SearchIndexViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/9.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "SearchIndexViewController.h"
#import "MYSegmentController.h"
#import "ZhaoShengViewController.h"
#import "SchoolViewController.h"
@interface SearchIndexViewController ()
{
    MYSegmentController *segmentController;
}
@property (nonatomic,strong) ZhaoShengViewController *zhaoshengVC;
@property (nonatomic,strong) ZhaoShengViewController *ActivityVC;
@property (nonatomic,strong) SchoolViewController *schoolVC;

@property (nonatomic,strong) NSMutableArray *VCArray;
@property (nonatomic,strong) NSMutableArray *typeArray;
@end

@implementation SearchIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT);

    [self.navigationBar setTitle:@"搜索" leftImage:@"public_left" rightText:@""];
    [self.typeArray addObject:@"精彩活动"];
    [self.typeArray addObject:@"活动预告"];
    [self.typeArray addObject:@"学校"];
    [self Creatsegment];
    // Do any additional setup after loading the view from its nib.
}

-(NSMutableArray *)VCArray{
    
    if (!_VCArray) {
        _VCArray = [NSMutableArray array];
    }
    return _VCArray;
}
-(NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        _typeArray = [NSMutableArray array];
    }
    return _typeArray;
}

-(void)Creatsegment{
    
    self.zhaoshengVC = [[ZhaoShengViewController alloc]initWithNibName:@"ZhaoShengViewController" bundle:nil];
    self.ActivityVC = [[ZhaoShengViewController alloc]initWithNibName:@"ZhaoShengViewController" bundle:nil];
    self.schoolVC = [[SchoolViewController alloc]initWithNibName:@"SchoolViewController" bundle:nil];
    [self.VCArray addObject:self.zhaoshengVC];
    [self.VCArray addObject:self.ActivityVC];
    [self.VCArray addObject:self.schoolVC];
    
    segmentController = [MYSegmentController segementControllerWithFrame:CGRectMake(0, kNavigationbarHeight, IEW_WIDTH, IEW_HEGHT-kNavigationbarHeight) titles:self.typeArray withArry:nil withStr:@"2" withVerticalLabelColor:[UIColor groupTableViewBackgroundColor] withVerticalHeght:12 withVerticalLabelColorY:14 withSegementView:kscrollerbarHeight withSegementViewWidth:IEW_WIDTH withDownlable:1 withDownColor:KColorTheme withArticleY:38];
    
    [segmentController.titleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitleColor:FontSize_colorgray forState:UIControlStateNormal];
        [obj.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }];
    
    [segmentController setReturnString:@"1"];
    [segmentController setSegementTintColor:KColorTheme];
    
    [segmentController setSegementViewControllers:self.VCArray];
    segmentController.style = GLQSegementStyleDefault;
    [segmentController setSegementTintColor:KColorTheme];
    //    [segmentController setSelectedItemAtIndex:self.subType];
    

    [segmentController selectedAtIndex:^(NSInteger index) {

    }];
    segmentController.containerView.bounces = NO;
    [self addChildViewController:segmentController];
    [self.view addSubview:segmentController.view];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    //    [self.navigationController popViewControllerAnimated:YES];
}
// !!!: 返回代理
-(void)navigationViewLeftClickEvent{
   [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <************************** 请求类型数据 **************************>

#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
