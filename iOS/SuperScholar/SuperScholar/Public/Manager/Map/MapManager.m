//
//  MapManager.m
//  SuperScholar
//
//  Created by 骆亮 on 2018/3/26.
//  Copyright © 2018年 SuperScholar. All rights reserved.
//

#import "MapManager.h"
@interface MapManager ()<AMapSearchDelegate>
@property (strong ,nonatomic) AMapLocationManager *locationManager; // 定位
@property (strong ,nonatomic) AMapSearchAPI *search;                // 地理搜索
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

-(void)locationCompletionBlock:(void (^)(AMapGeocode *, BOOL, NSError *))block{
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        BOOL needUpdate = NO;   // 是否需要更新
        if (![self.historyGeocode.city isEqualToString:regeocode.city]){
            needUpdate = YES;
        }
        if (error){
            DLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        else{
            DLog(@"reGeocode:%@", regeocode);
            self.historyGeocode.city = regeocode.city;
            self.historyGeocode.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            if ([regeocode.city hasSuffix:@"市"]) {
                self.historyGeocode.city = [self removeLastOneChar:self.historyGeocode.city];
            }
        }
        
        if (block) {
            block(self.historyGeocode, needUpdate,error);
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


-(AMapSearchAPI *)search{
    if (_search==nil) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}


-(AMapGeocode *)historyGeocode{
    if (_historyGeocode==nil) {
        _historyGeocode = [AMapGeocode new];
    }
    return _historyGeocode;
}


// !!!: 设置新的地址
-(void)setCity:(NSString *)cityName{
    if (cityName.length==0) {
        return;
    }
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = cityName;
    geo.city = cityName;
    [self.search AMapGeocodeSearch:geo];
}


#pragma mark - <************************** 代理 **************************>
// !!!: 地理编码代理x
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    if (response.geocodes.count == 0){
        return;
    }
    DLog(@"搜索到的数量：%ld",response.geocodes.count);
    AMapGeocode *geo = response.geocodes.firstObject;
    DLog(@"city：%@，（%f,%f）",geo.city,geo.location.longitude,geo.location.latitude);
    self.historyGeocode = geo;
    if ([self.historyGeocode.city hasSuffix:@"市"]) {
        self.historyGeocode.city = [self removeLastOneChar:self.historyGeocode.city];
    }
    // 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:AMapSearchCityCompletionNotification object:nil];
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    DLog(@"地图搜索发生错误：%@",error.localizedDescription);
}



#pragma mark - <************************** 其他 **************************>
-(NSString*)removeLastOneChar:(NSString*)origin{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];
    }else{
        cutted = origin;
    }
    return cutted;
}


@end


