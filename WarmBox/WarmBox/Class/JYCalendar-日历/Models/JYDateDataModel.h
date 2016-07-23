//
//  JYDateDataModel.h
//  WarmBox
//
//  Created by qianfeng on 16/7/4.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYDateDataModel : NSObject


//  类型
@property (nonatomic, strong) NSString * noteType;
//  时间
@property (nonatomic, strong) NSString * nowTime;
//  当前时间
@property (nonatomic, strong) NSString * date;
//  当前标题
@property (nonatomic, strong) NSString * title;
//  当前内容
@property (nonatomic, strong) NSAttributedString * content;

@end
