//
//  MessageRemindViewController.h
//  SuperScholar
//
//  Created by cwn on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//《消息通知、我的评论、我的收藏、我的历史》

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MessageRemindListType) {
    MessageRemindListTypeDefault,//消息通知
    MessageRemindListTypeComment,//评论消息
    MessageRemindListTypeCollection,//收藏消息
    MessageRemindListTypeHistory//历史消息
};

@interface MessageRemindViewController : UIViewController
@property (assign, nonatomic) MessageRemindListType listType;//列表类型
@end
