//
//  AddressViewManager.h
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AddressViewManager : NSObject

+(instancetype)share;

-(void)configMap;

-(void)locationCompletionBlock:(void(^)(AMapLocationReGeocode *regeocode, NSError *error))block;

@end
