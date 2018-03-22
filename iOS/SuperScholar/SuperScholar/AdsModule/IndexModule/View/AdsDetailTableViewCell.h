//
//  AdsDetailTableViewCell.h
//  SuperScholar
//
//  Created by guolq on 2018/3/20.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;

@end

#import "MYCommentStarView.h"
@interface AdsDetailTableViewCell_comment : UITableViewCell
@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end


@interface AdsDetailTableViewCell_adress : UITableViewCell

@end
@interface AdsDetailTableViewCell_footView : UITableViewCell

@end
