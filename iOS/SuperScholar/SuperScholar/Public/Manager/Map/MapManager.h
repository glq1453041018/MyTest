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
#import <AMapSearchKit/AMapSearchKit.h>

@class AddressInfo;
@interface MapManager : NSObject
@property (strong ,nonatomic) AMapGeocode *historyGeocode;  // 地理位置信息

+(instancetype)share;

/**
 配置地图
 */
-(void)configMap;

/**
 获取实时地址, 此方法会更新 historyAddress
 */
-(void)locationCompletionBlock:(void(^)(AMapGeocode *currentAddress, BOOL needUpdate, NSError *error))block;

/**
 设置成新的城市
 */
-(void)setCity:(NSString*)cityName;


@end





