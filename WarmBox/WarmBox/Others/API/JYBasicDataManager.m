//
//  JYBasicDataManager.m
//  JYFreeLimit
//
//  Created by qianfeng on 16/6/18.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYBasicDataManager.h"

@interface JYBasicDataManager()

//  数据库对象
@property (nonatomic, strong) FMDatabase * db;

@end

@implementation JYBasicDataManager

#pragma mark - 懒加载
- (FMDatabase *)db {
    if (!_db) {
        //  获取数据库路径
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/User.db"];
        //  创建数据库对象
        _db = [[FMDatabase alloc] initWithPath:path];
        
        //  打开数据库
        BOOL ret = [_db open];
        
        if (ret) {
            NSLog(@"数据库打开成功");
            
            //  创建表单
            [self creatTable];
            [self creatDateTable];
        }
        else {
            NSLog(@"打开失败");
        }
    }
    return _db;
}

#pragma mark - 创建表单
- (void)creatTable {
    //  1.创建sql语句
    NSString * sql = @"CREATE TABLE IF NOT EXISTS t_appTable(id integer PRIMARY KEY AUTOINCREMENT, city text UNIQUE, location text);";
    //  2.执行sql语句
    BOOL ret = [_db executeUpdate:sql];
    
    if (ret) {
        NSLog(@"创建城市表成功");
    }else {
        NSLog(@"创建城市表失败");
    }
}

#pragma mark - 插入数据
- (void)insertDataWithCityName:(NSString *)city andLocation:(NSString *)location{
    //  1.sql语句
    NSString * sql = @"INSERT INTO t_appTable(city,location) VALUES (?,?);";
    
    //  2.执行sql语句
    BOOL ret = [self.db executeUpdate:sql,city,location];
    
    if (ret) {
        NSLog(@"插入成功");
        
    }else {
        NSLog(@"插入失败");
    }
}


#pragma mark - 检查指定的数据是否已经收藏
- (BOOL)checkIsInDBWithCityName:(NSString *)city {
    //  1.sql语句
    NSString * sql = @"SELECT count(*) FROM t_appTable WHERE city = ?;";
    
    FMResultSet * set = [self.db executeQuery:sql,city];
    
    while ([set next]) {
        //  获取结果
        int count = [set intForColumnIndex:0];
        if (count > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)findLocationInDB{
    NSString * sql = @"SELECT * FROM t_appTable WHERE location = 1;";
    FMResultSet * set = [self.db executeQuery:sql];
    while ([set next]) {
        //  获取结果
        int count = [set intForColumnIndex:0];
        if (count > 0) {
            NSString * cityName = [set stringForColumn:@"city"];
            return cityName;
        }
    }
    return nil;
}


#pragma mark - 获取所有的数据
- (NSArray *)getAllData {
    //  1.sql语句
//    NSString * sql = @"SELECT * FROM t_appTable;";
    //SELECT * FROM t_Person WHERE age > 22 ORDER BY age;
    NSString * sql = @"SELECT * FROM t_appTable ORDER BY id;";
    
    //  2.执行sql语句
    FMResultSet * set = [self.db executeQuery:sql];
    
    NSMutableArray * marray = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString * cityName = [set stringForColumn:@"city"];
        NSString * location = [set stringForColumn:@"location"];
        //  保存
        [marray addObject:[NSString stringWithFormat:@"%@+%@",cityName,location]];
    }
    
    
    return marray;
}


#pragma mark - 删除数据
- (void)deleteDataWithCityName:(NSString *)city {
    //1.sql语句
    NSString * sql = @"DELETE FROM t_appTable WHERE city = ?;";
    //2.执行sql语句
    BOOL ret = [self.db executeUpdate:sql,city];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

//  ===================日程表
#pragma mark - 创建表单 - 日程
- (void)creatDateTable {
    //  1.创建sql语句
    NSString * sql = @"CREATE TABLE IF NOT EXISTS t_dateTable(id integer PRIMARY KEY AUTOINCREMENT, date text, title text, content image);";
    //  2.执行sql语句
    BOOL ret = [_db executeUpdate:sql];
    
    if (ret) {
        NSLog(@"创建日程表成功");
        NSLog(@"%@",NSHomeDirectory());
    }else {
        NSLog(@"创建日程表表失败");
    }
}
- (void)insertDateWithDate:(NSString *)date
                  andTitle:(NSString *)title
                andContent:(NSAttributedString *)content {
    //  1.sql语句
    NSString * sql = @"INSERT INTO t_dateTable(date,title,content) VALUES (?,?,?);";
    
    //  2.执行sql语句
    BOOL ret = [self.db executeUpdate:sql,date,title,content];
    
    if (ret) {
        NSLog(@"日程插入成功");
    }else {
        NSLog(@"日程插入失败");
    }
}
- (NSArray *)getDataWithDate:(NSString *)date {
    NSString * sql = @"SELECT * FROM t_dateTable WHERE date = ?";
    NSMutableArray * marray = [NSMutableArray array];
    FMResultSet * set = [self.db executeQuery:sql, date];
    while ([set next]) {
        //  获取结果
        int count = [set intForColumnIndex:0];
        if (count > 0) {
            JYDateDataModel * model = [JYDateDataModel new];
            model.date = [set stringForColumn:@"date"];
            model.title = [set stringForColumn:@"title"];
            model.content = [set stringForColumn:@"content"];
            //  保存
            [marray addObject:model];
        }
    }
    
    return marray;
}

- (NSArray *)getAllDataInDateDB {
    //  1.sql语句
    NSString * sql = @"SELECT * FROM t_dateTable;";
    NSMutableArray * marray = [NSMutableArray array];
    FMResultSet * set = [self.db executeQuery:sql];
    while ([set next]) {
        //  获取结果
        int count = [set intForColumnIndex:0];
        if (count > 0) {
            JYDateDataModel * model = [JYDateDataModel new];
            model.date = [set stringForColumn:@"date"];
            model.title = [set stringForColumn:@"title"];
            model.content = [set stringForColumn:@"content"];
            //  保存
            [marray addObject:model];
        }
    }
    return marray;
}

- (void)deleteDataWithTitle:(NSString *)title
                   WithDate:(NSString *)date{
    NSString * sql = @"DELETE FROM t_dateTable WHERE title = ? and date = ?;";
    BOOL ret = [self.db executeUpdate:sql,title,date];
    if (ret) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}
- (BOOL)checkIsInDBWithTitle:(NSString *)title
                     andDate:(NSString *)date{
    NSString * sql = @"SELECT count(*) FROM t_dateTable WHERE title = ? and date = ?;";
    FMResultSet * set = [self.db executeQuery:sql,title,date];
    while ([set next]) {
        //  获取结果
        int count = [set intForColumnIndex:0];
        if (count > 0) {
            return YES;
        }
    }
    return NO;
}


@end
