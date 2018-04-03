//
//  ContactChatListViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/2.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ContactChatListModeNormal,
//    ContactChatListModeSingleSelection,
//    ContactChatListModeMultipleSelection
} ContactChatListMode;


@interface ContactChatListViewController : UIViewController
@property (nonatomic, assign) ContactChatListMode mode;
@end
