//
//  JYWeatherEverDayCell.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherEverDayCell.h"

@interface JYWeatherEverDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage_d;
@property (weak, nonatomic) IBOutlet UILabel *textLabel_d;
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel_m;

@property (weak, nonatomic) IBOutlet UILabel *tmpLabel_min;
@property (weak, nonatomic) IBOutlet UILabel *textLabel_n;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage_n;


@end

@implementation JYWeatherEverDayCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(JYWeatherDailyModel *)model {
    _model = model;
    
    //  根据model来赋值
    _dataLabel.text = model.date;
    
    [_weatherImage_d sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:WB_WeatherTopView,model.cond.code_d]] placeholderImage:nil];
    _weatherImage_d.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    _weatherImage_d.layer.masksToBounds = YES;
    _weatherImage_d.layer.cornerRadius = 25;
    
    _textLabel_d.text = model.cond.txt_d;
    
    _tmpLabel_m.text = model.tmp.max;
    _tmpLabel_min.text = model.tmp.min;
    
    _textLabel_n.text = model.cond.txt_n;
    [_weatherImage_n sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:WB_WeatherTopView,model.cond.code_n]] placeholderImage:nil];
    _weatherImage_n.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    _weatherImage_n.layer.masksToBounds = YES;
    _weatherImage_n.layer.cornerRadius = 25;
}


@end
