//
//  JYBasicDataManager.h
//  JYFreeLimit
//
//  Created by qianfeng on 16/6/18.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYWeatherModel.h"

@interface JYBasicDataManager : NSObject

//  =========城市数据库
//  1.将模型插入到数据库
- (void)insertDataWithCityName:(NSString *)city
                   andLocation:(NSString *)location;

//  2.判断指定的数据是否存在
- (BOOL)checkIsInDBWithCityName:(NSString *)city;

//  2.判断指定的数据是否存在 -- 找出定位的数据
- (NSString *)findLocationInDB;

//  3.获取数据库中所有的数据
- (NSArray *)getAllData;

//  

//  4.删除指定的数据
- (void)deleteDataWithCityName:(NSString *)city;

//  =========日程数据库
- (void)insertDateWithDate:(NSString *)date
                  andTitle:(NSString *)title
                andContent:(NSAttributedString *)content;
//  不需要检查
//  获取数据库中的数据 - 按照时间
- (NSArray *)getDataWithDate:(NSString *)date;
//  删除数据
- (void)deleteDataWithTitle:(NSString *)title
                   WithDate:(NSString *)date;
//  判断数据是否存在
- (BOOL)checkIsInDBWithTitle:(NSString *)title
                     andDate:(NSString *)date;
//  获取数据库的所有数据
- (NSArray *)getAllDataInDateDB;

@end
