//
//  JYHomeAQIWeatherView.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeAQIWeatherView.h"

@interface JYHomeAQIWeatherView ()


//  背景图片
//@property (nonatomic, strong) UIImageView * backgroundImage;
//  天气图片
@property (nonatomic, strong) UIImageView * weatherImage;
//  城市名称
@property (nonatomic, strong) UILabel * cityNameLabel;
//  温度
@property (nonatomic, strong) UILabel * tmpLabel;
//  风向
@property (nonatomic, strong) UILabel * windDirLabel;

@end


@implementation JYHomeAQIWeatherView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andModel:(JYWeatherModel *)model {
    if (self = [super initWithFrame:frame]) {
        //  初始化子控件
        [self initSubViews];
        self.model = model;
    }
    return self;
}

#pragma mark - 设置位置
- (void)layoutSubviews {
    [super layoutSubviews];
    //  设置位置
    
    //  背景图片
    [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //  天气图片
    [_weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        CGFloat weatherH = self.frame.size.height - 2 * 10;
        make.size.mas_equalTo(CGSizeMake(weatherH, weatherH));
    }];
    
    //  城市名称
    [_cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weatherImage.mas_right).offset(5);
        make.top.equalTo(self.mas_top).offset(10);
        CGFloat cityH = self.frame.size.height -2 * 10;
        CGRect cityText = [_cityNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, cityH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, cityH));
    }];
    //  温度
    [_tmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityNameLabel.mas_right).offset(5);
        make.top.equalTo(self).offset(10);
        CGFloat tmpH = self.frame.size.height -2 * 10;
        CGRect tmpText = [_windDirLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, tmpH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]} context:nil];

        make.size.mas_equalTo(CGSizeMake(tmpText.size.width, tmpH));
    }];
    
    //  风向
    [_windDirLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tmpLabel.mas_right).offset(5);
        make.top.equalTo(self).offset(10);
        CGFloat windH = self.frame.size.height -2 * 10;
        //  根据文字来设置宽度
        CGRect windText = [_windDirLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, windH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]} context:nil];
        make.size.mas_equalTo(CGSizeMake(windText.size.width, windH));
    }];
}

#pragma mark - 为各个子控件赋值
- (void)setModel:(JYWeatherModel *)model {
    _model = model;
    
    _backgroundImage.image = [UIImage imageNamed:@"hourCellBG"];
    
    
    _weatherImage.tintColor = [UIColor whiteColor];
    
    _weatherImage.image = [_weatherImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
//    [_weatherImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:WB_WeatherTopView,model.now.cond.code]] placeholderImage:nil];
    [_weatherImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:WB_WeatherTopView,model.now.cond.code]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _weatherImage.contentMode = UIViewContentModeScaleAspectFill;
        
        _weatherImage.tintColor = [UIColor whiteColor];
        _weatherImage.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }];
    
    _weatherImage.image = [_weatherImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    
    _cityNameLabel.text = model.basic.city;
    
    _tmpLabel.text = [NSString stringWithFormat:@"%@℃",model.now.tmp];
    
    _windDirLabel.text = model.now.wind.dir;
}

#pragma mark - 初始化子控件
- (void)initSubViews {
    _backgroundImage = [[UIImageView alloc] init];
    _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:_backgroundImage];
    
    _weatherImage = [[UIImageView alloc] init];
    [self addSubview:_weatherImage];
    
    _cityNameLabel = [[UILabel alloc] init];
    _cityNameLabel.font = [UIFont systemFontOfSize:24];
    _cityNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_cityNameLabel];
    
    _tmpLabel = [[UILabel alloc] init];
    _tmpLabel.font = [UIFont systemFontOfSize:24];
    _tmpLabel.textColor = [UIColor whiteColor];
    [self addSubview:_tmpLabel];
    
    _windDirLabel = [[UILabel alloc] init];
    _windDirLabel.font = [UIFont systemFontOfSize:24];
    _windDirLabel.textColor = [UIColor whiteColor];
    [self addSubview:_windDirLabel];
}

@end
