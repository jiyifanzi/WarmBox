//
//  JYMeCityCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/1.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYMeCityCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (nonatomic, strong) NSString * cityName;

@property (weak, nonatomic) IBOutlet UIImageView *location;

@property (nonatomic, strong) JYWeatherModel * model;

@end
