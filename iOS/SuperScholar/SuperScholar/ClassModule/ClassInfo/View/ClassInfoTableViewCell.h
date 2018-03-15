//
//  ClassInfoTableViewCell.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassInfoTableViewCell : UITableViewCell

@end







@interface ClassInfoTableViewCell_PingJia : ClassInfoTableViewCell

@end







@interface ClassInfoTableViewCell_Item : ClassInfoTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

