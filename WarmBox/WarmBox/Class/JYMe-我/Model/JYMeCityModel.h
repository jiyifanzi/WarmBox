//
//  JYMeCityModel.h
//  WarmBox
//
//  Created by qianfeng on 16/7/2.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYMeCityModel : NSObject

//"city" : "乌恰",
//"cnty" : "中国",
//"id" : "CN101131502",
//"lat" : "39.430000",
//"lon" : "75.150000",
//"prov" : "新疆"
//  城市
@property (nonatomic, strong) NSString * city;
//  国家
@property (nonatomic, strong) NSString * cnty;
//  id
//@property (nonatomic, strong) NSString * my_id;
//  省份
@property (nonatomic, strong) NSString * prov;

@end
