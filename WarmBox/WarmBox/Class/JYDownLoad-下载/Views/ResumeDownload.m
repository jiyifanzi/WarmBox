//
//  ResumeDownload.m
//  03_ResumeDownload
//
//  Created by baoxu on 16/3/2.
//  Copyright © 2016年 BaoXu. All rights reserved.
//

#import "ResumeDownload.h"
#import "NSString+MD5Addition.h"


/*
 去掉PerformSelectorARC下的警告
 在ARC模式下，运行时需要知道如何处理你正在调用的方法的返回值。这个返回值可以是任意值，如 void , int , char , NSString , id 等等。ARC通过头文件的函数定义来得到这些信息。所以平时我们用到的静态选择器就不会出现这个警告。因为在编译期间，这些信息都已经确定。
 而使用 [someController performSelector: NSSelectorFromString(@"someMethod")]; 时ARC并不知道该方法的返回值是什么，以及该如何处理？该忽略？还是标记为 ns_returns_retained 还是 ns_returns_autoreleased ?
 
 使用do{...}while(0)构造后的宏定义不会受到大括号、分号等的影响、避免if else不匹配，总是会按你期望的方式调用运行。
 */

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation ResumeDownload


//做下载任务的
-(void)requestFromUrl{
    NSURL *url = [NSURL URLWithString:self.fileUrl];
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];
    
    //判断，如果当前要下载的文件不存在，则创建一个
    NSFileManager *mg = [NSFileManager defaultManager];
    if (![mg fileExistsAtPath:[self localPath]]) {
        [mg createFileAtPath:[self localPath] contents:nil attributes:nil];
    }
    
    //根据文件路径获取文件句柄，用来操作文件，更新类型的句柄
    _fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self localPath]];
    
    //获取文件的大小
    NSData *data = [NSData dataWithContentsOfFile:[self localPath]];
    NSLog(@"%lu",(unsigned long)data.length);
    
    //将文件指针移动到结尾
    [_fileHandle seekToEndOfFile];
    self.downloadSize = [NSNumber numberWithLongLong:[_fileHandle offsetInFile]];
    NSLog(@"downloadSize:%@",self.downloadSize);
    //要下载之前，先取到文件句柄，将句柄移动到文件末尾，返给我们当前文件的大小，记录当前的大小
    //设置需要下载的范围
    NSString *rangeStr = [NSString stringWithFormat:@"bytes=%lld-",[self.downloadSize longLongValue]];
    NSLog(@"rangeStr:%@",rangeStr);
    
    [request setValue:rangeStr forHTTPHeaderField:@"Range"];
    
    NSLog(@"%@",request);
    
    
    _httpConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

#pragma mark -代理方法-
//调用它就证明，链接有响应，已经下载完响应头，开始下载
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //总大小 = 返回要下载的大小 + 已经下载的大小
    self.fileSize = [NSNumber numberWithLongLong:response.expectedContentLength + [self.downloadSize longLongValue]];
    NSLog(@"fileSize:%@",_fileSize);
}

//调用它就证明，正在接收数据，响应体，根据数据的大小，会不间断的接收，直至全部完成
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
 
    //将接受的数据写入文件
    [_fileHandle writeData:data];
    
    //更新已经下载了的大小
    unsigned long long newDownloadSize = [self.downloadSize longLongValue] + [data length];
    self.downloadSize = [NSNumber numberWithLongLong:newDownloadSize];
    NSLog(@"downloadSize:%@",self.downloadSize);
    
    //返给使用者进度
    //检查代理是否实现了这个方法
    if ([self.delegate respondsToSelector:self.updatingMethod]) {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:self.updatingMethod withObject:self]);
    }
}
//调用它就证明，已经下载完成
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //文件下载成功，关闭文件句柄，释放句柄对象
    if (_fileHandle) {
        [_fileHandle closeFile];
        _fileHandle = nil;
    }
    NSLog(@"%@",[self localPath]);
    //通知使用者，下载成功
    
    if ([self.delegate respondsToSelector:self.finishMethod]) {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:self.finishMethod withObject:self]);
    }
    
}

//连接发生错误，下载失败
//1.断网了
//2.网址不对
-(void)connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error{
    //文件下载失败，关闭文件句柄，释放句柄对象
    if (_fileHandle) {
        [_fileHandle closeFile];
        _fileHandle = nil;
    }
    
    //通知使用者，下载失败
    if ([self.delegate respondsToSelector:self.failMethod]) {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:self.failMethod withObject:self]);
    }
}

-(void)stopDownload{
    if (_fileHandle) {
        [_fileHandle closeFile];
        _fileHandle = nil;
    }
    //停止下载
    [_httpConnection cancel];
    //释放对象
    _httpConnection = nil;
}


-(NSString *)localPath{
    //获取当前沙盒目录
    NSString *path = NSHomeDirectory();
    //根据文件的url md5加密后 命名文件名，保证文件的唯一性
    NSString *fileName = [self.fileUrl stringFromMD5];

    fileName = [NSString stringWithFormat:@"%@video+%@",fileName,self.fileName];
    //完整的路径
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",fileName]];
    
    return path;
}

@end
