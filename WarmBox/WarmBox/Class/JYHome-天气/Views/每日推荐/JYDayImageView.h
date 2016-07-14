//
//  JYDayImageView.h
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYDayImageView : UIView

//  时间
@property (nonatomic, strong) UILabel * dateMonth;
@property (nonatomic, strong) UILabel * dateDay;
//  每日一句话
@property (nonatomic, strong) UILabel * oneWord;
//  天气
@property (nonatomic, strong) UILabel * weather;
//  城市
@property (nonatomic, strong) UILabel * cityName;

- (instancetype)initWithFrame:(CGRect)frame
                     andModel:(JYWeatherModel *)model;

@end
