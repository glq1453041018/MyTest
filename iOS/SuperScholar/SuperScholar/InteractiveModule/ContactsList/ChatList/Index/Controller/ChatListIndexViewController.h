//
//  ChatListIndexViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/4.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSegmentController.h"

@interface ChatListIndexViewController : UIViewController
@property (strong, nonatomic) MYSegmentController *segmentController;
@property (assign, nonatomic) CGRect tableFrame;
@end
