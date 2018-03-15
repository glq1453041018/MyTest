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
@end



@interface ClassInfoModel_PingJia : ClassInfoModel

@end



@interface ClassInfoModel_Item : ClassInfoModel
@property (copy ,nonatomic) NSString *icon;
@end











