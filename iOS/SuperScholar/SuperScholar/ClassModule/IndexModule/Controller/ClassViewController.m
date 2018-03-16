//
//  ClassViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassSapceViewController.h"


@interface ClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation ClassViewController

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
    
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.navigationBar setTitle:nil leftImage:nil rightText:@"动态"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
}


#pragma mark - <*********************** 初始化控件/数据 **********************>




#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewRightClickEvent{
    ClassSapceViewController *ctrl = [ClassSapceViewController new];
    ctrl.title = @"AI学院";
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


// !!!: UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.backgroundColor = KColorTheme;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

// !!!: LxGridViewDataSource
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//}
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//}




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
