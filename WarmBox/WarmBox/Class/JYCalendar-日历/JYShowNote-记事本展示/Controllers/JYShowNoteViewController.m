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
//  展示类型
@property (nonatomic, strong) UILabel * noteType;
//  展示具体时间
@property (nonatomic, strong) UILabel * nowTime;

//  展示时间
@property (nonatomic, strong) UILabel * dateLabel;
//  展示内容
@property (nonatomic, strong) UITextView * contentView;

@property (nonatomic, strong) UIBarButtonItem * editNote;

@end

@implementation JYShowNoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self willShowTheBGImgae:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

#pragma mark - 创建界面
- (void)creatUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(Width - 20, 30));
    }];
    
    
    //  类型
//    _noteType = [[UILabel alloc] init];
//    _noteType.textAlignment = NSTextAlignmentLeft;
//    _noteType.backgroundColor = [UIColor whiteColor];
//    _noteType.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:_noteType];
//    
//    [_noteType mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(80);
//        make.left.equalTo(self.view).offset(10);
//        make.size.mas_equalTo(CGSizeMake(50, 15));
//    }];
//
//    _nowTime = [[UILabel alloc] init];
//    _nowTime.textAlignment = NSTextAlignmentCenter;
//    _nowTime.backgroundColor = [UIColor whiteColor];
//    _nowTime.font = [UIFont systemFontOfSize:12];
//    [self.view addSubview:_nowTime];
//    
//    
//    
//    [_nowTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(95);
//        make.left.equalTo(self.view).offset(10);
//        make.size.mas_equalTo(CGSizeMake(50, 15));
//    }];
//
    
    _noteType = [[UILabel alloc] init];
    _noteType.textAlignment = NSTextAlignmentCenter;
    _noteType.backgroundColor = [UIColor whiteColor];
    _noteType.font = [UIFont systemFontOfSize:12.0f];
    _noteType.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_noteType];
    [_noteType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    
    
    _contentView = [[UITextView alloc] init];
    _contentView.backgroundColor =[UIColor whiteColor];
    _contentView.editable = NO;
//    _contentView.textColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noteType.mas_bottom).offset(2);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
}

- (void)setModel:(JYDateDataModel *)model {
    _model = model;
    [self creatUI];
    
    if ([model.noteType isEqualToString:@"1"]) {
        _noteType.text = [NSString stringWithFormat:@"记事：%@ %@",model.date, model.nowTime];
    }else if ([model.noteType isEqualToString:@"2"]) {
        _noteType.text = [NSString stringWithFormat:@"生日：%@ %@",model.date, model.nowTime];
    }
    
    NSArray * timeArray = [model.nowTime componentsSeparatedByString:@"-"];
    _nowTime.text = [NSString stringWithFormat:@"%@:%@",timeArray.firstObject, timeArray.lastObject];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
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
