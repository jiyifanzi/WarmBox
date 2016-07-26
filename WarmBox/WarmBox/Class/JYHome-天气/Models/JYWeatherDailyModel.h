//
//  JYWeatherDailyModel.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYWeatherDailyAstroModel;
@class JYWeatherDailyCondModel;
@class JYWeatherDailyTmpModel;
@class JYWeatherDailyWindModel;

//  每天的天气预报模型
@interface JYWeatherDailyModel : NSObject <NSCoding>

//  时间
@property (nonatomic, copy) NSString * date;
//  日出日落时间
@property (nonatomic, strong) JYWeatherDailyAstroModel * astro;
//  天气状况
@property (nonatomic, strong) JYWeatherDailyCondModel * cond;
//  湿度
@property (nonatomic, copy) NSString * hum;
//  降雨量
@property (nonatomic, copy) NSString * pcpn;
//  降水概率
@property (nonatomic, copy) NSString * pop;
//  气压
@property (nonatomic, copy) NSString * pres;
//  温度
@property (nonatomic, strong) JYWeatherDailyTmpModel * tmp;
//  能见度
@property (nonatomic, copy) NSString * vis;
//  风力状况
@property (nonatomic, strong) JYWeatherDailyWindModel * wind;

@end


//  ===========日出日落情况
@interface JYWeatherDailyAstroModel : NSObject<NSCoding>

//  日出时间
@property (nonatomic, strong) NSString * sr;
//  日落时间
@property (nonatomic, strong) NSString * ss;

@end



//  ===========天气情况
@interface JYWeatherDailyCondModel : NSObject<NSCoding>

//  白天天气代码
@property (nonatomic, strong) NSString * code_d;
//  夜间天气代码
@property (nonatomic, strong) NSString * code_n;
//  白天天气描述
@property (nonatomic, strong) NSString * txt_d;
//  夜间天气描述
@property (nonatomic, strong) NSString * txt_n;

@end



//  ===========温度情况
@interface JYWeatherDailyTmpModel : NSObject<NSCoding>

//  最高温度
@property (nonatomic, strong) NSString * max;
//  最低温度
@property (nonatomic, strong) NSString * min;

@end


//  ===========风力情况
@interface JYWeatherDailyWindModel : NSObject<NSCoding>
//  风向 角度
@property (nonatomic, strong) NSString * deg;
//  风向 方向
@property (nonatomic, strong) NSString * dir;
//  风力等级
@property (nonatomic, strong) NSString * sc;
//  风速
@property (nonatomic, strong) NSString * spd;

@end




