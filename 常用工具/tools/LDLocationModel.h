//
//  LDLocationModel.h
//  Linkdood
//
//  Created by VRV2 on 16/7/20.
//  Copyright © 2016年 xiong qing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LDLocationModel;
typedef void(^goBackLocation)(BOOL suceess,LDLocationModel *locationModel );

@interface LDLocationModel : NSObject
@property (assign,nonatomic) CGFloat mLocation_Y;
@property (assign,nonatomic) CGFloat mLocation_X;
@property (copy,nonatomic)   NSString *mCity;
@property (copy,nonatomic)   NSString *mPoiName;
@property (copy,nonatomic)   NSString *mAddress;
@property (copy,nonatomic)   NSString *mStreet;
@property (copy,nonatomic)   NSString *mStreetNum;
@property (copy,nonatomic)   NSString *mAoiName;
@property (copy,nonatomic)   NSString *mProvince;
@property (copy,nonatomic)   NSString *mDistrict;
@property (copy,nonatomic)   NSString *mCityCode;
@property (copy,nonatomic)   NSString *mAdCode;
@property (copy,nonatomic)   NSString *mRoad;

@property (copy,nonatomic) goBackLocation locationBlock;

+(instancetype)locationServiceWithLocation;
@end
