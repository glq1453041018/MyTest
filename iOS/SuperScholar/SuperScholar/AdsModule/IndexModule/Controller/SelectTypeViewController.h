//
//  SelectTypeViewController.h
//  SuperScholar
//
//  Created by guolq on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^returnTypeBlock)(NSDictionary *typeDic);
@interface SelectTypeViewController : UIViewController

@property (copy,nonatomic)returnTypeBlock returnType;
@property (strong,nonatomic)NSMutableDictionary *typeDic;
@property (strong,nonatomic)UITableView *mytableView;
@property (strong,nonatomic)UITableView *LefttableView;
@property (assign,nonatomic) NSInteger type; //0全部,1 附近,2智能排序
@property (assign,nonatomic) CGFloat tableHeight; //0全部,1 附近,2智能排序
-(NSInteger)refreshOnOutside;
@end
