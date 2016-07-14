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
//  湿度
@property (strong, nonatomic)  UILabel * windLabel;

@property (strong, nonatomic)  UILabel * weather;

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
    _tmpLabel.font = [UIFont systemFontOfSize:30];
    _tmpLabel.text = @"NA/℃";
    [self addSubview:_tmpLabel];
    
    _windLabel = [[UILabel alloc] init];
    _windLabel.textColor = [UIColor whiteColor];
    _windLabel.font = [UIFont systemFontOfSize:30];
    _windLabel.text = @"/";
    [self addSubview:_windLabel];
    
    _weather = [[UILabel alloc] init];
    _weather.textColor = [UIColor whiteColor];
    _weather.font = [UIFont systemFontOfSize:45];
    _weather.text = @"/";
    [self addSubview:_weather];
}

#pragma mark - 布局子控件

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //  布局子空间
    [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(- 30 - 40);
        make.left.equalTo(self).offset(10);
        //  获取值
        CGRect cityText = [_cityNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 50));
    }];
    
    [_weather mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityNameLabel);
        make.left.equalTo(_cityNameLabel.mas_right).offset(10);
        //  获取值
        CGRect cityText = [_weather.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 50));
    }];
    
    [_tmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cityNameLabel.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        //  获取值
        CGRect cityText = [_tmpLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 30));
    }];
    
    [_windLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tmpLabel);
        make.left.equalTo(_tmpLabel.mas_right).offset(10);
        //  获取值
        CGRect cityText = [_windLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:50]} context:nil];
        make.size.mas_equalTo(CGSizeMake(cityText.size.width, 30));
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
    _windLabel.text = [NSString stringWithFormat:@"%@%%",model.now.hum];
    
//    _tmpLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_tmp"] andText:model.now.tmp];
//    _windLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_hum"] andText:model.now.hum];
//    
    _weather.text = model.now.cond.txt;
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
