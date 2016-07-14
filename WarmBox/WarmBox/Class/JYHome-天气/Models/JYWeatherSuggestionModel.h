//
//  JYWeatherSuggestionModel.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYWeatherSugDescModel;


@interface JYWeatherSuggestionModel : NSObject

//  舒适程度
@property (nonatomic, strong) JYWeatherSugDescModel * comf;
//  洗车指数
@property (nonatomic, strong) JYWeatherSugDescModel * cw;
//  穿衣指数
@property (nonatomic, strong) JYWeatherSugDescModel * drsg;
//  感冒指数
@property (nonatomic, strong) JYWeatherSugDescModel * flu;
//  运动指数
@property (nonatomic, strong) JYWeatherSugDescModel * sport;
//  旅游指数
@property (nonatomic, strong) JYWeatherSugDescModel * trav;
//  紫外线指数
@property (nonatomic, strong) JYWeatherSugDescModel * uv;


@end


@interface JYWeatherSugDescModel : NSObject

//  简介
@property (nonatomic, strong) NSString * brf;
//  详情
@property (nonatomic, strong) NSString * txt;

@end