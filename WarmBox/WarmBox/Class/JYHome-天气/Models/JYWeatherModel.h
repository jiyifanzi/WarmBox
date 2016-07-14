//
//  JYWeatherModel.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@class JYWeatherBasicModel;
@class JYWeatherNowModel;
@class JYWeatherSuggestionModel;
@class JYWeatherAQICityModel;
@class JYWeatherAQIDataModel;

//  天气总的Model
@interface JYWeatherModel : NSObject<YYModel>

//  api 空气质量指数 -- 有的城市没有
@property (nonatomic, strong) JYWeatherAQICityModel * aqi;
//  basic 城市基本信息
@property (nonatomic, strong) JYWeatherBasicModel * basic;
//  daily_forecast 天气预报 7天
@property (nonatomic, strong) NSArray * daily_forecast;
//  hourly_forecast 每小时天气预报 4，每3小时
@property (nonatomic, strong) NSArray * hourly_forecast;
//  now 实况天气
@property (nonatomic, strong) JYWeatherNowModel * now;
//  suggestion 生活指数
@property (nonatomic, strong) JYWeatherSuggestionModel * suggestion;

@end



//  空气质量指数AQI
@interface JYWeatherAQICityModel :NSObject<YYModel>

@property (nonatomic, strong) JYWeatherAQIDataModel * city;

@end

@interface JYWeatherAQIDataModel :NSObject<YYModel>
/*
 "aqi": "82",
 "co": "1",
 "no2": "31",
 "o3": "58",
 "pm10": "99",
 "pm25": "60",
 "qlty": "良",
 "so2": "7"
 */
//  空气质量指数
@property (nonatomic, strong) NSString * aqi;
//  空气质量状况
@property (nonatomic, strong) NSString * qlty;
//  PM2.5情况
@property (nonatomic, strong) NSString * pm25;
//  PM10情况
@property (nonatomic, strong) NSString * pm10;
//  一氧化碳1小时平均值(ug/m³)
@property (nonatomic, strong) NSString * co;
//  二氧化硫1小时平均值(ug/m³)
@property (nonatomic, strong) NSString * so2;


@end


//  城市基本信息
@interface JYWeatherBasicModel : NSObject <YYModel>

//  城市名称
@property (nonatomic, copy) NSString * city;
//  国家名称
@property (nonatomic, copy) NSString * cnty;
//  城市id
@property (nonatomic, copy) NSString * city_id;
//  经纬度
@property (nonatomic, copy) NSString * lat;

@property (nonatomic, copy) NSString * lon;
//  更新时间

@end