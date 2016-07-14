//
//  ResumeDownload.h
//  03_ResumeDownload
//
//  Created by baoxu on 16/3/2.
//  Copyright © 2016年 BaoXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResumeDownload : NSObject<NSURLConnectionDataDelegate>
{
    //网络连接
    NSURLConnection *_httpConnection;
    
    //文件句柄
    NSFileHandle *_fileHandle;
}
//要下载的文件的名称
@property (copy, nonatomic) NSString * fileName;
//要下载文件的url
@property (copy, nonatomic) NSString * fileUrl;
//要下载文件的总大小
@property (strong, nonatomic) NSNumber *fileSize;
//已经下载了的大小
@property (strong, nonatomic) NSNumber *downloadSize;

//代理对象
@property (assign, nonatomic) id delegate;
//更新下载进度的回调方法
@property (assign, nonatomic) SEL updatingMethod;
//更新下载完成的回调方法
@property (assign, nonatomic) SEL finishMethod;
//更新下载失败的回调方法
@property (assign, nonatomic) SEL failMethod;
//备用方法
@property (assign, nonatomic) SEL method;


//从指定的网址开始下载
-(void)requestFromUrl;

//停止下载
-(void)stopDownload;

//获取当前文件的目录
-(NSString *)localPath;

@end
