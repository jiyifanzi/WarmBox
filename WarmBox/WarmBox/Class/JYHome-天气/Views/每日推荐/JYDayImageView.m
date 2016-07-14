//
//  JYDayImageView.m
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYDayImageView.h"

@implementation JYDayImageView

-(instancetype)initWithFrame:(CGRect)frame andModel:(JYWeatherModel *)model {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        //  初始化子控件
        [self initSubViews];
    }
    return self;
}


#pragma mark - 初始化子控件
- (void)initSubViews {
    _dateMonth = [[UILabel alloc] init];
    _dateMonth.font = [UIFont systemFontOfSize:30];
    _dateMonth.textColor = [UIColor whiteColor];
    [self addSubview:_dateMonth];
    
    _dateDay = [[UILabel alloc] init];
    _dateDay.font = [UIFont systemFontOfSize:90];
    _dateDay.textColor = [UIColor whiteColor];
    _dateDay.textAlignment = NSTextAlignmentJustified;
    [self addSubview:_dateDay];
    
    _oneWord = [[UILabel alloc] init];
    _oneWord.textColor = [UIColor whiteColor];
    [self addSubview:_oneWord];
    
    _weather = [[UILabel alloc] init];
    _weather.textColor = [UIColor whiteColor];
    _weather.font = [UIFont systemFontOfSize:30];
    [self addSubview:_weather];
    
    _cityName = [[UILabel alloc] init];
    _cityName.textColor = [UIColor whiteColor];
    _cityName.font = [UIFont systemFontOfSize:30];
    [self addSubview:_cityName];
}

#pragma mark - 计算子视图的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //  1.天
    [_dateDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    //  2.月
    [_dateMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_dateDay);
        make.left.equalTo(_dateDay.mas_right);
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    //  城市
    [_cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_dateMonth);
        make.left.equalTo(_dateMonth.mas_right);
        CGRect frame = [_cityName.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} context:nil];
        
        make.size.mas_equalTo(CGSizeMake(frame.size.width, 30));
    }];
    //  天气
    [_weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_cityName);
        make.left.equalTo(_cityName.mas_right);
        CGRect frame = [_weather.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} context:nil];
        make.size.mas_equalTo(CGSizeMake(frame.size.width, 30));
    }];
    
    
    
    //  3.一句话
    [_oneWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateDay.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 30));
    }];

}

@end
