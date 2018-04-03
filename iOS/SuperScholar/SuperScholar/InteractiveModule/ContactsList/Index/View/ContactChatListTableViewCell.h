//
//  ContactChatListTableViewCell.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactChatListTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *identifier;

- (void)configureWithAvatar:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;
- (void)configureWithAvatarUrl:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle;
@end
