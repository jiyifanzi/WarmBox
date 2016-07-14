//
//  JYWeatherHourCell.h
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYWeatherHourCell : UITableViewCell

@property (nonatomic, strong) JYWeatherHourlyModel * hourlyModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end
