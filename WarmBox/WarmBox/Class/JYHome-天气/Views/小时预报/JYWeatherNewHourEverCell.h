//
//  JYWeatherNewHourEverCell.h
//  WarmBox
//
//  Created by JiYi on 16/7/23.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYWeatherNewHourEverCell : UICollectionViewCell

@property (nonatomic, strong) JYWeatherHourlyModel * model;

@property (nonatomic, assign) CGPoint nextPoint;

@end
