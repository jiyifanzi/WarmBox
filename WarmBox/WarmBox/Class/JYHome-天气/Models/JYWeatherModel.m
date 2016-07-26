//
//  JYWeatherModel.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherModel.h"
#import "JYWeatherSuggestionModel.h"
#import "JYWeatherDailyModel.h"
#import "JYWeatherHourlyModel.h"


@implementation JYWeatherModel

//  归档 - 对属性进行编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_aqi forKey:@"aqi"];
    [aCoder encodeObject:_basic forKey:@"basic"];
    [aCoder encodeObject:_daily_forecast forKey:@"daily_forecast"];
    [aCoder encodeObject:_hourly_forecast forKey:@"hourly_forecast"];
    [aCoder encodeObject:_now forKey:@"now"];
    [aCoder encodeObject:_suggestion forKey:@"suggestion"];
}
//  解归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _aqi = [aDecoder decodeObjectForKey:@"aqi"];
        _basic = [aDecoder decodeObjectForKey:@"basic"];
        _daily_forecast = [aDecoder decodeObjectForKey:@"daily_forecast"];
        _hourly_forecast = [aDecoder decodeObjectForKey:@"hourly_forecast"];
        _now = [aDecoder decodeObjectForKey:@"now"];
        _suggestion = [aDecoder decodeObjectForKey:@"suggestion"];
    }
    return self;
}



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"daily_forecast":[JYWeatherDailyModel class], @"hourly_forecast":[JYWeatherHourlyModel class]};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end



@implementation JYWeatherBasicModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_cnty forKey:@"cnty"];
    [aCoder encodeObject:_city_id forKey:@"city_id"];
    [aCoder encodeObject:_lat forKey:@"lat"];
    [aCoder encodeObject:_lon forKey:@"lon"];
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _city = [aDecoder decodeObjectForKey:@"city"];
        _cnty = [aDecoder decodeObjectForKey:@"cnty"];
        _city_id = [aDecoder decodeObjectForKey:@"city_id"];
        _lat = [aDecoder decodeObjectForKey:@"lat"];
        _lon = [aDecoder decodeObjectForKey:@"lon"];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"city_id":@"id"};
}

@end

@implementation JYWeatherAQICityModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_city forKey:@"city"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _city = [aDecoder decodeObjectForKey:@"city"];
    }
    return self;
}

@end



@implementation JYWeatherAQIDataModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_aqi forKey:@"aqi"];
    [aCoder encodeObject:_qlty forKey:@"qlty"];
    [aCoder encodeObject:_pm25 forKey:@"pm25"];
    [aCoder encodeObject:_pm10 forKey:@"pm10"];
    [aCoder encodeObject:_co forKey:@"co"];
    [aCoder encodeObject:_so2 forKey:@"so2"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _aqi = [aDecoder decodeObjectForKey:@"aqi"];
        _qlty = [aDecoder decodeObjectForKey:@"qlty"];
        _pm25 = [aDecoder decodeObjectForKey:@"pm25"];
        _pm10 = [aDecoder decodeObjectForKey:@"pm10"];
        _co = [aDecoder decodeObjectForKey:@"co"];
        _so2 = [aDecoder decodeObjectForKey:@"so2"];
    }
    return self;
}

@end



