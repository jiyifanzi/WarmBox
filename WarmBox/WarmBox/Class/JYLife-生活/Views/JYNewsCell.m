//
//  JYNewsCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYNewsCell.h"

@interface JYNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *author;

@end
@implementation JYNewsCell

- (void)awakeFromNib {
    // Initialization code
}
#pragma mark - 设置cell的子空间值
- (void)setModel:(JYNewsModel *)model {
    _model = model;
    
    _imageIcon.clipsToBounds = YES;
    [_imageIcon setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"image_cache"]];
//    [_imageIcon sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    
    _title.text = model.title;
    
    //  格式化时间
    NSDate * now = [NSDate dateWithTimeIntervalSince1970:model.lmodify.floatValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = @"MM/dd hh:mm";
    NSString * data = [formatter stringFromDate:now];

    _date.text = data;
    
    _author.text = model.source;
}

#pragma mark - 当为视频时
- (void)setLifeModel:(JYLifeVideoModel *)lifeModel {
    _lifeModel = lifeModel;
    
//    [_imageIcon setImageWithURL:[NSURL URLWithString:lifeModel.cover] placeholderImage:[UIImage imageNamed:@"image_cache"]];
//    _title.text = lifeModel.title;
//    
//    _author.text = lifeModel.topicName;
//    
//    //  格式化时间
//    NSDate * now = [NSDate dateWithTimeIntervalSince1970:lifeModel.length.floatValue];
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
//    formatter.dateFormat = @"mm:ss";
//    NSString * data = [formatter stringFromDate:now];
//
//    _date.text = data;
    
    [_imageIcon setImageWithURL:[NSURL URLWithString:lifeModel.image] placeholderImage:[UIImage imageNamed:@"image_cache"]];
    _title.text = lifeModel.title;
    
    _author.text = lifeModel.playTime;
    
    //  格式化时间
    NSDate * now = [NSDate dateWithTimeIntervalSince1970:lifeModel.video_size.floatValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = @"mm:ss";
    NSString * data = [formatter stringFromDate:now];
    
    _date.text = data;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
