//
//  MapManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MapManager.h"
@interface MapManager ()
@property (strong ,nonatomic) AMapLocationManager *locationManager;
@end

@implementation MapManager

+(instancetype)share{
    static MapManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MapManager new];
    });
    return instance;
}


-(void)configMap{
    [AMapServices sharedServices].apiKey = kMapKey;
}

-(void)locationCompletionBlock:(void (^)(AddressInfo *, BOOL, NSError *))block{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        BOOL needUpdate = NO;   // 是否需要更新
        if (![self.historyAddress.regeocode.country isEqualToString:regeocode.country]) {
            needUpdate = YES;
        }
        else if (![self.historyAddress.regeocode.province isEqualToString:regeocode.province]){
            needUpdate = YES;
        }
        else if (![self.historyAddress.regeocode.city isEqualToString:regeocode.city]){
            needUpdate = YES;
        }
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        else{
            self.historyAddress.regeocode = regeocode;
            self.historyAddress.cityName = regeocode.city;
            DLog(@"reGeocode:%@", regeocode);
            self.historyAddress.location = [AMapLocationPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        }
        
        if (block) {
            block(self.historyAddress, needUpdate,error);
        }
    }];
}

-(AMapLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager = [AMapLocationManager new];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        //   逆地理请求超时时间，最低2s
        _locationManager.reGeocodeTimeout = 5;
        //   定位超时时间，最低2s，
        _locationManager.locationTimeout = 5;
    }
    return _locationManager;
}


-(AddressInfo *)historyAddress{
    if (_historyAddress==nil) {
        _historyAddress = [AddressInfo new];
    }
    return _historyAddress;
}



@end






// !!!: 地址信息
@implementation AddressInfo

-(AMapLocationPoint *)location{
    if (_location==nil) {
        _location = [AMapLocationPoint new];
    }
    return _location;
}

-(AMapLocationReGeocode *)regeocode{
    if (_regeocode==nil) {
        _regeocode = [AMapLocationReGeocode new];
    }
    return _regeocode;
}

@end
