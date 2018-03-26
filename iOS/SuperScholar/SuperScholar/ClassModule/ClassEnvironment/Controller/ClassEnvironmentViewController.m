//
//  ClassEnvironmentViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassEnvironmentViewController.h"
// !!!: 视图类
#import "CustomCollectionViewCell.h"
#import "PhotoBrowser.h"
// !!!: 数据类
#import "ClassEnvironmentManager.h"
#import "CutomCollectionViewLayout.h"

@interface ClassEnvironmentViewController ()<CutomCollectionViewLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet CutomCollectionViewLayout *layout;
@property (copy ,nonatomic) NSArray *imageArray;

@end

@implementation ClassEnvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化视图
    [self initUI];
    // 获取数据
    [self getDataFormServer];
}



#pragma mark - <************************** 获取数据 **************************>
// !!!: 获取数据
-(void)getDataFormServer{
    [ClassEnvironmentManager requestDataResponse:^(NSArray *resArray, id error) {
        self.imageArray = resArray;
        [self.collectionView reloadData];
    }];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 导航栏
    [self.navigationBar setTitle:self.title.length?self.title:@"环境" leftImage:kGoBackImageString rightImage:@""];
    self.isNeedGoBack = YES;
    
    self.layout.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CustomCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>



#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCollectionViewCell" forIndexPath:indexPath];
    ClassEnvironmentModel *cem = self.imageArray[indexPath.item];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:cem.picUrl] placeholderImage:kPlaceholderImage];
    cell.imageview.frame = cell.bounds;
    return cell;
}
-(CGSize)itemSizeForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    ClassEnvironmentModel *cem = self.imageArray[indexPath.item];
    CGFloat width = self.view.frame.size.width;
    CGFloat realItemWidth = (width-10*2-10)/2;
    return CGSizeMake(realItemWidth,cem.size.height/cem.size.width*realItemWidth);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray* images = [NSMutableArray array];
    for (ClassEnvironmentModel *model in self.imageArray) {
        [images addObject:model.picUrl];
    }
    [PhotoBrowser showURLImages:images placeholderImage:kPlaceholderImage selectedIndex:indexPath.row selectedView:nil];
}


#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>




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
