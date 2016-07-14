//
//  JYShowNoteViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYShowNoteViewController.h"

@interface JYShowNoteViewController ()

//  展示标题
@property (nonatomic, strong) UILabel * titleLabel;
//  展示时间
@property (nonatomic, strong) UILabel * dateLabel;
//  展示内容
@property (nonatomic, strong) UITextView * contentView;

@end

@implementation JYShowNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self willShowTheBGImgae:NO];
    
}
#pragma mark - 创建界面
- (void)creatUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    _titleLabel.backgroundColor =[UIColor redColor];
//    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width - 20, 30));
    }];
    
    _contentView = [[UITextView alloc] init];
//    _contentView.backgroundColor =[UIColor greenColor];
    _contentView.editable = NO;
//    _contentView.textColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(5);
    }];
}

- (void)setModel:(JYDateDataModel *)model {
    _model = model;
    [self creatUI];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.title, model.date];
    NSLog(@"%@",_titleLabel.text);
    
    _contentView.attributedText = model.content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
