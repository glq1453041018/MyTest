//
//  ActivityTableViewCell.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@end



@interface ActivityTableViewCell_Image : ActivityTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *click;
@property (weak, nonatomic) IBOutlet UIButton *zan;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end


@interface ActivityTableViewCell_NO_Image : ActivityTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *click;
@property (weak, nonatomic) IBOutlet UIButton *zan;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@end

@interface ActivityTableViewCell_Video : ActivityTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *click;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

