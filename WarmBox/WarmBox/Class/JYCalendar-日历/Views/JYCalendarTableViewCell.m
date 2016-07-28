//
//  JYCalendarTableViewCell.m
//  WarmBox
//
//  Created by JiYi on 16/7/21.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYCalendarTableViewCell.h"

@interface JYCalendarTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titlaLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;


@end

@implementation JYCalendarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(JYDateDataModel *)model {
    _model = model;
    
    _titlaLabel.text = model.title;
    if ([model.noteType isEqualToString:@"1"]) {
        _typeLabel.text = @"记事";
        _typeLabel.backgroundColor = [UIColor colorWithRed:0 green:191/255.0 blue:1 alpha:1];
    } else if ([model.noteType isEqualToString:@"2"]) {
        _typeLabel.text = @"生日";
        _typeLabel.backgroundColor = [UIColor orangeColor];
    }
    NSArray * timeArray = [model.nowTime componentsSeparatedByString:@"-"];
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@",timeArray.firstObject, timeArray.lastObject];
    
    _contentLabel.text = [NSString stringWithFormat:@"%@",model.content.string];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _backView.clipsToBounds = YES;
    _backView.layer.cornerRadius = 15;
    
    _typeLabel.clipsToBounds = YES;
    
    _typeLabel.layer.cornerRadius = 5;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
