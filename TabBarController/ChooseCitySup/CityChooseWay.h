//
//  CityChooseWay.h
//  BMap+QHMap
//
//  Created by imqiuhang on 15/3/18.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BMapKit.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#ifdef DEBUG
#define MSLog(fmt,...) NSLog((@"\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n[行号]%d\n" "[函数名]%s\n" "[日志]" fmt"\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"),__LINE__,__FUNCTION__,##__VA_ARGS__);
#else
#define MSLog(fmt,...);
#endif

#define msScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define msScreenHeight    [[UIScreen mainScreen] bounds].size.height-20


@interface CityChooseResult : NSObject

@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *cityPingYingName;
@property (nonatomic,assign)CLLocationCoordinate2D location;

+ (CityChooseResult *)cityChooseResultMakeWithName:(NSString *)aName
                                   andPingYingName:(NSString *)aPingYing
                                       andLocation:(CLLocationCoordinate2D )aLocation;

@end



@protocol CityChooseWayDelegate <NSObject>

- (void)didSearchCitySucceed:(CityChooseResult *)result;
- (void)didSearchCityFaild;

@end


@interface CityChooseWay : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic,weak)id<CityChooseWayDelegate>delegate;

- (void)beginSearch;
- (void)stopLocating;

+ (NSString *)getCityPingYing:(NSString *)aCityName;

@end


