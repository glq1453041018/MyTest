//
//  ClassInfoModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/15.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassInfoModel : NSObject
@property (copy ,nonatomic) NSString *key;
@property (copy ,nonatomic) NSString *value;
@property (assign ,nonatomic) InteractiveStyle style;
@property (assign ,nonatomic) NSInteger cellHeight;
@end



@interface ClassInfoModel_PingJia : ClassInfoModel
@property (assign ,nonatomic) CGFloat starNum;
@property (assign ,nonatomic) NSInteger commentNum;
@end



@interface ClassInfoModel_Item : ClassInfoModel
@property (copy ,nonatomic) NSString *icon;
@property (copy ,nonatomic) NSString *code;
@end











