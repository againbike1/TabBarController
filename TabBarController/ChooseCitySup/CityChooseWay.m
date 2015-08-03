//
//  CityChooseWay.m
//  BMap+QHMap
//
//  Created by imqiuhang on 15/3/18.
//  Copyright (c) 2015年 your Co. Ltd. All rights reserved.
//

#import "CityChooseWay.h"
#import <BaiduMapAPI/BMKLocationService.h>
@implementation CityChooseWay
{
    BMKLocationService *locService;
    BMKGeoCodeSearch   *geocodesearch;
    int locationNum;
}

- (id)init {
    if (self==[super init]) {
        locService = [[BMKLocationService alloc] init];
        geocodesearch = [[BMKGeoCodeSearch alloc]init];
        locationNum=0;
    }
    return self;
}

- (void)beginSearch {
    [self getLocation];
}


- (void)getLocation {
    

    locService.delegate = self;
    [locService startUserLocationService];
    
}

- (void)getCityWithLocation:(CLLocation *)location {

    geocodesearch.delegate = self;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location.coordinate;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    
    if(flag) {
        //反geo检索发送成功";
        MSLog(@"反geo检索发送成功");
    }else {
        geocodesearch.delegate=nil;
        if ([self.delegate respondsToSelector:@selector(didSearchCityFaild)]) {
            [self.delegate didSearchCityFaild];
            MSLog(@"反geo检索发送失败");
        }
    }
    
}


#pragma mark -
#pragma mark BMapDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location!=nil) {
        [self getCityWithLocation:userLocation.location];
    }else {
        if ([self.delegate respondsToSelector:@selector(didSearchCityFaild)]) {
            [self.delegate didSearchCityFaild];
            MSLog(@"定位失败:没有返回位置经纬度");
        }
    }
    [locService stopUserLocationService];
    locService.delegate=nil;
    geocodesearch.delegate = self;
    locationNum=0;

}

//- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation {
//    if (userLocation.location!=nil) {
//        [self getCityWithLocation:userLocation.location];
//    }else {
//        if ([self.delegate respondsToSelector:@selector(didSearchCityFaild)]) {
//            [self.delegate didSearchCityFaild];
//            MSLog(@"定位失败:没有返回位置经纬度");
//        }
//    }
//    [locService stopUserLocationService];
//    locService.delegate=nil;
//    geocodesearch.delegate = self;
//    locationNum=0;
//}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    
    locationNum++;
    if (locationNum>=10) {
        locationNum=0;
        if ([self.delegate respondsToSelector:@selector(didSearchCityFaild)]) {
            [self.delegate didSearchCityFaild];
        }
        MSLog(@"定位失败:\n%@",error);
    }else {
        [locService startUserLocationService];
    }
    
}
- (void)stopLocating {
    [locService stopUserLocationService];
    locService.delegate=nil;
    
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error) {
        if ([self.delegate respondsToSelector:@selector(didSearchCityFaild)]) {
            [self.delegate didSearchCityFaild];
            MSLog(@"反geo检索发送成功,但获取数据失败：\n%u",error);
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(didSearchCitySucceed:)]) {
            [self.delegate didSearchCitySucceed:[CityChooseResult cityChooseResultMakeWithName:result.addressDetail.city andPingYingName:nil andLocation:result.location]];
            MSLog(@"获取位置成功:\n,%@",result);
        }
    }
    geocodesearch.delegate=nil;
}

+ (NSString *)getCityPingYing:(NSString *)aCityName {
    if (!aCityName||[aCityName isEqualToString:@""]) {
        return @"";
    }else {
        NSString *noSignCityName=[aCityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if ([ChineseInclude isIncludeChineseInString:noSignCityName]) {
            NSString *pingYingCity = [PinYinForObjc chineseConvertToPinYin:noSignCityName];
            return pingYingCity;
        }else {
            return aCityName;
        }
    }
}

@end



@implementation CityChooseResult

+ (CityChooseResult *)cityChooseResultMakeWithName:(NSString *)aName andPingYingName:(NSString *)aPingYing andLocation:(CLLocationCoordinate2D)aLocation {
    CityChooseResult *result = [[CityChooseResult alloc] init];
    result.cityName = aName?aName:@"";
    result.cityPingYingName =aPingYing?aPingYing:@"";
    result.location=aLocation;
    return result;
    
    
}

@end







