//
//  JYDownloadOnLineCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/11.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYDownloadOnLineCell.h"

@interface JYDownloadOnLineCell () {
    float _pr;
}


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
//  下载管理者
@property (nonatomic, strong) ResumeDownload * resumeDownload;
//  下载进度

@property (nonatomic, assign) BOOL isDownload;

//  下载按钮
@property (weak, nonatomic) IBOutlet UIButton *download;


@end

@implementation JYDownloadOnLineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(JYDownloadModel *)model {
    _model = model;
    
    self.url = model.url;
    
    self.fileName.text = model.title;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
}
//下载进度
-(void)upading:(ResumeDownload*)rd{
    _pr = [rd.downloadSize floatValue]/[rd.fileSize floatValue];
    
    NSLog(@"====%.1f",_pr);
    self.progressView.progress = _pr;
    /*
     //要下载文件的总大小
     @property (strong, nonatomic) NSNumber *fileSize;
     //已经下载了的大小
     @property (strong, nonatomic) NSNumber *downloadSize;
     */
    self.progressLabel.text = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.1f",_pr * 100]];
}

//下载完成
-(void)finishDownload:(ResumeDownload*)rd{
    self.progressView.hidden = YES;
    if ([rd localPath]) {
//        self.imageView.image = [UIImage imageWithContentsOfFile:[rd localPath]];
        self.model.filePath = [rd localPath];
        //  让代理删除正在下载的链接，从本地重写获取
        [self.delegate removeOnlineandGetDataDBWithModel:self.model];
    }
}

//下载失败
-(void)failDownload:(ResumeDownload*)rd{
    NSLog(@"下载失败:%@",[rd localPath]);
    [KVNProgress showErrorWithStatus:@"下载失败，请检查网络或稍后再试"];
}

//  播放控制
- (IBAction)stopDownload:(id)sender {
    if (_isDownload) {
        if (_resumeDownload) {
            [_resumeDownload stopDownload];
            [_download setImage:[UIImage imageNamed:@"pui_playbtn_s.png"] forState:UIControlStateNormal];
            _isDownload = NO;
        }else {
            
        }
    }else {
//        [_resumeDownload requestFromUrl];
        //  实例化resumeDownload;
        _resumeDownload = [[ResumeDownload alloc] init];
        _resumeDownload.fileUrl = self.url;
        _resumeDownload.delegate = self;
        _resumeDownload.updatingMethod = @selector(upading:);
        _resumeDownload.finishMethod = @selector(finishDownload:);
        _resumeDownload.failMethod = @selector(failDownload:);
        _resumeDownload.fileName = self.model.title;
        //开始下载
        [_resumeDownload requestFromUrl];
        [_download setImage:[UIImage imageNamed:@"vScreenPauseHigh@3x"] forState:UIControlStateNormal];
        _isDownload = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
