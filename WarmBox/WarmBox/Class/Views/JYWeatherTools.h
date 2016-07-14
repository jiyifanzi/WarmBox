//
//  JYWeatherTools.h
//  WarmBox
//
//  Created by qianfeng on 16/7/1.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JYWeatherTools : NSObject


//  根据传入的的天气代码，返回图片名称
+ (NSString *)getBackImageNameWithWeatherNumber:(NSString *)weatherNumber;
//  富文本排列，传入图片和文字还有字体大小，传出富文本
+ (NSAttributedString *)mixImage:(UIImage *)image
                         andText:(NSAttributedString *)text
                 andTextFontSize:(NSInteger)fontSize;

// 展示数据
+ (void)showMessageWithAlertView:(NSString *)message;

//  删除指定城市的数据，并且重新插入，把指定城市的location变成1，其他变成0
+ (void)changeCityLocationValueWithCityName:(NSString *)cityName;

//  指定日期格式，回去当前的日期
+ (NSString *)getNowDataWithFormate:(NSString *)formate;

//  获取Document/SD_WebImgae缓存的文件大小
+ (NSString *)getCacheSizeWithCacheFilePath:(NSString *)cacheFilePath;

//  从数据库获取下载的视频数据
+ (NSMutableArray *)requestVideoFromDB;

//  删除本地缓存的电影
+ (void)removeVideoFromDBWithName:(NSString *)fileName;

@end
