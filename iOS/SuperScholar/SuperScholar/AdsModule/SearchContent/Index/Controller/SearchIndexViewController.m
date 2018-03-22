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

#import "UIImage+ImageEffects.h"
@interface SearchIndexViewController ()<UISearchBarDelegate,UITextFieldDelegate>
{
    MYSegmentController *segmentController;
}
@property (nonatomic,strong) ZhaoShengViewController *zhaoshengVC;
@property (nonatomic,strong) ZhaoShengViewController *ActivityVC;
@property (nonatomic,strong) SchoolViewController *schoolVC;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *VCArray;
@property (nonatomic,strong) NSMutableArray *typeArray;
@end

@implementation SearchIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT);
  
        [self creatSearchBar];
//    [self.navigationBar setTitle:@"搜索" leftImage:@"public_left" rightText:@""];
    [self.typeArray addObject:@"招生启示"];
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
-(void)creatSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 0, IEW_WIDTH-30, 44)];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    

    // 修改搜索框背景图片为自定义的灰色
//    ColorWithHex(0xE3DFDA)
//    UIColor *ll = [[UIColor alloc]initWithCGColor:ColorWithHex(0xE3DFDA)].CGColor];
//    UIColor *backgroundImageColor = [UIColor colorWithCGColor:ColorWithHex(0xE3DFDA)].CGColor;
    UIImage* clearImg = [UIImage imageWithColor:ColorWithHex(0xffffff) size:CGSizeMake(IEW_WIDTH-30, 44)];
    [self.searchBar setBackgroundImage:clearImg];
    // 修改搜索框光标颜色
//    self.tintColor = [UIColor P2Color];
    // 修改搜索框的搜索图标
//    [self.searchBar setImage:[UIImage imageNamed:@"searchIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    for (UIView *view in self.searchBar.subviews.lastObject.subviews) {
        if([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            UITextField *textField = (UITextField *)view;
//            textField.returnKeyType = UIReturnKeySearch;
            //添加话筒按钮
//            [self.searchBar addVoiceButton:textField];
             [textField setFrame:CGRectMake(0, textField.frame.origin.y, self.searchBar.frame.size.width-60, textField.frame.size.height)];
            //设置输入框的背景颜色
            textField.clipsToBounds = YES;
            textField.backgroundColor = ColorWithHex(0xededed);
            //设置输入框边框的圆角以及颜色
            textField.layer.cornerRadius = 3.0f;
            textField.layer.borderColor = ColorWithHex(0xededed).CGColor;
            textField.layer.borderWidth = 1;
            //设置输入字体颜色
            textField.textColor = FontSize_colorgray;
            //设置默认文字颜色
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" 请输入关键字" attributes:@{NSForegroundColorAttributeName:ColorWithHex(0x666666)}];
        }
        if ([view isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancel = (UIButton *)view;
            [cancel setFrame:CGRectMake(self.searchBar.frame.size.width-50, cancel.frame.origin.y, 50, cancel.frame.size.height)];
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
    }
    
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    [self.navigationBar setCenterView:self.searchBar leftView:nil rightView:nil];
    self.navigationBar.backgroundColor = [UIColor clearColor];
}
-(void)viewDidDisappear:(BOOL)animated{
    //    [self.navigationController popViewControllerAnimated:YES];
}
// !!!: 返回代理

#pragma mark - <************************** UIsearchBar代理 **************************>
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    DLog(@"搜索中。。。。。。。");
    [searchBar resignFirstResponder];
}


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
