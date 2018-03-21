//
//  ActivitySubViewController.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ActivityListType) {
    ActivityListTypeActivityShow,//精彩演出
    ActivityListTypeActivityPre,//活动预告
    ActivityListTypeGoodArticle,//优秀文章
};
#import <UIKit/UIKit.h>

@interface ActivitySubViewController : UIViewController
@property (assign, nonatomic) ActivityListType listType;
@end
