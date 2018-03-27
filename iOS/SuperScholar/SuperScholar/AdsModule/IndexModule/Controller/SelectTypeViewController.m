//
//  SelectTypeViewController.m
//  SuperScholar
//
//  Created by guolq on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "SelectTypeViewController.h"
#import "SelectTypeModel.h"

@interface SelectTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (copy,nonatomic) NSMutableArray *leftArray;
@property (copy,nonatomic) NSMutableArray *rightArray;
@property (assign,nonatomic) NSInteger leftIndex;
@property (assign,nonatomic) NSInteger rightselectIndex;
@end

@implementation SelectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self creatTableView];
    [self creatLeftTableView];
    [self refreshOnOutside];
    

    
//    NSArray *arr = [NSArray arrayWithObjects:@, nil];
    
}
#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //手势返回
    self.isNeedGoBack = YES;
    

}
#pragma mark --navigationViewLeftDlegate-------
-(void)navigationViewReghtDlegate
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - <*********************** 初始化控件/数据 **********************>
-(NSMutableArray *)leftArray{
    if (_leftArray == nil) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
-(void)creatTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake((IEW_WIDTH-30)/2.0, 0, (IEW_WIDTH-30)/2.0+30, IEW_HEGHT/3.0*2) style:UITableViewStylePlain];
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    self.mytableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.mytableView.backgroundColor = [UIColor whiteColor];
    self.mytableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.mytableView];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJDIYAutoFooter *footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置尾部
    self.mytableView.mj_footer = footer;
    [self.mytableView.mj_footer setHidden:YES];
    
}
-(void)creatLeftTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.LefttableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, (IEW_WIDTH-30)/2.0, IEW_HEGHT/3.0*2) style:UITableViewStylePlain];
    self.LefttableView.delegate = self;
    self.LefttableView.dataSource = self;
    self.LefttableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.LefttableView.backgroundColor = [UIColor whiteColor];;
    self.LefttableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.LefttableView];
    
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
//    MJDIYAutoFooter *footer = [MJDIYAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    
//    // 设置尾部
//    self.LefttableView.mj_footer = footer;
//    [self.LefttableView.mj_footer setHidden:YES];
    
}

#pragma mark - <************************** 获取数据 **************************>

//上拉加载
-(void)loadMoreData{
    [self getDataFormServer];
}
// !!!: 获取数据
-(void)getDataFormServer{
//    NSString *url = [NSString stringWithFormat:@"%@%@",YuMing3,searchArtivle];
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         GetInfoForKey(kUserid_UserDefaults),@"userid",
//                         [NSNumber numberWithInt:10],@"pagesize",
//                         [NSNumber numberWithInt:self.page],@"page",
//                         self.textField.text,@"keyWord",
//                         [NSNumber numberWithInteger:self.teacherid],@"teacherid",
//                         nil];
//    __weak typeof(self) weakself = self;
//    service *servi = [[service alloc]init];
//    
//    [task_Search cancel];
//    task_Search = [servi requestWithURLString:url parameters:dic type:HttpRequestTyepPost success:^(id responseObject) {
//        
//        NSDictionary *resultDic = responseObject;
//        NSArray *resultArray =[resultDic objectForKey:@"table"];
//        if(weakself.page == 1){
//            [weakself.SearchArray removeAllObjects];
//        }
//        [resultArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ArticleSearchModel *model = [ArticleSearchModel objectWithModuleDic:obj hintDic:nil];
//            [weakself.SearchArray addObject:model];
//        }];
//        [weakself.mytableView reloadData];
//        weakself.mytableView.mj_footer.hidden = NO;
//        //        // 拿到当前的下拉刷新控件，结束刷新状态
//        [weakself.mytableView.mj_footer endRefreshing];
//        
//        if(weakself.SearchArray.count == 0){
//            weakself.mytableView.mj_footer.hidden = YES;
//            NoDaTaFootView *footview = [[NoDaTaFootView alloc]initWithFrame:CGRectMake(0, (MAIN_HEIGHT-170-64-30)/2.0, MAIN_WIDTH, 170)];
//            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT-64)];
//            [view addSubview:footview];
//            [footview SetImageWithImage:@"NodataImage" andTitle:@"搜索不到相关内容"];
//            weakself.mytableView.tableFooterView = view;
//            [weakself.sectionView setHidden:YES];
//        }
//        else{
//            UIView *View = [[UIView alloc]initWithFrame:CGRectZero];
//            weakself.mytableView.tableFooterView =View ;
//            [weakself.sectionView setHidden:NO];
//        }
//        if(weakself.SearchArray.count != 0&&resultArray.count == 0){
//            [weakself.mytableView.mj_footer endRefreshingWithNoMoreData] ;
//        }
//        
//        [weakself.loadingView stopAnimating];
//        weakself.page++;
//    } failure:^(NSError *error) {
//        
//        NSString *str =[NSString stringWithFormat:@"网络异常，%@",error.localizedDescription];
//        Alert(@"提示", str);
//        [weakself.loadingView stopAnimating];
//    }];
}


#pragma mark - <************************** 代理方法 **************************>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.LefttableView) {
        return self.leftArray.count;
    }else{
        if (self.leftArray.count) {
            SelectTypeModel *model = self.leftArray[self.leftIndex];
            return model.subTypeArray.count;
        }
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*MAIN_SPWPW;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.LefttableView){
        static NSString *cellId = @"cellleft";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = [UIFont systemFontOfSize:FontSize_15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell.textLabel cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(30).rightToSuper(0).topToSuper(0).bottomToSuper(0);
        }];

        SelectTypeModel *model = self.leftArray[indexPath.row];
        cell.textLabel.text = model.type;
        if (indexPath.row == self.leftIndex) {
           
            [cell.textLabel setTextColor:KColorTheme_font];
            
        }else{
            [cell.textLabel setTextColor:FontSize_colorgray_44];
        }
        return cell;
    }else{
        static NSString *cellId = @"cellright";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = [UIFont systemFontOfSize:FontSize_15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        [cell.textLabel cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).rightToSuper(15).topToSuper(0).bottomToSuper(0);
        }];
        if(indexPath.row == self.rightselectIndex){
            [cell.textLabel setTextColor:KColorTheme_font];
        }else{
            [cell.textLabel setTextColor:FontSize_colorgray_44];
        }
        SelectTypeModel *model = self.leftArray[self.leftIndex];
        cell.textLabel.text = model.subTypeArray[indexPath.row];
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.LefttableView == tableView) {
        self.leftIndex = indexPath.row;
        self.rightselectIndex = 0;
        [self.mytableView reloadData];
        [self.LefttableView reloadData];
    }else{
        self.rightselectIndex = indexPath.row;
        [self.mytableView reloadData];
    }

}


#pragma mark - <************************** 点击事件 **************************>

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view setHidden:YES];
}


#pragma mark - <************************** 其他方法 **************************>

-(NSInteger)refreshOnOutside{
    self.leftIndex = 0;
    self.rightselectIndex = 0;
    [self.leftArray removeAllObjects];
    switch (self.type) {
        case 0:
        {
            SelectTypeModel *model5 = [[SelectTypeModel alloc]init];
            model5.type = @"全部";
            [self.leftArray addObject:model5];
            
            SelectTypeModel *model = [[SelectTypeModel alloc]init];
            model.type = @"音乐培训";
            model.subTypeArray = [NSArray arrayWithObjects:@"钢琴",@"吉塔",@"古筝",@"架子鼓",@"声乐",@"小提琴",@"其他", nil];
            [self.leftArray addObject:model];
            
            SelectTypeModel *model1 = [[SelectTypeModel alloc]init];
            model1.type = @"舞蹈培训";
            model1.subTypeArray = [NSArray arrayWithObjects:@"芭蕾舞",@"民族舞",@"瑜伽",@"独舞",@"双人舞", nil];
            [self.leftArray addObject:model1];
            SelectTypeModel *model2 = [[SelectTypeModel alloc]init];
            model2.type = @"外语培训";
            model2.subTypeArray = [NSArray arrayWithObjects:@"英语",@"日语",@"汉语",@"法语",@"德语",@"西班牙语",@"其他", nil];
            [self.leftArray addObject:model2];
            
            SelectTypeModel *model3 = [[SelectTypeModel alloc]init];
            model3.type = @"教育学院";
            model3.subTypeArray = [NSArray arrayWithObjects:@"早教",@"学前教育",@"小学",@"中学",@"高中",@"大学",@"其他", nil];
            [self.leftArray addObject:model3];
            SelectTypeModel *model4 = [[SelectTypeModel alloc]init];
            model4.type = @"美术培训";
            model4.subTypeArray = [NSArray arrayWithObjects:@"绘画",@"书法",@"其他", nil];
            [self.leftArray addObject:model];
        }
            break;
        case 1:
        {
            SelectTypeModel *model5 = [[SelectTypeModel alloc]init];
            model5.type = @"附近";
            model5.subTypeArray = [NSArray arrayWithObjects:@"附近智能距离",@"1千米",@"3千米",@"5千米",@"10千米",@"全城", nil];
            [self.leftArray addObject:model5];
            
            SelectTypeModel *model = [[SelectTypeModel alloc]init];
            model.type = @"鼓楼区";
            model.subTypeArray = [NSArray arrayWithObjects:@"全部",@"左海／西湖公园",@"西禅寺",@"东街口／三坊七巷",@"五一广场",@"小五四路",@"乌山西路", nil];
            [self.leftArray addObject:model];
            
            SelectTypeModel *model1 = [[SelectTypeModel alloc]init];
            model1.type = @"台江区";
            model1.subTypeArray = [NSArray arrayWithObjects:@"全部",@"台江广场／元洪城",@"台江万达",@"中亭街",@"双国货路", nil];
            [self.leftArray addObject:model1];
            SelectTypeModel *model2 = [[SelectTypeModel alloc]init];
            model2.type = @"晋安区";
            model2.subTypeArray = [NSArray arrayWithObjects:@"全部",@"火车站",@"紫阳／象园",@"五四北路",@"东区／鼓山",@"五里亭",@"其他", nil];
            [self.leftArray addObject:model2];
            
            SelectTypeModel *model3 = [[SelectTypeModel alloc]init];
            model3.type = @"仓山区";
            model3.subTypeArray = [NSArray arrayWithObjects:@"全部",@"蓉城广场",@"仓山万达广场",@"学生街",@"三叉街",@"金山大润发",@"上渡建材", nil];
            [self.leftArray addObject:model3];
            SelectTypeModel *model4 = [[SelectTypeModel alloc]init];
            model4.type = @"马尾区";
            model4.subTypeArray = [NSArray arrayWithObjects:@"骆兴西路",@"东方名城",@"名城港湾", nil];
            [self.leftArray addObject:model];
            
            SelectTypeModel *model6 = [[SelectTypeModel alloc]init];
            model6.type = @"闽侯县";
            [self.leftArray addObject:model6];
            
            SelectTypeModel *model7 = [[SelectTypeModel alloc]init];
            model7.type = @"福清市";

            [self.leftArray addObject:model7];
            SelectTypeModel *model8 = [[SelectTypeModel alloc]init];
            model8.type = @"平潭县";
            model8.subTypeArray = [NSArray arrayWithObjects:@"骆兴西路",@"东方名城",@"名城港湾", nil];
            [self.leftArray addObject:model8];
        }
            break;
        case 2:
        {
            SelectTypeModel *model1 = [[SelectTypeModel alloc]init];
            model1.type = @"智能排序";
            [self.leftArray addObject:model1];
            SelectTypeModel *model2 = [[SelectTypeModel alloc]init];
            model2.type = @"离我最近";

            [self.leftArray addObject:model2];
            
            SelectTypeModel *model3 = [[SelectTypeModel alloc]init];
            model3.type = @"好评优先";
            [self.leftArray addObject:model3];
            SelectTypeModel *model4 = [[SelectTypeModel alloc]init];
            model4.type = @"人气最高";
            [self.leftArray addObject:model4];

        }
            break;
            
        default:
            break;
    }
    if (self.leftArray.count>9) {
        self.tableHeight = 9*50*MAIN_SPWPW;
    }else{
        self.tableHeight = self.leftArray.count*50*MAIN_SPWPW;
    }

//    self.LefttableView.viewHeight = self.leftArray.count*50*MAIN_SPWPW;
//    self.mytableView.viewHeight = self.leftArray.count*50*MAIN_SPWPW;
    [self.LefttableView reloadData];
    [self.mytableView reloadData];
    return self.leftArray.count;
}
#pragma mark - <************************** 检测释放 **************************>
- (void)dealloc{
    DLog(@"%@释放掉",[self class]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
