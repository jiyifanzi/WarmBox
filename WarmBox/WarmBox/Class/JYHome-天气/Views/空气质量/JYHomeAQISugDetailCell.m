//
//  JYHomeAQISugDetailCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/2.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeAQISugDetailCell.h"

@interface JYHomeAQISugDetailCell ()


@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@end

@implementation JYHomeAQISugDetailCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(JYWeatherSugDescModel *)model {
    _model = model;
    
    _detailTitle.text = model.brf;
    
    _descLabel.text = model.txt;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
