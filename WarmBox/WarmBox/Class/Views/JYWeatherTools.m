//
//  JYWeatherTools.m
//  WarmBox
//
//  Created by qianfeng on 16/7/1.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherTools.h"

@implementation JYWeatherTools

#pragma mark - 根据天气情况，设置图片
+ (NSString *)getBackImageNameWithWeatherNumber:(NSString *)weatherNumber {
    
    CGFloat imageCode = weatherNumber.floatValue;
    NSString * imageName = @"";
    //  根据model的值来设置图片
    
    if (imageCode == 100) {
        //  晴天
        imageName = @"wb_sunny.jpg";
    }else if (imageCode == 101) {
        //  多云
        imageName = @"wb_coludy.jpg";
    }
    else if (imageCode == 102 || imageCode == 103) {
        //  少云
        imageName = @"wb_na.jpg";
    }
    else if (imageCode == 104) {
        //  阴天
        imageName = @"wb_yin.jpg";
    }else if (imageCode >= 200 && imageCode <= 204) {
        //  有风
        imageName = @"wb_windy.jpg";
    }else if (imageCode >= 205 && imageCode <= 213) {
        //  有大风
        imageName = @"wb_tropicalstorm.jpg";
    }else if (imageCode == 301 || imageCode == 300 ||(imageCode >= 305 && imageCode <=312)) {
        //  小于
        imageName = @"wb_rain.jpg";
    }
    else if (imageCode == 302) {
        //  雷阵雨
        imageName = @"wb_thunderstorm.jpg";
    }else if (imageCode == 303 || imageCode == 303) {
        //  雷阵雨
        imageName = @"wb_storm_rain.jpg";
    }else if (imageCode == 400 || imageCode == 401) {
        //  小雪
        imageName = @"wb_snow.jpg";
    }else if (imageCode == 402 || imageCode == 403) {
        //  小雪
        imageName = @"wb_heavy_snow.jpg";
    }else if (imageCode >= 404 && imageCode <= 407) {
        //  小雪
        imageName = @"wb_storm_snow";
    }else if (imageCode == 500 || imageCode == 501) {
        //  雾
        imageName = @"wb_fog.jpg";
    }else if (imageCode == 502) {
        //  雾
        imageName = @"wb_haze.jpg";
    }else if (imageCode >= 503 && imageCode <= 508) {
        //  雾
        imageName = @"wb_sandstorm.jpg";
    }else {
        imageName = @"bg_snow.jpg";
    }
    return imageName;
}


#pragma mark - 富文本排列，传入图片和文字还有字体大小，传出富文本
+ (NSAttributedString *)mixImage:(UIImage *)image
                         andText:(NSAttributedString *)text
                 andTextFontSize:(NSInteger)fontSize
{
    // 用富文本实现图文混排
    // 将图片转换为文本附件对象
    NSTextAttachment * commentAttachment = [[NSTextAttachment alloc] init];
    commentAttachment.image = image;
    // 将文本附件对象转换为富文本
    NSAttributedString * commentAttachAttr = [NSAttributedString attributedStringWithAttachment:commentAttachment];
    // 将文字转换为富文本
//    NSAttributedString * commentCountAttr = [[NSAttributedString alloc] initWithString:text.string  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}];
    
    NSAttributedString * commentCountAttr = [[NSAttributedString alloc] initWithAttributedString:text];
    
    // 拼接所有富文本
    NSMutableAttributedString * commentAttr = [[NSMutableAttributedString alloc] init];
    [commentAttr appendAttributedString:commentCountAttr];
    [commentAttr appendAttributedString:commentAttachAttr];
 
    return [commentAttr copy];
}


#pragma mark - 展示数据
+ (void)showMessageWithAlertView:(NSString *)message {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}


#pragma mark - 删除指定城市的数据，并且重新插入，把指定城市的location变成1，其他变成0
//  删除指定城市的数据，并且重新插入，把指定城市的location变成1，其他变成0
+ (void)changeCityLocationValueWithCityName:(NSString *)cityName {
    //  删除当前选中cell的城市
    [[JYBasicDataManager new] deleteDataWithCityName:cityName];
    [[JYBasicDataManager new] insertDataWithCityName:cityName andLocation:@"1"];
    //  重新插入城市，并且把当前的Location改成1，其他改成0
    NSArray * allData = [[JYBasicDataManager new] getAllData];
    NSMutableArray * allDataFor = [NSMutableArray array];
    for (NSString * tempStr in allData) {
        NSArray * strArr = [tempStr componentsSeparatedByString:@"+"];
        [allDataFor addObject:[strArr firstObject]];
    }
    
    NSLog(@"%@",cityName);
    
    //  allDataFor存入的是全部的城市信息
    for (NSString * city in allDataFor) {
        if ([city isEqualToString:cityName]) {
            [[JYBasicDataManager new] deleteDataWithCityName:city];
            [[JYBasicDataManager new] insertDataWithCityName:city andLocation:@"1"];
        }else {
            [[JYBasicDataManager new] deleteDataWithCityName:city];
            [[JYBasicDataManager new] insertDataWithCityName:city andLocation:@"0"];
        }
    }
    
}

#pragma mark - 获取当前的日期，以怎样的格式
+ (NSString *)getNowDataWithFormate:(NSString *)formate {
    NSDate * now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = formate;
    NSString * data = [formatter stringFromDate:now];
    
    return data;
}

#pragma mark ---删除指定分类文件夹
- (NSString *)LibraryPath{
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/default"]];
    return path;
}
//Library/Caches/default

#pragma mark ---获取指定缓存路径的缓存大小
+ (NSString *)getCacheSizeWithCacheFilePath:(NSString *)cacheFilePath{
    long long folderSize = 0;
    //获取该分类目录下所有文件的路径 并循环遍历获取大小
    NSFileManager* manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cacheFilePath] objectEnumerator];
    NSString* fileName;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [cacheFilePath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    NSString * SizeStr = [self getKBorMBorGBWith:folderSize];
    
    return SizeStr;
}


#pragma mark ---单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark ---字节转换KB或者MB或者GB
+ (NSString *)getKBorMBorGBWith:(CGFloat)folderSize{
    //判断KB MB GB 单位 返回相应的字符串
    if (folderSize == 0) {
        return [NSString stringWithFormat:@"0.00KB"];
    } else if (folderSize/(1024.0) < 1024.0) {
        return [NSString stringWithFormat:@"%.2fKB",folderSize/(1024.0)];
    } else if (folderSize/(1024.0) >= 1024.0 && folderSize/(1024.0 * 1024.0) < 1024.0) {
        return [NSString stringWithFormat:@"%.2fMB",folderSize/(1024.0 * 1024.0)];
    } else {
        return [NSString stringWithFormat:@"%.2fGB",folderSize/(1024.0 * 1024.0 * 1024.0)];
    }
}

//  从数据库获取下载的视频数据
+ (NSMutableArray *)requestVideoFromDB {
    
    NSMutableArray * videoArray = [NSMutableArray array];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents"]];
    NSArray * arr = [manager contentsOfDirectoryAtPath:path error:nil];

    for (NSString * fileName in arr) {
        //  然后来判断本目录的文件有没有video的字，有的话，进行剪切
        NSRange range = [fileName rangeOfString:@"video"];
        if (range.length != 0) {
            //  找到了，然后进行分割
            NSArray * fileNameArr = [fileName componentsSeparatedByString:@"+"];
            //  后面的是文件的名称
            JYDownloadModel * model = [JYDownloadModel new];
            model.title = [fileNameArr lastObject];
            model.filePath = [NSString stringWithFormat:@"%@/%@",path,fileName];
            [videoArray addObject:model];
        }
    }
    return videoArray;
}
#pragma mark - 删除本地缓存的电影
+ (void)removeVideoFromDBWithName:(NSString *)fileName {

    NSFileManager * manager = [NSFileManager defaultManager];
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents"]];
    NSArray * arr = [manager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString * tempFileName in arr) {
        //  然后来判断本目录的文件有没有video的字，有的话，进行剪切
        NSRange range = [tempFileName rangeOfString:@"video"];
        if (range.length != 0) {
            //  找到了，然后进行分割
            NSArray * fileNameArr = [tempFileName componentsSeparatedByString:@"+"];
            if ([[fileNameArr lastObject] isEqualToString:fileName]) {
                NSError * error = nil;
                [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",path,tempFileName] error:&error];
            }
        }
    }
}


@end
