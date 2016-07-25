//
//  JYWeatherNewHourEverCell.m
//  WarmBox
//
//  Created by JiYi on 16/7/23.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherNewHourEverCell.h"

@interface JYWeatherNewHourEverCell ()

//  时间
@property (nonatomic, strong) UILabel * timeLabel;
//  温度的点
@property (nonatomic, strong) UIView * tmpView;
//  温度
@property (nonatomic, strong) UILabel * tmpLabel;
//  湿度
@property (strong, nonatomic) UILabel *humLabel;
//  降水概率
@property (strong, nonatomic) UILabel *popLabel;

@property (nonatomic, assign) float howLengh;

@property (nonatomic,assign) NSInteger row;
@end

@implementation JYWeatherNewHourEverCell

- (void)awakeFromNib {
    // Initialization code
    
    [self initSubView];
    
}
//  初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
//        [self initSubView];
    }
    return self;
}



#pragma mark - 初始化子控件
- (void)initSubView {
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    _timeLabel.text = @"待定";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];

    _tmpLabel = [[UILabel alloc] init];
    _tmpLabel.textColor = [UIColor whiteColor];
    _tmpLabel.font = [UIFont systemFontOfSize:15];
    _tmpLabel.text = @"待定";
    _tmpLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_tmpLabel];
    
    _humLabel = [[UILabel alloc] init];
    _humLabel.textColor = [UIColor whiteColor];
    _humLabel.font = [UIFont systemFontOfSize:11];
    _humLabel.text = @"待定";
    _humLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_humLabel];
    
    _popLabel = [[UILabel alloc] init];
    _popLabel.textColor = [UIColor whiteColor];
    _popLabel.font = [UIFont systemFontOfSize:11];
    _popLabel.text = @"待定";
    _popLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_popLabel];
    
    
//    _tmpView = [[UIView alloc] initWithFrame:CGRectMake(18, 5.5, 8, 8)];
    
    _tmpView = [[UIView alloc] init];
    _tmpView.clipsToBounds = YES;
    _tmpView.layer.cornerRadius = 4;
    _tmpView.backgroundColor = [UIColor orangeColor];
    [self addSubview:_tmpView];
    
    //  设置颜色
//    _timeLabel.backgroundColor = [UIColor redColor];
//    
//    _tmpLabel.backgroundColor = [UIColor lightGrayColor];
//
//    _humLabel.backgroundColor = [UIColor purpleColor];
//    
//    _popLabel.backgroundColor = [UIColor greenColor];
}


#pragma mark - 为子视图赋值
- (void)setModel:(JYWeatherHourlyModel *)model {
    
    _model = model;
    
    NSArray * timeArray = [model.date componentsSeparatedByString:@" "];
    _timeLabel.text = [timeArray lastObject];
    
    _tmpLabel.text = [NSString stringWithFormat:@"%@℃",model.tmp];
    
    _humLabel.text = [NSString stringWithFormat:@"湿度%@",model.hum];
    
    _popLabel.text = [NSString stringWithFormat:@"概率%@",model.pop];
    
    //  根据温度来给点设置颜色
    if (model.tmp.floatValue >= 35) {
        //  大于35度
        _tmpView.backgroundColor = [UIColor redColor];
    }else if (model.tmp.floatValue < 35 && model.tmp.floatValue >30) {
        _tmpView.backgroundColor = [UIColor orangeColor];
    }else {
        _tmpView.backgroundColor = [UIColor cyanColor];
    }
    
    _howLengh = (60 - _tmpLabel.text.floatValue) * 2.8f;
    
    _row = model.row;

}

- (void)layoutSubviews {
    //  确定位置
    [super layoutSubviews];
    
    [_timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-2);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    
    [_tmpView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(_howLengh);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [_tmpLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(_howLengh + 10);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];

    
    
    [_humLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tmpLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [_popLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_humLabel.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    //  调用几次，根据cell的个数来算
}


@end
