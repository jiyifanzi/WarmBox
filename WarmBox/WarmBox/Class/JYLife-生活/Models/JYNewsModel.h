//
//  JYNewsModel.h
//  WarmBox
//
//  Created by qianfeng on 16/7/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYNewsModel : NSObject <YYModel>

////  标题
//@property (nonatomic, strong) NSString * title;
////  时间
//@property (nonatomic, strong) NSString * time;
////  图片
//@property (nonatomic, strong) NSString * img;
////  地址
//@property (nonatomic, strong) NSString * url;
////  作者
//@property (nonatomic, strong) NSString * author;

//  标题
@property (nonatomic, strong) NSString * title;
//  时间
@property (nonatomic, strong) NSString * lmodify;
//  图片
@property (nonatomic, strong) NSString * imgsrc;
//  地址
@property (nonatomic, strong) NSString * url;
//  作者
@property (nonatomic, strong) NSString * source;
//  id
@property (nonatomic, strong) NSString * docid;
//  3G网址
@property (nonatomic, strong) NSString * url_3w;

@end
