//
//  JYGencoder.m
//  02-地址的编码和反编码
//
//  Created by qianfeng on 16/6/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYGencoder.h"
#import <MapKit/MapKit.h>



@interface JYGencoder()


@end

@implementation JYGencoder

+ (CLGeocoder *)creatGeocoder {
    CLGeocoder * geocoder = nil;
    
    if (geocoder == nil) {
        geocoder = [[CLGeocoder alloc] init];
    }
    return geocoder;
}

//  将经纬度转换成地址 地址的反编码
+ (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coordinate didFinish:(void (^)(NSDictionary *))address{
    //  1.拿到解析器
    CLGeocoder * geo = [self creatGeocoder];
    
    //  2.反编码
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geo reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //  参数1：placemarks 反编码之后的结果
        for (CLPlacemark * mark in placemarks) {
//            NSLog(@"%@",mark.addressDictionary);
//            
//            //  获取详细信息
//            NSLog(@"%@",mark.addressDictionary[@"FormattedAddressLines"][0]);
//            
//            //  国家
//            NSLog(@"%@",mark.addressDictionary[@"City"]);
//            //  省
//            NSLog(@"%@",mark.addressDictionary[@"State"]);
//            //  区
//            NSLog(@"%@",mark.addressDictionary[@"SubLocality"]);
//            //  路
//            NSLog(@"%@",mark.addressDictionary[@"Thoroughfare"]);
            
            
            //  拿到获得的字典 传入block
            address(mark.addressDictionary);
        }
    }];
}

//  将地址转换成经纬度
+ (void)getCoordinateWithAddress:(NSString *)address didFinish:(void (^)(CLLocationCoordinate2D))location {
    //  将地址编码成对应的经纬度
    [[self creatGeocoder] geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //  拿到经纬度
        CLLocationCoordinate2D jy_coordinate;
        
        for (CLPlacemark * mark in placemarks) {
            jy_coordinate = mark.location.coordinate;
            
            location(jy_coordinate);
        }
    }];
}

@end
