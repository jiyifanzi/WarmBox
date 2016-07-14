//
//  JYLifeVideoCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYLifeVideoCell.h"
#import "JYPlayerViewController.h"
#import "AppDelegate.h"

@interface JYLifeVideoCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *timeCount;
@property (weak, nonatomic) IBOutlet UIImageView *topicIcon;
@property (weak, nonatomic) IBOutlet UILabel *topicName;
@property (weak, nonatomic) IBOutlet UIButton *downLoad;


@end

@implementation JYLifeVideoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

#pragma mark - 分享
- (IBAction)downLoadTheVideo:(UIButton *)sender {
    [ShareConfig shareConfig];
//    [[ShareConfig CNshareHander] shareToPlatformWithContent:@"" Image:_cover.image url:self.model.video_url ViewController:(UIViewController *)self.delegate];
    
    [[ShareConfig CNshareHander] shareToPlatformWithContent:@"分享一个好玩的视频~" Image:_cover.image  url:self.model.video_url ViewController:(UIViewController *)self.delegate];
}

- (void)setModel:(JYLifeVideoModel *)model {
    _model = model;
    
//    _title.text = model.title;
    
    [_cover setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    _timeCount.text = model.playTime;
    
    [_topicIcon setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    _topicName.text = model.title;
}



- (IBAction)playVideo:(id)sender {
//    [self.delegate playTheVideoWithURL:self.model.mp4_url];
    [self.delegate playTheVideoWithURL:self.model.video_url andTitle:self.model.title];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
