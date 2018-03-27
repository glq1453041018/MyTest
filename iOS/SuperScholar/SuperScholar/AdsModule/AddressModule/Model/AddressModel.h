//
//  AddressModel.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AddressModel : NSObject

@property (copy ,nonatomic) NSString *typeName;                     // 类型名称
@property (copy ,nonatomic) NSString *cityName;                     // 城市名称
@property (assign ,nonatomic) CLLocationCoordinate2D coordinate;    // 经纬度坐标

@property (assign ,nonatomic) CGFloat cellHeight;                   

@end
