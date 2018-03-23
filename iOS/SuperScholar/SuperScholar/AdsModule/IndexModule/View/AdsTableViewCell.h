//
//  AdsTableViewCell.h
//  SuperScholar
//
//  Created by guolq on 2018/3/23.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCommentStarView.h"
@interface AdsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@end
@interface AdsTableViewCell_moreImage : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImage1;
@property (weak, nonatomic) IBOutlet UIImageView *headImage2;
@property (weak, nonatomic) IBOutlet UIImageView *headImage3;

@end
@interface AdsTableViewCell_NoImage : UITableViewCell
@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;

@end

@interface AdsTableViewCell_Header : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *typeSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *areaSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *IntelligenceBtn;

@end
