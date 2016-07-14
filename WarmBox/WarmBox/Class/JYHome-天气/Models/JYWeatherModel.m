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

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"daily_forecast":[JYWeatherDailyModel class], @"hourly_forecast":[JYWeatherHourlyModel class]};
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end


@implementation JYWeatherBasicModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"city_id":@"id"};
}

@end

@implementation JYWeatherAQICityModel


@end



@implementation JYWeatherAQIDataModel

@end