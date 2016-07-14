//
//  JYGencoder.h
//  02-地址的编码和反编码
//
//  Created by qianfeng on 16/6/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JYGencoder : NSObject


//  传入经纬度，返回地址
+ (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coordinate didFinish:(void (^)(NSDictionary * infoDict))address;

//  传入地址，返回经纬度
+ (void)getCoordinateWithAddress:(NSString *)address didFinish:(void (^)(CLLocationCoordinate2D coordinate))location;



@end
