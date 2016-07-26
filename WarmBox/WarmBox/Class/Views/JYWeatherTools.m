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
        imageName = @"wb_coludy_1.jpg";
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
        imageName = @"wb_rain_1.jpg";
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

#pragma mark - 获取远程的所有日记数据
+ (void)getAllNoteData {
    JYUser * currentUser = [JYUser currentUser];
    
    [currentUser fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
    
        if (currentUser) {
            NSArray * arr = [currentUser objectForKey:@"noteArray"];
            
            for (AVFile * file in arr) {
                
                AVObject * obj = [AVObject objectWithClassName:@"_File" objectId:file.objectId];
                
                [obj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                    if (!error) {
                        AVFile * file = [AVFile fileWithAVObject:obj];
                        //  找到了File  2016-07-21#123+1+20-03
                        NSLog(@"%@",file.name);
                        
                        
                        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            
                            NSArray * pathAndName = [file.name componentsSeparatedByString:@"#"];
                            
                            NSLog(@"%@",pathAndName);
                            
                            
                            NSFileManager * manager = [NSFileManager defaultManager];
                            //                        NSError * errorX = [NSError new];
                            NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",pathAndName.firstObject]];
                            //  创建文件夹
                            [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                            
                            //  获取到文件的路径
                            NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.plist",pathAndName.firstObject,pathAndName.lastObject]];
                            
                            NSLog(@"%@",filepath);
                            
                            //  没有出现错误，进行缓存
                            [data writeToFile:filepath atomically:NO];
                        }];
                    }else {
                        NSLog(@"网络加载%@",error.localizedDescription);
                    }
                }];
            }
            
            NSLog(@"%@",arr);
    
            //        [currentUser fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            //           //   获取文件
            //            NSArray * arr = [currentUser objectForKey:@"noteArray"];
            //
            //            AVFile * file = [arr firstObject];
            //
            //
            //
            //            AVFile * file2 = [AVFile fileWithAVObject:[AVObject get]]
            //
            //            NSLog(@"%@",file.url);
            //
            //
            //        }];
            
            
            //        NSArray * arr = [currentUser valueForKey:@"noteArray"];
            //        NSLog(@"%@",arr);
            //
            //        if (arr.count != 0) {
            //
            //            //  获取到了数据，根据AVfile的名字来创建目录，在目录下面增加文件
            //            for (AVFile * tempFile in arr) {
            //
            //                AVFile * temp = [AVFile fileWithAVObject:[AVObject objectWithObjectId:tempFile.objectId]];
            //                [temp getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            //
            //                     NSLog(@"===%@",temp.url);
            //
            //                }];
            //
            //                [tempFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            //                    NSLog(@"%@",error);
            //
            //                    if (!error) {
            //                        NSLog(@"%@",tempFile.name);
            //
            //                        NSArray * pathAndName = [tempFile.name componentsSeparatedByString:@"+"];
            //
            //                        NSFileManager * manager = [NSFileManager defaultManager];
            //                        NSError * error = [NSError new];
            //                        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",pathAndName.firstObject]];
            //                        //  创建文件夹
            //                        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            //                        
            //                        //  获取到文件的路径
            //                        NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.plist",pathAndName.firstObject,pathAndName.lastObject]];
            //                        
            //                        NSLog(@"%@",filepath);
            //                        
            //                        //  没有出现错误，进行缓存
            //                        [data writeToFile:filepath atomically:NO];
            //                    }
            //                }];
            //            }
            //        }
            //
        }

    }];

}

#pragma mark - 上传数据到云端
+ (void)pushAllNoteData {
    //  将本地noteCatch里面的文件上传到网络上
    
    //  拿到noteCatch里面的所有文件
    //  笔记缓存目录
    NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteCatch"]];
    //  获取当前目录下的所有文件
    //  读取某个文件夹下所有的文件夹或者文件
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
    //  如果NSError有值，就表示出错
    if (!error) {
        //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
        for (NSString * str in contentsArray) {
            if ([str isEqualToString:@".DS_Store"]) {
                continue;
            }
            NSLog(@"%@",str);
            //  2016-07-21#123+1+20-03.plist
            //  2016-07-21#123+1+20-01
            
            NSArray * strArray = [str componentsSeparatedByString:@".plist"];
            
            NSString * fileNameStr = [strArray firstObject]; //2016-07-21#123+1+20-01
            //  fileNameStr为日期+标题的文件 2016-07-21+123
            
            NSData * fileData = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",pathCatch,str]];
            
            NSArray * fileandDateArray = [fileNameStr componentsSeparatedByString:@"+"];
    
            //  获取到现在的Data
            NSMutableArray * fileArray = [[NSMutableArray alloc] init];
            //  数组里面保存AVfile数据
            AVFile * tempFile = [AVFile fileWithName:fileNameStr data:fileData];
            
            NSLog(@"%@",tempFile.name);
            
            [tempFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //  将文件进行保存
                if (succeeded) {
                    [fileArray addObject:tempFile];
                    //  获取当前登录的用户
                    JYUser * currentUser = [JYUser currentUser];
                    if (currentUser) {
                        AVQuery * query = [AVQuery queryWithClassName:@"_File"];
                        [query whereKey:@"name" equalTo:tempFile.name];
                        
                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            
                            if (objects.count == 0) {
                                
                            }else {
                                for (AVObject * object in objects) {
                                    NSLog(@"%@",object.objectId);
                                    if ([tempFile.objectId isEqualToString:object.objectId]) {
                                        //  如果存入的Id和已有的id相同，则不管
                                    }else {
                                        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            if (succeeded) {
                                                NSLog(@"成功");
                                            }else {
                                                NSLog(@"%@",error.localizedDescription);
                                            }
                                        }];
                                    }
                                }
                            }
                            //  没有找到，开始存储
                            //  如果用户存在，进行保存
                            [currentUser addObjectsFromArray:fileArray forKey:@"noteArray"];
                            
                            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    //  笔记缓存目录
                                    NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteCatch"]];
                                    //  获取当前目录下的所有文件
                                    //  读取某个文件夹下所有的文件夹或者文件
                                    NSFileManager * manager = [NSFileManager defaultManager];
                                    NSError * error = nil;
                                    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
                                    //  如果NSError有值，就表示出错
                                    if (!error) {
                                        //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
                                        for (NSString * str in contentsArray) {
                                            NSArray * strArray = [str componentsSeparatedByString:@".plist"];
                                            NSString * fileNameStr = [strArray firstObject];
                                            
                                            NSLog(@"str%@",str);
                                            NSLog(@"%@",fileNameStr);
                                            NSLog(@"temp%@",tempFile.name);
                                            //  2016-07-21#123+1+20-03
                                            if ([fileNameStr isEqualToString:tempFile.name]) {
                                                //  上传成功，并且找到了相同的文件，就删除这个文件
                                                [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
                                                
                                            }
                                        }
                                    }
                                    
                                }else {
                                    //  失败了，删除刚刚上传的文件
                                    [tempFile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                        //
                                        if (succeeded) {
                                            //  删除成功
                                        }else {
                                            //  失败
                                        }
                                    }];
                                }
                            }];
                        }];
                        
                        
                    }
                }else {
                    NSLog(@"===er%@",error.localizedDescription);
                }
            }];
            
        }
    }
}


#pragma mark  - 上传本地Doucument的笔记缓存下面的数据(主要是针对于网络的缓存)
+ (void)removeAllNoteDelateCatch {
    
    NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
    //  获取当前目录下的所有文件
    //  读取某个文件夹下所有的文件夹或者文件
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
    
    //  获取当前的用户
    //  删除之后，要把对应的远程账户下的数组元素也要清空，也可以直接删除对应的File，让ObjectID为空

    JYUser * currentUser = [JYUser currentUser];

    NSMutableArray * userNoteArray = [currentUser objectForKey:@"noteArray"];


    //  如果NSError有值，就表示出错
    if (!error) {
        //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
        for (NSString * str in contentsArray) {
            
            //  str就是文件夹下面存储的数据
            NSArray * fileStr = [str componentsSeparatedByString:@".plist"];
            NSString * fileandDateName = [fileStr firstObject];
            
            NSArray * fileNameArray = [fileandDateName componentsSeparatedByString:@"+"];
            
            //  根据名字找Fiel，再根据File来删除noteArray的数据
            NSString * fileName = [fileStr firstObject];
            
            NSLog(@"%@",fileName);
            if ([fileName isEqualToString:@".DS_Store"]) {
                
            }else {
                for (AVFile * tempFiel in userNoteArray) {
                    //  根据id来生成AVobejct，根据这个obejct来匹配
                    NSLog(@"%@",tempFiel.objectId);

                    AVObject * fileObj = [AVObject objectWithClassName:@"_File" objectId:tempFiel.objectId];
                    [fileObj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                        if (!error) {
                            //  找到了
                            //  根据AVobject生成AVfile
                            AVFile * file = [AVFile fileWithAVObject:fileObj];
                            NSLog(@"%@",file.name);
                            
                            
                            if ([file.name isEqualToString:fileName]) {
                                //  找到了相同的file
                                
                                
                                [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    //   删除
                                    if (succeeded) {
                                        NSLog(@"删除成功");
                                        //  删除成功的话，将NoteDeletaCatch下面的对应的文件也删除
                                        //  删除笔记缓存目录
                                        NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
                                        //  获取当前目录下的所有文件NoteDeleteCatch
                                        //  读取某个文件夹下所有的文件夹或者文件
                                        NSFileManager * manager = [NSFileManager defaultManager];
                                        NSError * error = nil;
                                        NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
                                        //  如果NSError有值，就表示出错
                                        if (!error) {
                                            //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
                                            for (NSString * str in contentsArray) {
                                                NSArray * strArray = [str componentsSeparatedByString:@".plist"];
                                                NSString * fileNameStr = [strArray firstObject];
                                                NSLog(@"%@",str);
                                                NSLog(@"%@",file.name);
                                                
                                                if ([fileNameStr isEqualToString:file.name]) {
                                                    //  上传成功，并且找到了相同的文件，就删除这个文件
                                                    [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
                                                }
                                            }
                                        }
                                        
                                    }else {
                                        NSLog(@"%@",error.localizedDescription);
                                    }
                                }];
                                
                                //  同时也要重新匹配数组
                                [userNoteArray removeObject:tempFiel];
                                //  再讲这个数组匹配给当前的用户
                                [currentUser setObject:userNoteArray forKey:@"noteArray"];
                                
                                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (succeeded) {
                                        //
                                        NSLog(@"保存成");
                                    }else {
                                        NSLog(@"%@",error.localizedDescription);
                                    }
                                }];
                            }
                            
                        }
                        
                    }];
                }
                NSLog(@"%@",userNoteArray);
            }

            }
            
        }
    }
    
    /*
     JYUser * currentUser = [JYUser currentUser];
     NSMutableArray * userNoteArray = [currentUser objectForKey:@"noteArray"];
     
     //  根据名字找Fiel，再根据File来删除noteArray的数据
     NSString * fileName = [NSString stringWithFormat:@"%@#%@+%@+%@",[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate], model.title, model.noteType, model.nowTime];
     
     //  2016-07-21#123+1+20-17副本
     NSLog(@"%@",fileName);
     
     for (AVFile * tempFiel in userNoteArray) {
     //  根据id来生成AVobejct，根据这个obejct来匹配
     NSLog(@"%@",tempFiel.objectId);
     
     AVObject * fileObj = [AVObject objectWithClassName:@"_File" objectId:tempFiel.objectId];
     [fileObj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
     if (!error) {
     //  找到了
     //  根据AVobject生成AVfile
     AVFile * file = [AVFile fileWithAVObject:fileObj];
     NSLog(@"%@",file.name);
     
     
     if ([file.name isEqualToString:fileName]) {
     //  找到了相同的file
     
     
     [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     //   删除
     if (succeeded) {
     NSLog(@"删除成功");
     //  删除成功的话，将NoteDeletaCatch下面的对应的文件也删除
     //  删除笔记缓存目录
     NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
     //  获取当前目录下的所有文件NoteDeleteCatch
     //  读取某个文件夹下所有的文件夹或者文件
     NSFileManager * manager = [NSFileManager defaultManager];
     NSError * error = nil;
     NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
     //  如果NSError有值，就表示出错
     if (!error) {
     //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
     for (NSString * str in contentsArray) {
     NSArray * strArray = [str componentsSeparatedByString:@".plist"];
     NSString * fileNameStr = [strArray firstObject];
     NSLog(@"%@",str);
     NSLog(@"%@",file.name);
     
     if ([fileNameStr isEqualToString:file.name]) {
     //  上传成功，并且找到了相同的文件，就删除这个文件
     [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
     }
     }
     }
     
     }else {
     NSLog(@"%@",error.localizedDescription);
     }
     }];
     
     //  同时也要重新匹配数组
     [userNoteArray removeObject:tempFiel];
     //  再讲这个数组匹配给当前的用户
     [currentUser setObject:userNoteArray forKey:@"noteArray"];
     
     [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
     if (succeeded) {
     //
     NSLog(@"保存成");
     }else {
     NSLog(@"%@",error.localizedDescription);
     }
     }];
     }
     
     }
     
     }];
     }
     NSLog(@"%@",userNoteArray);
     }

     
     
     */
//
//
//    //  根据名字找Fiel，再根据File来删除noteArray的数据
//    NSString * fileName = [NSString stringWithFormat:@"%@+%@",[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate], model.title];
//
//
//    for (AVFile * tempFiel in userNoteArray) {
//        //  根据id来生成AVobejct，根据这个obejct来匹配
//        AVObject * fileObj = [AVObject objectWithClassName:@"_File" objectId:tempFiel.objectId];
//        [fileObj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//            if (!error) {
//                //  找到了
//                //  根据AVobject生成AVfile
//                AVFile * file = [AVFile fileWithAVObject:fileObj];
//                NSLog(@"%@",file.name);
//                if ([file.name isEqualToString:fileName]) {
//                    //  找到了相同的file
//                    [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        //   删除
//                        if (succeeded) {
//                            NSLog(@"删除成功");
//                            //  删除成功的话，将NoteDeletaCatch下面的对应的文件也删除
//                            //  删除笔记缓存目录
//                            NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
//                            //  获取当前目录下的所有文件
//                            //  读取某个文件夹下所有的文件夹或者文件
//                            NSFileManager * manager = [NSFileManager defaultManager];
//                            NSError * error = nil;
//                            NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
//                            NSMutableArray * fileArray = [NSMutableArray array];
//                            //  如果NSError有值，就表示出错
//                            if (!error) {
//                                //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
//                                for (NSString * str in contentsArray) {
//                                    NSArray * strArray = [str componentsSeparatedByString:@".plist"];
//                                    NSString * fileNameStr = [strArray firstObject];
//                                    NSLog(@"%@",str);
//                                    NSLog(@"%@",file.name);
//                                    
//                                    if ([fileNameStr isEqualToString:file.name]) {
//                                        //  上传成功，并且找到了相同的文件，就删除这个文件
//                                        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
//                                    }
//                                }
//                            }
//                            
//                        }else {
//                            NSLog(@"%@",error.localizedDescription);
//                        }
//                    }];
//                    
//                    //  同时也要重新匹配数组
//                    [userNoteArray removeObject:tempFiel];
//                    //  再讲这个数组匹配给当前的用户
//                    [currentUser setObject:userNoteArray forKey:@"noteArray"];
//                    
//                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        if (succeeded) {
//                            //
//                            NSLog(@"保存成");
//                        }else {
//                            NSLog(@"%@",error.localizedDescription);
//                        }
//                    }];
//                }
//                
//            }
//            
//        }];
//    }
//    
//    NSLog(@"%@",userNoteArray);
//




#pragma mark - 删除本地Doucument下面的所有日记
+ (void)removeAllNoteFromDB {
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents"]];
    
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray * fileArray = [NSMutableArray array];
    //  如果NSError有值，就表示出错
    if (!error) {
        //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
        for (NSString * str in contentsArray) {
            if ([str rangeOfString:@"-"].length != 0) {
                
                NSLog(@"%@",str);
                [fileArray addObject:str];
            }
            NSLog(@"%@",str);
        }
    }
    
    for (NSString * temoStr in fileArray) {
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",path, temoStr];
        
        [manager removeItemAtPath:filePath error:nil];
    }
}


#pragma mark - 是否是手机号码的正则
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1((3[0-9]|4[57]|5[0-35-9]|7[0678]|8[0-9])\\d{8}$)";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
