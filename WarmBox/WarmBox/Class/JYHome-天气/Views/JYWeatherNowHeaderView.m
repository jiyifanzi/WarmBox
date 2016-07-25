//
//  JYWeatherNowHeaderView.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherNowHeaderView.h"

@interface JYWeatherNowHeaderView()

//  背景图片
@property (strong, nonatomic)  UIImageView * backgroundImageView;
//  城市名称
@property (strong, nonatomic)  UILabel * cityNameLabel;
//  温度
@property (strong, nonatomic)  UILabel * tmpLabel;
//  风向
@property (strong, nonatomic)  UILabel * windLabel;
//  天气
@property (strong, nonatomic)  UILabel * weather;

//  湿度
@property (strong, nonatomic)  UILabel * humLabel;
//  降雨量
@property (strong, nonatomic)  UILabel * pcpnLabel;


/*
 "aqi": "43",
 "co": "1",
 "no2": "30",
 "o3": "21",
 "pm10": "42",
 "pm25": "26",
 "qlty": "优",
 "so2": "12"
 */
//  =========AQI信息
//  空气质量指数
@property (nonatomic, strong) UILabel * aqiLabel;
//  空气质量类别
@property (nonatomic, strong) UILabel * qltyLabel;
//  PM25参数
@property (nonatomic, strong) UILabel * pm25Label;

@end


@implementation JYWeatherNowHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     andModel:(JYWeatherModel *)model {
    if (self = [super initWithFrame:frame]) {
        
        //  初始化子控件
        [self initSubViews];
        
        self.model = model;
    }
    return self;
}
#pragma mark - 初始化子控件
- (void)initSubViews {

    _backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:_backgroundImageView];
    
    _cityNameLabel = [[UILabel alloc] init];
    _cityNameLabel.textColor = [UIColor whiteColor];
    _cityNameLabel.font = [UIFont systemFontOfSize:45];
    _cityNameLabel.text = [[JYBasicDataManager new] findLocationInDB];

//    NSArray * dataArray = [[JYBasicDataManager new] getAllData];
//    NSMutableArray * dataArrFor = [NSMutableArray array];
//    for (NSString * tempStr in dataArray) {
//        NSArray *seqArr = [tempStr componentsSeparatedByString:@"+"];
//        [dataArrFor addObject:[seqArr firstObject]];
//    }
    
    [self addSubview:_cityNameLabel];
    
    _tmpLabel = [[UILabel alloc] init];
    _tmpLabel.textColor = [UIColor whiteColor];
    _tmpLabel.font = [UIFont systemFontOfSize:45];
    _tmpLabel.text = @"NA/℃";
    [self addSubview:_tmpLabel];
    
    _windLabel = [[UILabel alloc] init];
    _windLabel.textColor = [UIColor whiteColor];
    _windLabel.font = [UIFont systemFontOfSize:15];
//    _windLabel.text = @"/";
    [self addSubview:_windLabel];
    
    _weather = [[UILabel alloc] init];
    _weather.textColor = [UIColor whiteColor];
    _weather.font = [UIFont systemFontOfSize:45];
    _weather.text = @"/";
    [self addSubview:_weather];
    
    
    _humLabel = [[UILabel alloc] init];
    _humLabel.textColor = [UIColor whiteColor];
    _humLabel.font = [UIFont systemFontOfSize:15];
//    _humLabel.text = @"/";
    [self addSubview:_humLabel];
    
    _pcpnLabel = [[UILabel alloc] init];
    _pcpnLabel.textColor = [UIColor whiteColor];
    _pcpnLabel.font = [UIFont systemFontOfSize:15];
//    _pcpnLabel.text = @"/";
    [self addSubview:_pcpnLabel];
    
    
    _aqiLabel = [[UILabel alloc] init];
    _aqiLabel.textColor = [UIColor whiteColor];
    _aqiLabel.font = [UIFont systemFontOfSize:15];
    _aqiLabel.text = @"加载中";
    [self addSubview:_aqiLabel];
    
    _qltyLabel = [[UILabel alloc] init];
    _qltyLabel.textColor = [UIColor whiteColor];
    _qltyLabel.font = [UIFont systemFontOfSize:15];
//    _qltyLabel.text = @"/";
    [self addSubview:_qltyLabel];
    
    _pm25Label = [[UILabel alloc] init];
    _pm25Label.textColor = [UIColor whiteColor];
    _pm25Label.font = [UIFont systemFontOfSize:15];
//    _pm25Label.text = @"/";
    [self addSubview:_pm25Label];
    
//    _cityNameLabel.backgroundColor = [UIColor redColor];
//    _weather.backgroundColor = [UIColor yellowColor];
//    _tmpLabel.backgroundColor = [UIColor greenColor];
//    _windLabel.backgroundColor = [UIColor purpleColor];
//    _humLabel.backgroundColor = [UIColor orangeColor];
//    _pcpnLabel.backgroundColor = [UIColor blackColor];
//    
//    _pm25Label.backgroundColor = [UIColor redColor];
}

#pragma mark - 布局子控件

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //  布局子空间
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-40 - 30);
        make.left.equalTo(self).offset(10);
        //  获取值
        CGRect cityText = [_cityNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 50));
    }];
    
    [_weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityNameLabel.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        //  获取值
        CGRect cityText = [_weather.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 50));
    }];
    
    
    [_tmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weather);
        make.left.equalTo(_weather.mas_right).offset(10);
        //  获取值
        CGRect cityText = [_tmpLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 50));
    }];
    
    
    [_windLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weather.mas_bottom);
        make.left.equalTo(self.mas_left).offset(10);
        //  获取值
        CGRect cityText = [_windLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 15));
    }];
    
    [_humLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weather.mas_bottom);
        make.left.equalTo(_windLabel.mas_right).offset(10);
        //  获取值
        CGRect cityText = [_humLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 15));
    }];
    
    //  降水量
    
    [_pcpnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weather.mas_bottom);
        make.left.equalTo(_humLabel.mas_right).offset(10);
        //  获取值
        CGRect cityText = [_pcpnLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 15));
    }];
    
    
    //  ========AQI指数
    [_pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(5);
        //  获取值
        CGRect cityText = [_pm25Label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 15));
    }];
    
    
    
}

- (void)setModel:(JYWeatherModel *)model {
    _model = model;
    
//    CGFloat imageCode = model.now.cond.code.floatValue;
//    NSString * imageName = [JYWeatherTools getBackImageNameWithWeatherNumber:model.now.cond.code];
    
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //_backgroundImageView.image = [UIImage imageNamed:imageName];
    
    
    _cityNameLabel.text = model.basic.city;
    
    _tmpLabel.text = [NSString stringWithFormat:@"%@℃",model.now.tmp];
    
    _windLabel.text = [NSString stringWithFormat:@"%@",model.now.wind.dir];
    
//    _tmpLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_tmp"] andText:model.now.tmp];
//    _windLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_hum"] andText:model.now.hum];
//    
    _weather.text = model.now.cond.txt;
    
    _humLabel.text = [NSString stringWithFormat:@"湿度%@",model.now.hum];
    
    _pcpnLabel.text = [NSString stringWithFormat:@"降雨量%@毫米",model.now.pcpn];
    
    
    
    //  =======AQI
    if (model.aqi.city.pm25.length == 0) {
         _pm25Label.text = [NSString stringWithFormat:@"PM2.5 | "];
    }else {
        
        _pm25Label.text = [NSString stringWithFormat:@"PM2.5 | %@ %@",model.aqi.city.pm25, model.aqi.city.qlty];
    }
    
    
}

- (NSAttributedString *)mixImage:(UIImage *)image andText:(NSString *)text
{
    // 用富文本实现图文混排
    // 将图片转换为文本附件对象
    NSTextAttachment * commentAttachment = [[NSTextAttachment alloc] init];
    commentAttachment.image = image;
    // 将文本附件对象转换为富文本
    NSAttributedString * commentAttachAttr = [NSAttributedString attributedStringWithAttachment:commentAttachment];
    // 将文字转换为富文本
    NSAttributedString * commentCountAttr = [[NSAttributedString alloc] initWithString:text  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    // 拼接所有富文本
    NSMutableAttributedString * commentAttr = [[NSMutableAttributedString alloc] init];
    [commentAttr appendAttributedString:commentAttachAttr];
    [commentAttr appendAttributedString:commentCountAttr];
    return [commentAttr copy];
}


@end
