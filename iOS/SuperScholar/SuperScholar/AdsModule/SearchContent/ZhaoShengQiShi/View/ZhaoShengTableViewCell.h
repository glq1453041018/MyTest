//
//  ZhaoShengTableViewCell.h
//  SuperScholar
//
//  Created by guolq on 2018/3/7.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoShengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end
@interface ZhaoShengTableViewCell_NOImage : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end