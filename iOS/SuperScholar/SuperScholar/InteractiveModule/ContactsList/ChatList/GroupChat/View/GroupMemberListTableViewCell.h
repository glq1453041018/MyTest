//
//  GroupMemberListTableViewCell.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWTribeMember.h>


@interface GroupMemberListTableViewCell : UITableViewCell
- (void)configureWithAvatar:(UIImage *)image name:(NSString *)title role:(YWTribeMemberRole)role;
@end
