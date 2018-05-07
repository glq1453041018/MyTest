//
//  ContactChatListManager.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/4/3.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWPerson.h>

@interface ContactChatListManager : UIViewController
+ (instancetype)defaultManager;

- (NSArray *)fetchContactPersonIDs;

- (BOOL)existContact:(YWPerson *)person;
- (BOOL)addContact:(YWPerson *)person;
- (BOOL)removeContact:(YWPerson *)person;
@end
