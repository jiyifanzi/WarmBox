//
//  JYFMDBWithRunTimeManager.m
//  03-JYRunTimeFMDB
//
//  Created by qianfeng on 16/6/1.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYFMDBWithRunTimeManager.h"
#import "FMDatabase.h"
//  使用runtime，需要导入这个文件
#import <objc/runtime.h>

@interface JYFMDBWithRunTimeManager()

@property (nonatomic, strong)FMDatabase * dataBase;

@end
@implementation JYFMDBWithRunTimeManager


+ (instancetype)defaultManager {
    JYFMDBWithRunTimeManager * manager = nil;
    if (manager == nil) {
        manager = [[JYFMDBWithRunTimeManager alloc] init];
    }
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //  打开数据库
        [self openSqlite];
    }
    return self;
}

#pragma mark - 打开数据库
- (void) openSqlite {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/User.db"];
    _dataBase = [[FMDatabase alloc] initWithPath:path];
    if ([_dataBase open]) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
}
#pragma mark - 创建表
- (void) creatTableWithClass:(Class)objcClass {
    //  通过类 去获取类的属性 RunTime
    //  objc_property_t 属性
    
    //  动态获取一个类的类名 const char *class_getName(Class cls)
    const char * className = class_getName(objcClass);
    
    //  获取所有的属性名
    NSArray * allName = [self getAllPropertyNameWithClass:objcClass];
    
    //  ========================创建表
    //  1.创建sql语句
    //NSString * sql = @"CREATE TABLE IF NOT EXISTS ? (id integer PRIMARY KEY AUTOINCREMENT ?);";
    //  表名
    NSString * tableName = [NSString stringWithUTF8String:className];
    //NSLog(@"%@",tableName);
    //  字段列表
    NSMutableString * str = [NSMutableString string];
    for (NSString * name in allName) {
        [str appendFormat:@",%@",name];
    }
    NSString * newSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT %@);",tableName, str];
    
    //  2.执行sql语句
    if ([_dataBase executeUpdate:newSql]) {
        NSLog(@"创建表成功");
    }else {
        NSLog(@"创建表失败");
    }
}

#pragma mark - 通过类获取类中的所有属性名
- (NSArray *) getAllPropertyNameWithClass:(Class)objcClass {
    //  获取类中所有的属性 objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)
    /*
     参数1：类
     参数2：用来获取属性的个数
     */
    unsigned int outCount;
    objc_property_t * propertyLists = class_copyPropertyList(objcClass, &outCount);
    
    /*
     int a[10];
     int *p = a;
     p[1];
     */
    //  创建可变数组，用来存储类的属性名字
    NSMutableArray * propertyName = [NSMutableArray array];
    
    //  遍历获取所有的属性
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = propertyLists[i];
        //  获取属性的名字 property_getName
        const char * name = property_getName(property);
        
        //  获取属性的类型
        //property_getAttributes(property);
        
        //  将属性名转换成OC字符串存到数组中
        [propertyName addObject:[NSString stringWithUTF8String:name]];
    }
    
    return propertyName;
}


//  将数据插入到数据库中
- (void)insertObject:(id)objc {
    //  创建表
    //  对象调用class可以获取对象的类型
    [self creatTableWithClass:[objc class]];
    
    //  插入数据
    //  INSERT INTO t_Person(name, age, sex) VALUES ('小明',20,'男');
    //  表名
    const char * className = class_getName([objc class]);
    
    //  3.获取所有的属性名
    NSArray * perportyNames = [self getAllPropertyNameWithClass:[objc class]];
    
    //  遍历数组
    int i = 0;
    NSMutableString * mkey = [NSMutableString string];
    NSMutableString * mvalue = [NSMutableString string];
    
    for (NSString * name in perportyNames) {
        //  通过KVC赋值
        id value = [objc valueForKey:name];
        NSString * valueStr = [NSString stringWithFormat:@"'%@'",value];
        
        
        //  如果是最后一个字段，不用拼接逗号
        if (i == perportyNames.count - 1) {
            [mkey appendString:name];
            //  获取属性的值 - KVC
            [mvalue appendString:valueStr];
            
        }else {
            [mkey appendFormat:@"%@,",name];
            [mvalue appendFormat:@"%@,",valueStr];
        }
        i++;
    }
    
    NSLog(@"%@ %@",mkey, mvalue);
    //  拼接sql
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %s(%@) VALUES (%@);",className, mkey, mvalue];
    
    if ([_dataBase executeUpdate:sql]) {
        NSLog(@"数据插入成功");
    }
    else {
        NSLog(@"数据插入失败");
    }
}

#pragma mark - 获取数据库中的数据
//  获取指定类型的所有的数据(获取指定表中的数据)
- (NSArray *)getAlldata:(Class)objc_class {
    //  SELECT * FROM t_Person;
    //  获取表名
    const char * className = class_getName(objc_class);
    
    //  1.创建sql语句
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %s;",className];
    
    NSLog(@"%@",sql);
    
    //  2.执行sql
    FMResultSet * ret = [_dataBase executeQuery:sql];
    if (ret) {
        NSLog(@"查询成功");
        //  创建可变数组
        NSMutableArray * arr = [NSMutableArray array];
        
        while ([ret next]) {
            //  创建对象
            id objc = [objc_class new];

            for (NSString * name in [self getAllPropertyNameWithClass:objc_class]) {
                //  每个属性对应的值
                id value = [ret objectForColumnName:name];
                //  给对象的属性赋值
                [objc setValue:value forKey:name];
            }
            [arr addObject:objc];
        }
        
        return arr;
        
    }else {
        NSLog(@"查询失败");
        return nil;
    }
    
}


@end
