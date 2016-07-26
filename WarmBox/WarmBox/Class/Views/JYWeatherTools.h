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



//  ==========日记操作
//  获取远程端的所有日记数据
+ (void)getAllNoteData;

//  上传本地的未上传的缓存数据到云端
+ (void)pushAllNoteData;

//  删除本地Doucument下面的所有日记
+ (void)removeAllNoteFromDB;

//  上传本地Doucument的笔记缓存下面的数据(主要是针对于网络的缓存)
+ (void)removeAllNoteDelateCatch;




//  ==========常用正则
//  是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


//  ==========天气界面缓存

@end
