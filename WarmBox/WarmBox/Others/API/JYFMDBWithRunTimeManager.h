//
//  JYFMDBWithRunTimeManager.h
//  03-JYRunTimeFMDB
//
//  Created by qianfeng on 16/6/1.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFMDBWithRunTimeManager : NSObject

+ (instancetype) defaultManager;

//  将一个对象插入到数据库中
- (void) insertObject:(id)objc;

//  获取数据
- (NSArray *) getAlldata:(Class)objc_class;


@end
