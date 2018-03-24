//
//  ActivityModel.h
//  SuperScholar
//
//  Created by 伟南 陈 on 2018/3/21.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

//文字、图片
@interface ActivityModel : NSObject
@property (strong, nonatomic) NSString *title;//标题
@property (strong, nonatomic) NSString *headerUrl;//头像
@property (strong, nonatomic) NSString *name;//姓名
@property (strong, nonatomic) NSString *date;//日期
@property (assign, nonatomic) NSInteger click;//阅读
@property (assign, nonatomic) NSInteger comment;//评论
@property (assign, nonatomic) NSInteger zan;//点赞
@property (strong, nonatomic) NSString *imageUrl;//图片地址
@end

//文字、视频
@interface ActivityVideoModel : ActivityModel
@property (strong, nonatomic) NSString *videoUrl;//视频地址
@end
