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



#import "ClassInfoTitleItemView.h"
#import "ClassInfoModel.h"
@protocol ClassInfoTableViewCell_TitleDelegate <NSObject>
@optional
-(void)classInfoTableViewCell_TitleClickEvent:(NSInteger)index data:(ClassInfoModel*)model;
@end
@interface ClassInfoTableViewCell_Title : ClassInfoTableViewCell
@property (nonatomic,weak) id <ClassInfoTableViewCell_TitleDelegate> delegate;
@property (copy ,nonatomic) NSArray *data;
// !!!: 加载视图
-(void)loadData:(NSArray *)data;
@end





#import "MYCommentStarView.h"
@interface ClassInfoTableViewCell_PingJia : ClassInfoTableViewCell

@property (weak, nonatomic) IBOutlet MYCommentStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end







@interface ClassInfoTableViewCell_Item : ClassInfoTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
