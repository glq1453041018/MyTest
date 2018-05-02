//
//  GroupInfoEditViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《群信息编辑页》

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

typedef enum : NSUInteger {
    SPTribeInfoEditModeModify,
    SPTribeInfoEditModeCreateNormal,
    SPTribeInfoEditModeCreateMultipleChat,
} SPTribeInfoEditMode;

@interface GroupInfoEditViewController : UIViewController
@property (nonatomic, strong) YWTribe *tribe;
@property (nonatomic, assign) SPTribeInfoEditMode mode;
@end
