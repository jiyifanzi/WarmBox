//
//  JYHomeWeatherViewController.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"

@protocol JYHomeWeatherDelegate <NSObject>

- (void)setAqiModel:(JYWeatherModel *) model;

@end

@interface JYHomeWeatherViewController : JYBaseViewController

@property (nonatomic, strong) id <JYHomeWeatherDelegate> delegate;

@end
