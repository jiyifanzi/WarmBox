//
//  JYHomeAQIDataView.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeAQIDataView.h"


@interface JYHomeAQIDataView ()

//  背景图片
@property (nonatomic, strong) UIImageView * backgroundImage;

@property (nonatomic, strong) UILabel * aqiLabel;
@property (nonatomic, strong) UILabel * qltyLabel;
@property (nonatomic, strong) UILabel * pm25Label;
@property (nonatomic, strong) UILabel * pm10Label;
@property (nonatomic, strong) UILabel * coLabel;
@property (nonatomic, strong) UILabel * so2Label;

@end


@implementation JYHomeAQIDataView

- (instancetype)initWithFrame:(CGRect)frame andModel:(JYWeatherModel *)model {
    if (self = [super initWithFrame:frame]) {
        
        //  初始化子控件
        [self initSubViews];
        self.model = model;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - 为子控件布局
- (void)layoutSubviews {
    [super layoutSubviews];
    //  背景图片
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    //  公共
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH = self.frame.size.height;
    
    CGFloat margin = 10;
    CGFloat eachMargin = 5;
    
    CGFloat eachH = (selfH - 4 * margin) / 3;
    CGFloat eachW = (selfW - 2 * margin - eachMargin) / 2;
    
    [_aqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(margin);
        make.left.equalTo(self).offset(margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
    
    [_qltyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
    
    [_pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_aqiLabel.mas_bottom).offset(margin);
        make.left.equalTo(self).offset(margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
    [_pm10Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_qltyLabel.mas_bottom).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
    
    [_coLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pm25Label.mas_bottom).offset(margin);
        make.left.equalTo(self).offset(margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
    [_so2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pm10Label.mas_bottom).offset(margin);
        make.right.equalTo(self).offset(-margin);
        make.size.mas_equalTo(CGSizeMake(eachW, eachH));
    }];
}

#pragma mark - 为各个子控件赋值
- (void)setModel:(JYWeatherModel *)model {
    _model = model;
    
    _backgroundImage.image = [UIImage imageNamed:@"hourCellBG"];
    
    if (model.aqi.city.aqi) {
        _aqiLabel.text = model.aqi.city.aqi;
    }
//    _aqiLabel.backgroundColor = [self getColorLevelWithString:_aqiLabel.text andLevelNumber:50 andStart:0];
    
    if (model.aqi.city.qlty) {
         _qltyLabel.text = model.aqi.city.qlty;
    }
//    _qltyLabel.backgroundColor = [self getColorLevelWithString:_aqiLabel.text andLevelNumber:50 andStart:0];
    
    if (model.aqi.city.pm25) {
        _pm25Label.text = model.aqi.city.pm25;
    }
//    _pm25Label.backgroundColor = [self getColorLevelWithString:_pm25Label.text andLevelNumber:35 andStart:0];
//    UIImageView * flagAQI = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    flagAQI.tintColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
//    flagAQI.image = [UIImage imageNamed:@"flag_red"];
//    flagAQI.image = [flagAQI.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UILabel * pm25 = [[UILabel alloc] init];
    pm25.frame = CGRectMake(0, 0, 45, 13);
    pm25.text = @"PM2.5";
    pm25.font = [UIFont systemFontOfSize:12.0];
    pm25.textColor = [UIColor whiteColor];
    pm25.textAlignment = NSTextAlignmentRight;
    pm25.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    [_pm25Label addSubview:pm25];
    
    
    if (model.aqi.city.pm10) {
        _pm10Label.text = model.aqi.city.pm10;
    }
//    _pm10Label.backgroundColor = [self getColorLevelWithString:_pm10Label.text andLevelNumber:40 andStart:40];
    
    if (model.aqi.city.co) {
        _coLabel.text = model.aqi.city.co;
    }
//    _coLabel.backgroundColor = [self getColorLevelWithString:_coLabel.text andLevelNumber:1 andStart:0];
    
    if (model.aqi.city.so2) {
        _so2Label.text = model.aqi.city.so2;
    }
//    _so2Label.backgroundColor = [self getColorLevelWithString:_so2Label.text andLevelNumber:15 andStart:0];
    
}
- (UIColor *)getColorLevelWithString:(NSString *)string
                      andLevelNumber:(int)levelNumber
                            andStart:(int)startNumber{
    int level = (string.floatValue - startNumber) / levelNumber;
    
    if (level > 5) {
        level = 5;
    }else {
        level = 0;
    }
    
    NSArray * colorArray = @[JYColorLevelONE, JYColorLevelTWO, JYColorLevelTHR, JYColorLevelFOU, JYColorLevelFIV, JYColorLevelSIX];

    return colorArray[level];
}

#pragma mark - 初始化子控件
- (void)initSubViews {
    _backgroundImage = [[UIImageView alloc] init];
    _backgroundImage.image = [UIImage imageNamed:@"hourCellBG"];
    [self addSubview:_backgroundImage];
    
    _aqiLabel = [[UILabel alloc] init];
    _aqiLabel.textAlignment = NSTextAlignmentCenter;
    _aqiLabel.textColor = [UIColor whiteColor];
    _aqiLabel.font = [UIFont systemFontOfSize:24];
    _aqiLabel.layer.masksToBounds = YES;
    _aqiLabel.layer.cornerRadius = 15;
    _aqiLabel.text = @"/";
    [self addSubview:_aqiLabel];
    
    _qltyLabel = [[UILabel alloc] init];
    _qltyLabel.textAlignment = NSTextAlignmentCenter;
    _qltyLabel.textColor = [UIColor whiteColor];
    _qltyLabel.font = [UIFont systemFontOfSize:24];
    _qltyLabel.layer.masksToBounds = YES;
    _qltyLabel.layer.cornerRadius = 15;
    _qltyLabel.text = @"/";
    [self addSubview:_qltyLabel];
    
    _pm25Label = [[UILabel alloc] init];
    _pm25Label.textAlignment = NSTextAlignmentCenter;
    _pm25Label.textColor = [UIColor whiteColor];
    _pm25Label.font = [UIFont systemFontOfSize:24];
    _pm25Label.layer.masksToBounds = YES;
    _pm25Label.layer.cornerRadius = 15;
    _pm25Label.text = @"/";
    [self addSubview:_pm25Label];
    
    _pm10Label =[[UILabel alloc] init];
    _pm10Label.textAlignment = NSTextAlignmentCenter;
    _pm10Label.textColor = [UIColor whiteColor];
    _pm10Label.font = [UIFont systemFontOfSize:24];
    _pm10Label.layer.masksToBounds = YES;
    _pm10Label.layer.cornerRadius = 15;
    _pm10Label.text = @"/";
    [self addSubview:_pm10Label];
    
    _coLabel = [[UILabel alloc] init];
    _coLabel.textAlignment = NSTextAlignmentCenter;
    _coLabel.textColor = [UIColor whiteColor];
    _coLabel.font = [UIFont systemFontOfSize:24];
    _coLabel.layer.masksToBounds = YES;
    _coLabel.layer.cornerRadius = 15;
    _coLabel.text = @"/";
    [self addSubview:_coLabel];
    
    _so2Label = [[UILabel alloc] init];
    _so2Label.textAlignment = NSTextAlignmentCenter;
    _so2Label.textColor = [UIColor whiteColor];
    _so2Label.font = [UIFont systemFontOfSize:24];
    _so2Label.layer.masksToBounds = YES;
    _so2Label.layer.cornerRadius = 15;
    _so2Label.text = @"/";
    [self addSubview:_so2Label];
}

@end
