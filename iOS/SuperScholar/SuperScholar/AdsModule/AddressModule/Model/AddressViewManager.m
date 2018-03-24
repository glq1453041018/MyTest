//
//  AddressViewManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/17.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "AddressViewManager.h"

@interface AddressViewManager ()
@property (strong ,nonatomic) AMapLocationManager *locationManager;
@end

@implementation AddressViewManager

+(instancetype)share{
    static AddressViewManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AddressViewManager new];
    });
    return instance;
}


-(void)configMap{
    [AMapServices sharedServices].apiKey = kMapKey;
}

-(void)locationCompletionBlock:(void (^)(AMapLocationReGeocode *, NSError *))block{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (block) {
            block(regeocode,error);
        }
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        if (regeocode){
            DLog(@"reGeocode:%@", regeocode);
        }
    }];
}

-(AMapLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager = [AMapLocationManager new];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   逆地理请求超时时间，最低2s
        _locationManager.reGeocodeTimeout = 2;
        //   定位超时时间，最低2s，
        self.locationManager.locationTimeout = 2;
    }
    return _locationManager;
}


@end
