//
//  ClassSpaceVideoTableViewCell.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCommentStarView.h"
#import "ClassSpaceTableViewCellDelegate.h"
@interface ClassSpaceVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNamelLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic,copy) void(^playBlock)();

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (nonatomic,weak) id <ClassSpaceTableViewCellDelegate> delegate;

@end
