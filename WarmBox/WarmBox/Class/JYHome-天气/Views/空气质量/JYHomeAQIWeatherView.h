//
//  JYHomeAQIWeatherView.h
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYHomeAQIWeatherView : UIView

@property (nonatomic, strong) JYWeatherModel * model;
//  背景图片
@property (nonatomic, strong) UIImageView * backgroundImage;

- (instancetype)initWithFrame:(CGRect)frame
                     andModel:(JYWeatherModel *)model;



@end
