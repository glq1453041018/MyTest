//
//  GroupProfileViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《群资料页》

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import "GroupInfoEditViewController.h"

@interface GroupProfileViewController : UIViewController

@property (nonatomic, strong) YWTribe *tribe;
@property (nonatomic, assign) SPTribeInfoEditMode mode;

@end
