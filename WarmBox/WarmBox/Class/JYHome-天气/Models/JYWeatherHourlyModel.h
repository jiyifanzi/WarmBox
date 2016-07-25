//
//  JYWeatherHourlyModel.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYWeatherHourlyWindModel;


@interface JYWeatherHourlyModel : NSObject

//  时间
@property (nonatomic, copy) NSString * date;
//  湿度
@property (nonatomic, copy) NSString * hum;
//  降水概率
@property (nonatomic, copy) NSString * pop;
//  气压
@property (nonatomic, copy) NSString * pres;
//  温度
@property (nonatomic, copy) NSString * tmp;
//  风力状况
@property (nonatomic, strong) JYWeatherHourlyWindModel * wind;

@property (nonatomic,assign) NSInteger row;

@end


//  ===========风力情况
@interface JYWeatherHourlyWindModel : NSObject
//  风向 角度
@property (nonatomic, strong) NSString * deg;
//  风向 方向
@property (nonatomic, strong) NSString * dir;
//  风力等级
@property (nonatomic, strong) NSString * sc;
//  风速
@property (nonatomic, strong) NSString * spd;

@end
