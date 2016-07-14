//
//  JYPlayerView.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface JYPlayerView ()

@property (nonatomic, strong) AVPlayer * palyer;

@end


@implementation JYPlayerView
#pragma mark - 懒加载
//  创建播放器
- (AVPlayer *)palyer {
    if (!_palyer) {
        //  创建播放源
        NSURL * url = [NSURL URLWithString:self.url];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
        //  创建播放对象
        _palyer = [[AVPlayer alloc] initWithPlayerItem:item];
        
    }
    return _palyer;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self creatPlayView];
    
    NSURL * urls = [NSURL URLWithString:self.url];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:urls];
    _palyer = [[AVPlayer alloc] initWithPlayerItem:item];
}

- (instancetype)initWithFrame:(CGRect)frame andURL:(NSString *)url {
    if (self = [super initWithFrame:frame]) {
        [self creatPlayView];
        
        NSURL * urls = [NSURL URLWithString:url];
        AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:urls];
        _palyer = [[AVPlayer alloc] initWithPlayerItem:item];
        
    }
    return self;
}

#pragma mark - 创建播放界面
- (void)creatPlayView {
    //  1.创建播放界面
    //  AVPlayerLayer 专门用来展示AVPlayer中视频的图像
    AVPlayerLayer * playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.palyer];
    //  2.设置layer的frame
    playerLayer.frame = self.frame;
    //  3.显示在界面上
    [self.layer addSublayer:playerLayer];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.palyer play];
}


@end
