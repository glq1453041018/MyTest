//
//  ContactChatListTableViewCell.m
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "ContactChatListTableViewCell.h"

@interface ContactChatListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelCenterYConstraint;
@end

@implementation ContactChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)configureWithAvatar:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    self.avatarImageView.image = image;
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    
    UILayoutPriority titleLabelCenterYLayoutPriority;
    if (subtitle.length == 0) {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultHigh + 100;
        self.subtitleLabel.hidden = YES;
    }
    else {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultLow;
        self.subtitleLabel.hidden = NO;
    }
    if (self.titleLabelCenterYConstraint.priority != titleLabelCenterYLayoutPriority) {
        self.titleLabelCenterYConstraint.priority = titleLabelCenterYLayoutPriority;
        [self setNeedsLayout];
    }
}

- (void)configureWithAvatarUrl:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle {
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:image]];
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    
    UILayoutPriority titleLabelCenterYLayoutPriority;
    if (subtitle.length == 0) {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultHigh + 100;
        self.subtitleLabel.hidden = YES;
    }
    else {
        titleLabelCenterYLayoutPriority = UILayoutPriorityDefaultLow;
        self.subtitleLabel.hidden = NO;
    }
    if (self.titleLabelCenterYConstraint.priority != titleLabelCenterYLayoutPriority) {
        self.titleLabelCenterYConstraint.priority = titleLabelCenterYLayoutPriority;
        [self setNeedsLayout];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
