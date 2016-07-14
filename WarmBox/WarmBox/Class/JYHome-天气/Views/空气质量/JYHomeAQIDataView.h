//
//  JYHomeAQIDataView.h
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeAQIDataView : UIView

@property (nonatomic, strong) JYWeatherModel * model;

- (instancetype)initWithFrame:(CGRect)frame
                     andModel:(JYWeatherModel *)model;

@end
