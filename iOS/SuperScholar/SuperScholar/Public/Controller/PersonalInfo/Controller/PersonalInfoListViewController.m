//
//  PersonalInfoListViewController.m
//  SuperScholar
//
//  Created by LOLITA on 18/3/24.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "PersonalInfoListViewController.h"
#import "LolitaTableView.h"
#import "ZhaoShengTableViewCell.h"

@interface PersonalInfoListViewController ()<UITableViewDelegate,UITableViewDataSource>
/// !!!: 视图类
@property (strong ,nonatomic) LolitaTableView *table;

@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation PersonalInfoListViewController


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
    for (int i=0; i < 10; i ++) {
        [self.data addObject:[TESTDATA randomContent]];
    }
    [self.table reloadData];
}

#pragma mark - <************************** 配置视图 **************************>
// !!!: 配置视图
-(void)initUI{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.table];
}


#pragma mark - <*********************** 初始化控件/数据 **********************>
-(LolitaTableView *)table{
    if (_table==nil) {
        _table = [[LolitaTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kscrollerbarHeight-self.navigationBar.bottom)];
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [UIView new];
        _table.showsVerticalScrollIndicator = NO;
        _table.type = LolitaTableViewTypeSub;
    }
    return _table;
}

- (NSMutableArray *)data{
    if(_data==nil){
        _data = [NSMutableArray array];
    }
    return _data;
}


#pragma mark - <************************** 代理方法 **************************>
// !!!: 导航栏
-(void)navigationViewLeftClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [self.data objectAtIndex:indexPath.row];
    
    NSString *cellid = indexPath.row % 4 ? @"zhaoshengcell2" : @"zhaoshengcell";
    ZhaoShengTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(!cell){
        if(indexPath.row % 4)
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][1];
        else
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZhaoShengTableViewCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentLable setAttributedText:[self adjustLineSpace:text]];
        
        [cell cwn_makeShiPeis:^(UIView *maker) {
            maker.shiPeiAllSubViews().shiPeiSelf();
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ShiPei(134);
}


#pragma mark - <************************** 点击事件 **************************>




#pragma mark - <************************** 其他方法 **************************>
- (NSMutableAttributedString *)adjustLineSpace:(NSString *)text{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LineSpace];//调整行间距
    
    NSMutableAttributedString *attributStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributStr length])];
    //设置文字颜色
    [attributStr addAttribute:NSForegroundColorAttributeName value:FontSize_colorgray range:NSMakeRange(0, attributStr.length)];
    //设置文字大小
    [attributStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FontSize_16] range:NSMakeRange(0, attributStr.length)];
    
    return attributStr;
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
