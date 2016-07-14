//
//  JYLifeVideoModel.h
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYLifeVideoModel : NSObject <YYModel>

/*
 "commentsall": 3,
 "commentsUrl": "http://v.ifeng.com/vblog/tongqu/201607/04925638-4f15-4d35-9a85-35ebd1d075f0.shtml",
 "documentId": "video_15842",
 "duration": 14,
 "image": "http://d.ifengimg.com/w640_h360/p0.ifengimg.com/pmop/2016/07/07/58555ca2-9b2f-4643-a092-ffc8052376f8.jpg",
 "playTime": "970",
 "shareUrl": "http://i.ifeng.com/sharenews.f?videoid=15842&fromType=videofetch",
 "title": "温馨的父子场面 可能是童年最美的回忆......",
 "video_size": 878,
 "video_url": "http://ips.ifeng.com/video19.ifeng.com/video09/2016/07/07/4125306-102-008-1619.mp4"
 
 */

//  标题
@property (nonatomic, strong) NSString * title;
//  封面
@property (nonatomic, strong) NSString * image;
//  MP4链接
@property (nonatomic, strong) NSString * video_url;
//  播放次数
@property (nonatomic, strong) NSString * playTime;
//  视频长度
@property (nonatomic, strong) NSString * video_size;


////  标题
//@property (nonatomic, strong) NSString * title;
////  封面
//@property (nonatomic, strong) NSString * cover;
////  MP4链接
//@property (nonatomic, strong) NSString * mp4_url;
////  m3u8链接
//@property (nonatomic, strong) NSString * m3u8_url;
////  播放次数
//@property (nonatomic, strong) NSString * playCount;
////  视频长度
//@property (nonatomic, strong) NSString * length;
//
////  上传用户头像
//@property (nonatomic, strong) NSString * topicImg;
////  上传用户名字
//@property (nonatomic, strong) NSString * topicName;

@end
