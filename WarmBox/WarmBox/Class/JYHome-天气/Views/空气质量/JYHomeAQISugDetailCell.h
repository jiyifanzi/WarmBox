//
//  JYHomeAQISugDetailCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/2.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeAQISugDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) JYWeatherSugDescModel * model;

@end
