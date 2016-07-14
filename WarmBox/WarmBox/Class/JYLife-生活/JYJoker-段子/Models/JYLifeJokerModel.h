//
//  JYLifeJokerModel.h
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLifeJokerModel : NSObject

//  内容digest
@property (nonatomic, strong) NSString * digest;
//  吐槽downTimes
@property (nonatomic, strong) NSString * downTimes;
//  点赞upTimes
@property (nonatomic, strong) NSString * upTimes;
//  来源source
@property (nonatomic, strong) NSString * source;
//  标题title
@property (nonatomic, strong) NSString * title;
//  图片img
@property (nonatomic, strong) NSString * img;
//  图片的宽高
@property (nonatomic, strong) NSString * pixel;

//  cell的高度
@property (nonatomic, assign) CGFloat  cellH;

@end
