//
//  AddressViewManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface AddressViewManager : NSObject


// !!!: 获取数据
+(void)requestDataResponse:(void(^)(NSArray *resArray,id error))responseBlock;



// !!!: 获取城市名称
+(NSDictionary*)getCityList;


@end



