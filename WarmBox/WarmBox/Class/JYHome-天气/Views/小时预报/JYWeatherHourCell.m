//
//  JYWeatherHourCell.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherHourCell.h"

@interface JYWeatherHourCell()

//  时间
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//  温度
@property (weak, nonatomic) IBOutlet UILabel *tmpLabel;
//  湿度
@property (weak, nonatomic) IBOutlet UILabel *humLabel;
//  降水概率
@property (weak, nonatomic) IBOutlet UILabel *popLabel;



@end

@implementation JYWeatherHourCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHourlyModel:(JYWeatherHourlyModel *)hourlyModel {
    _hourlyModel = hourlyModel;
    
    //  设置本cell的相关属性
    NSArray * dataStrArray = [hourlyModel.date componentsSeparatedByString:@"-"];
    
    NSMutableString * dataStr = [NSMutableString string];
    
    for (NSString * str in dataStrArray) {
        if (str.length == 4) {
            
        }else {
            [dataStr appendString:str];
        }
    }
    _dateLabel.text = [dataStr copy];
    
    _tmpLabel.text = [NSString stringWithFormat:@"%@℃",hourlyModel.tmp];
    
    if (hourlyModel.hum.length == 0) {
        
    }else {
        _humLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_hum"] andText:hourlyModel.hum];
    }
    
    if (hourlyModel.pop.length == 0) {
        
    }else {
        _popLabel.attributedText = [self mixImage:[UIImage imageNamed:@"top_tmp"] andText:hourlyModel.pop];
    }
    
    //_humLabel.text = hourlyModel.hum;
    //_popLabel.text = hourlyModel.pop;
}

#pragma mark - 富文本的排列方式
- (NSAttributedString *)mixImage:(UIImage *)image andText:(NSString *)text
{
    // 用富文本实现图文混排
    // 将图片转换为文本附件对象
    NSTextAttachment * commentAttachment = [[NSTextAttachment alloc] init];
    commentAttachment.image = image;
    // 将文本附件对象转换为富文本
    NSAttributedString * commentAttachAttr = [NSAttributedString attributedStringWithAttachment:commentAttachment];
    // 将文字转换为富文本
    NSAttributedString * commentCountAttr = [[NSAttributedString alloc] initWithString:text  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
    // 拼接所有富文本
    NSMutableAttributedString * commentAttr = [[NSMutableAttributedString alloc] init];
    [commentAttr appendAttributedString:commentAttachAttr];
    [commentAttr appendAttributedString:commentCountAttr];
    return [commentAttr copy];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
