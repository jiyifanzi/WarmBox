//
//  JYLifeJokerCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYLifeJokerCell.h"


@interface JYLifeJokerCell ()

//  内容
@property (nonatomic, strong) UILabel * contentLabel;
//  图片
@property (nonatomic, strong) UIImageView * iconImageView;
//  来源
@property (nonatomic, strong) UILabel * source;
//  分享按钮
@property (nonatomic, strong) UIButton * share;

@end

@implementation JYLifeJokerCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - 初始化子控件
- (void)initSubViews{
//    //  底部的线
//    UIImageView * imageLine = [[UIImageView alloc] init];
//    imageLine.image = [UIImage imageNamed:@"hourCellBG"];
//    imageLine.clipsToBounds = YES;
//    imageLine.layer.cornerRadius = 15;
//    
//    [self.contentView addSubview:imageLine];
//    
//    [imageLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 10));
//    }];
//    
    
    _contentLabel = [[UILabel alloc] init];
    //  自动换行
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont fontWithName:@"Hiragino Sans GB" size:15.0];
    [self.contentView addSubview:_contentLabel];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleToFill;
    _iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _source = [[UILabel alloc] init];
    _source.textColor = [UIColor lightGrayColor];
    _source.font = [UIFont fontWithName:@"Hiragino Sans GB" size:17.0];
    [self.contentView addSubview:_source];
    
    _share = [UIButton buttonWithType:UIButtonTypeCustom];
    [_share setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
//    [_share setTitle:@"分享" forState:UIControlStateNormal];
//    _share.titleLabel.font = [UIFont fontWithName:@"Hiragino Sans GB" size:15.0];
    //  点击事件
    [_share addTarget:self action:@selector(shareThisJoker) forControlEvents:UIControlEventTouchUpInside];
    
    [_share setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_share];
}

#pragma mark - 为子控件赋值
- (void)setModel:(JYLifeJokerModel *)model {
    _model = model;
    
    _contentLabel.text = model.digest;
    
    [_iconImageView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    
    _source.text = model.source;
    
}


#pragma mark - 为子空间布局
- (void)layoutSubviews {
    [super layoutSubviews];
    [_source mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-5);
    }];
    
    if (self.model.img.length != 0) {
        //  存在图片
//        UIImage * image = self.iconImageView.image;
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
//            //  获取图片的宽高
//            NSArray * WHArray = [self.model.pixel componentsSeparatedByString:@"*"];
//            //  第一个元素为宽 第二个为高
//            CGFloat imageW = [NSString stringWithFormat:@"%@",WHArray.firstObject].floatValue;
//            CGFloat imageH = [NSString stringWithFormat:@"%@",WHArray.lastObject].floatValue;
            make.bottom.equalTo(self).offset(-5);
            
        }];
    }
}

#pragma mark - 分享按钮
- (void)shareThisJoker {
    //
    [[ShareConfig CNshareHander] shareToPlatformWithTitle:@"分享一个好玩的段子" andContent:self.model.digest ViewController:(UIViewController *)self.delegate];
//    
//    [[ShareConfig CNshareHander]shareToPlatformWithContent:@"找到一个好玩的段子..." Image:self.iconImageView.image url:nil ViewController:(UIViewController *)self.delegate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
