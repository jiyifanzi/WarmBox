//
//  JYWeatherNowModel.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYWeatherNowWindModel;
@class JYWeatherNowCondModel;


@interface JYWeatherNowModel : NSObject<NSCoding>

//  当前天气
@property (nonatomic, strong) JYWeatherNowCondModel * cond;
//  体感温度
@property (nonatomic, copy) NSString * fl;
//  湿度
@property (nonatomic, copy) NSString * hum;
//  降水量
@property (nonatomic, copy) NSString * pcpn;
//  气压
@property (nonatomic, copy) NSString * pres;
//  温度
@property (nonatomic, copy) NSString * tmp;
//  能见度
@property (nonatomic, copy) NSString * vis;
//  风力状况
@property (nonatomic, strong) JYWeatherNowWindModel * wind;

@end

//  ===========天气情况
@interface JYWeatherNowCondModel : NSObject<NSCoding>

//  天气代码
@property (nonatomic, strong) NSString * code;
//  天气描述
@property (nonatomic, strong) NSString * txt;


@end


//  ===========风力情况
@interface JYWeatherNowWindModel : NSObject<NSCoding>

//  风向 角度
@property (nonatomic, strong) NSString * deg;
//  风向 方向
@property (nonatomic, strong) NSString * dir;
//  风力等级
@property (nonatomic, strong) NSString * sc;
//  风速
@property (nonatomic, strong) NSString * spd;

@end