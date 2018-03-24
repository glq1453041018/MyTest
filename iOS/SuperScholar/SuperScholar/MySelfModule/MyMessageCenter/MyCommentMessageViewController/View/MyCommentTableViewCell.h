//
//  MyCommentTableViewCell.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/22.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//大回复内容
@property (weak, nonatomic) IBOutlet UILabel *replayLabel;//小回复内容
@property (weak, nonatomic) IBOutlet UILabel *messageContent;//主体消息内容
@end

@interface MyCommentTableViewCell_NOImage : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//大回复内容
@property (weak, nonatomic) IBOutlet UILabel *replayLabel;//小回复内容
@property (weak, nonatomic) IBOutlet UILabel *messageContent;//主体消息内容
@end
