//
//  GroupQRCodeViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/5/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《群二维码页》

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface GroupQRCodeViewController : UIViewController
@property (nonatomic, strong) YWTribe *tribe;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@end
