//
//  LDLocationModel.m
//  Linkdood
//
//  Created by VRV2 on 16/7/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import "LDLocationModel.h"
#import <CoreLocation/CoreLocation.h>

@interface LDLocationModel ()<CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *location;
@end


@implementation LDLocationModel
-(CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        //kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        _locationManager.distanceFilter = kCLDistanceFilterNone;  //不需要移动都可以刷新
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 50.0f;
        if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0))
        {
            [_locationManager requestAlwaysAuthorization];
        }
    }
    return _locationManager;
}
-(instancetype)init{
    self = [super init];
    if (self) {
         self.locationManager.delegate = self;
         [self getUserLocation];
    }
    return self;
}
//开始加载定位信息
+(instancetype)locationServiceWithLocation{
  
    return [[self alloc]init];
}
//获取当前位置
- (void)getUserLocation
{
    /**********开始获取定位信息*************/
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled ]) {
        
        NSLog(@"定位服务打开");
    }
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
        [self.locationManager requestWhenInUseAuthorization];
        //更新位置
        [self.locationManager startUpdatingLocation];
    }else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"授权成功");
        
        //更新位置
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"授权失败");
    }
    
}

#pragma mark-CLLocationManagerDelegate  位置更新后的回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止位置更新
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *loc = [locations firstObject];
    CLLocationCoordinate2D theCoordinate;
    //位置更新后的经纬度
    theCoordinate.latitude = loc.coordinate.latitude;
    theCoordinate.longitude = loc.coordinate.longitude;
    _mLocation_X = theCoordinate.latitude;
    _mLocation_Y = theCoordinate.longitude;
    self.location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
     __weak  typeof(self)  weakSelf = self;
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             // 将获得的所有信息显示到label上
             // 获取城市
             NSString *city = placemark.administrativeArea;
             if (!city) {
                 // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSString *locationStr = [NSString stringWithFormat:@"%@%@%@%@%@",city,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];
             
             weakSelf.mAddress = locationStr?locationStr:@" ";
             weakSelf.mProvince = city?city:@" ";
             weakSelf.mCity = placemark.locality?placemark.locality:@" ";
             weakSelf.mDistrict = placemark.subLocality?placemark.subLocality:@" ";
             weakSelf.mRoad = placemark.thoroughfare?placemark.thoroughfare:@" ";
             weakSelf.mStreet = placemark.thoroughfare?placemark.thoroughfare:@" ";
             weakSelf.mStreetNum = placemark.subThoroughfare?placemark.subThoroughfare:@" ";
             weakSelf.mAdCode = placemark.postalCode?placemark.postalCode:@" ";
             weakSelf.mCityCode = @"122";
             weakSelf.mAoiName = @"dfasdf";
             weakSelf.mPoiName = @"dfasfaf";
             if (weakSelf.locationBlock&&placemark) {
                 weakSelf.locationBlock(YES,weakSelf);
             }
        }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
         
     }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}
@end
