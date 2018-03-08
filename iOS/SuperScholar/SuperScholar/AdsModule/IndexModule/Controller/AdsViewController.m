//
//  AdsViewController.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AdsViewController.h"
#import "ZhaoShengViewController.h"
#import "AdsCollectionViewCell.h"

@interface AdsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *CollectionView;

@end

@implementation AdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 初始化视图
    [self initUI];
    [self creatCollectionView];
    
    
}

#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT);
}

#pragma mark - <*********************** 初始化控件/数据 **********************>
-(void)creatCollectionView{
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //2.初始化collectionView
    self.CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, IEW_WIDTH, IEW_HEGHT) collectionViewLayout:layout];
    self.CollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.CollectionView registerNib:[UINib nibWithNibName:@"AdsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"adscell"];
    
    
    //4.设置代理
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.CollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.CollectionView];
}

#pragma mark - <************************** 获取数据 **************************>
//下拉
-(void)RefreshNewData{

}
//上拉加载
-(void)loadMoreData{
    [self GetTypeFromService];
}
// !!!: 获取头条的子类型数据
-(void)GetTypeFromService{
//    NSString *url = [NSString stringWithFormat:@"%@%@",YuMing3,ZiXunChildChannelList];
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"],@"userid",
//                         self.channelid,@"channelid",
//                         nil];
//    __weak typeof(self) weakself = self;
//    service *servi = [[service alloc]init];
//    
//    [servi requestWithURLString:url parameters:dic type:HttpRequestTyepPost success:^(id responseObject) {
//        
//        NSArray *resultArr = responseObject;
//        [weakself.typeArray addObjectsFromArray:resultArr];
//        for (int i=0; i<weakself.typeArray.count; i++) {
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 26)];
//            lable.font = [UIFont systemFontOfSize:14.0];
//            lable.text = [weakself.typeArray[i] objectForKey:@"ChannelName"];
//            CGSize size = [lable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 26)];
//            [weakself.typeArray_height addObject:@(size.width+10)];
//            [weakself.ListArray addObject:[NSMutableArray array]];
//            [weakself.PageArray addObject:@(1)];
//        }
//        [weakself.typeCollection reloadData];
//        [weakself getDataFormServer];
//        
//    } failure:^(NSError *error) {
//        if ([error isKindOfClass:[NSError class]]) {
//            NSError * err = (NSError *)error;
//            [LLAlertView showSystemAlertViewClickBlock:^(NSInteger index) {
//                if (index == 1) {
//                    [self GetTypeFromService];
//                }
//            } message:ServerError_Description(err.code) buttonTitles:@"取消",@"重试",nil];
//        }
//        
//        [weakself.loadingView stopAnimating];
//    }];
}




#pragma mark - <************************** collectionView 代理方法 **************************>

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
//    return self.typeArray.count;
    return 12;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"adscell";
    AdsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
   
//    cell.selected = indexPath.item == selectIndex;
//    float cellwidth = [self.typeArray_height[indexPath.row] floatValue];
//    cell.titleLable.frame = CGRectMake(0, 0, cellwidth, cell.contentView.frame.size.height);
//    cell.titleLable.layer.cornerRadius = 4.0;
//    cell.titleLable.clipsToBounds = YES;
//    
//    cell.titleLable.text = [self.typeArray[indexPath.row] objectForKey:@"ChannelName"];
//    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的 margin
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    //整个视图的顶端左端底端右端
//    UIEdgeInsets top = {10,15,10,15};
//    return top;
//}
//设置单元格间的横向间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//设置纵向的行间距
-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(182*MAIN_SPWPW, 271*MAIN_SPWPW);
}

#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    ZhaoShengViewController *zhaosheng = [[ZhaoShengViewController alloc]initWithNibName:@"ZhaoShengViewController" bundle:nil];
    [self.navigationController pushViewController:zhaosheng animated:YES];
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
