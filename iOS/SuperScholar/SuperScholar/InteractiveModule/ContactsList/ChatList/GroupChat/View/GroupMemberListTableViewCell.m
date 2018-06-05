//
//  GroupMemberListTableViewCell.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "GroupMemberListTableViewCell.h"

@interface GroupMemberListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roleLabelWidthConstaint;
@end

@implementation GroupMemberListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.roleLabel.layer.cornerRadius = 2.0;
    self.roleLabel.clipsToBounds = YES;
    
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.roleLabelWidthConstaint.constant = self.roleLabel.intrinsicContentSize.width + 4 * 2;
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    UIColor *color = self.roleLabel.backgroundColor;
    [super setSelected:selected animated:animated];
    self.roleLabel.backgroundColor = color;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    UIColor *color = self.roleLabel.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.roleLabel.backgroundColor = color;
}

- (void)configureWithAvatar:(UIImage *)image name:(NSString *)title role:(YWTribeMemberRole)role {
    self.avatarImageView.image = image;
    self.nameLabel.text = title;
    
    
    switch (role) {
        case YWTribeMemberRoleOwner:
            self.roleLabel.text = @"群主";
            self.roleLabel.backgroundColor = [UIColor colorWithRed:1.0 green:189./255 blue:4./255 alpha:1.0];
            self.roleLabel.hidden = NO;
            break;
        case YWTribeMemberRoleManager:
            self.roleLabel.text = @"管理员";
            self.roleLabel.backgroundColor = [UIColor colorWithRed:69.0/255 green:210./255 blue:130./255 alpha:1.0];
            self.roleLabel.hidden = NO;
            break;
        default:
            self.roleLabel.text = nil;
            self.roleLabel.hidden = YES;
            break;
    }
    
    
}


@end
