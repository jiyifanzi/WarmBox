//
//  JYWeatherAQISugCell.m
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYWeatherAQISugCell.h"
#import "JYHomeAQISugDetailCell.h"

@interface JYWeatherAQISugCell ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sugTableView;

//  本界面的数据源
@property (nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation JYWeatherAQISugCell

- (void)awakeFromNib {
    // Initialization code
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setModel:(JYWeatherModel *)model {
    _model = model;
    //  获取数据

    NSArray * dataArray = @[self.model.suggestion.drsg, self.model.suggestion.flu, self.model.suggestion.sport, self.model.suggestion.comf, self.model.suggestion.uv, self.model.suggestion.trav];
    [self.dataSource addObjectsFromArray:dataArray];
    
    //  创建界面
    [self creatUI];
}
#pragma mark - 创建界面
- (void)creatUI {
    _sugTableView.delegate = self;
    _sugTableView.dataSource = self;
    _sugTableView.rowHeight = 70;
    //  注册cell
    [_sugTableView registerNib:[UINib nibWithNibName:@"JYHomeAQISugDetailCell" bundle:nil] forCellReuseIdentifier:@"sugCell"];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYHomeAQISugDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sugCell" forIndexPath:indexPath];
    NSArray * titleArray = @[@"穿衣指数", @"感冒指数", @"运动指数", @"舒适程度", @"辐射指数", @"旅游指数"];
    
    cell.model = self.dataSource[indexPath.row];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
