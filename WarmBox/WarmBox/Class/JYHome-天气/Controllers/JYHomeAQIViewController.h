//
//  JYHomeAQIViewController.h
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"
#import "JYHomeWeatherViewController.h"

@interface JYHomeAQIViewController : JYBaseViewController<JYHomeWeatherDelegate>

//  本界面的数据不需要重新做网络请求，直接从天气界面获取
@property (nonatomic, strong) JYWeatherModel * model;

- (void)requestDayImageWithDate:(NSString *)date;

@end
