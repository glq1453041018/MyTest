//
//  MapManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class AddressInfo;
@interface MapManager : NSObject
@property (strong ,nonatomic) AddressInfo *historyAddress;  // 历史地址

+(instancetype)share;

/**
 配置地图
 */
-(void)configMap;

/**
 获取实时地址, 此方法会更新 historyAddress
 */
-(void)locationCompletionBlock:(void(^)(AddressInfo *currentAddress, BOOL needUpdate, NSError *error))block;


@end






// !!!: 地址信息
@interface AddressInfo : NSObject
@property (strong ,nonatomic) AMapLocationPoint *location;          // 经纬度
@property (strong ,nonatomic) AMapLocationReGeocode *regeocode;     // 反地理位置
@property (copy ,nonatomic) NSString *cityName;
@end
