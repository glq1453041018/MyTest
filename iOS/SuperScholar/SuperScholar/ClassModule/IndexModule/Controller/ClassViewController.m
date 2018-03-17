//
//  ClassViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ClassViewController.h"
#import "ClassSapceViewController.h"
#import "ClassInfoViewController.h"

#import "ClassViewCollectionViewCell.h"

#import "ClassViewManager.h"

@interface ClassViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong ,nonatomic) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;


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
    [ClassViewManager requestDataResponse:^(NSArray *resArray, id error) {
        self.data = resArray.mutableCopy;
        [self.collectionView reloadData];
    }];
}


#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationBar setTitle:@"班级列表" leftImage:nil rightText:nil];
    
    self.constraint.constant = self.navigationBar.bottom;
    self.constraintBottom.constant = kTabBarHeight;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClassViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ClassViewCollectionViewCell"];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
    
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(NSMutableArray *)data{
    if (_data==nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - <************************** 代理方法 **************************>

// !!!: UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassViewCollectionViewCell" forIndexPath:indexPath];
    [cell.detailBtn addTarget:self action:@selector(detailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell loadData:self.data index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassViewModel *cvm = self.data[indexPath.row];
    ClassSapceViewController *ctrl = [ClassSapceViewController new];
    ctrl.title = cvm.title;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-30)/2.0, AdaptedWidthValue(100));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 5, 10);
}
//设置单元格间的横向间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置纵向的行间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return YES;
}
//当移动结束的时候会调用这个方法。
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    ClassViewModel *cvm = self.data[sourceIndexPath.row];
    [self.data removeObjectAtIndex:sourceIndexPath.row];
    [self.data insertObject:cvm atIndex:destinationIndexPath.row];
}




#pragma mark - <************************** 点击事件 **************************>
// !!!: 进入班级列表
-(void)detailBtnAction:(UIButton*)btn{
    ClassInfoViewController *ctrl = [ClassInfoViewController new];
    ctrl.style = ClassInfoStyle;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

// !!!: 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            if (!indexPath) {
                break;
            }
            BOOL canMove = [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            if (!canMove) {
                break;
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
    
}


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
