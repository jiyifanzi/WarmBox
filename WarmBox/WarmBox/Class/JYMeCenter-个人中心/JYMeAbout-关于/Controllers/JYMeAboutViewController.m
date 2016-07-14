//
//  JYMeAboutViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/12.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeAboutViewController.h"

@interface JYMeAboutViewController ()<UITableViewDataSource, UITableViewDelegate>

//  关于界面的TableView
@property (nonatomic, strong) UITableView * tableView;
//  关于界面的数据源
@property (nonatomic, strong) NSMutableArray * dataSource;

//  顶部的试图
@property (nonatomic, strong) UIView * appInfo;

//  软件的图标
@property (nonatomic, strong) UIImageView * appIcon;
//  软件版本号
@property (nonatomic, strong) UILabel * appVersion;
//  软件的描述
@property (nonatomic, strong) UILabel * appDesc;

@end

@implementation JYMeAboutViewController

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self willShowTheBGImgae:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUI];
    
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"MeAbout.plist" ofType:nil];
        NSArray * arr = [NSArray arrayWithContentsOfFile:filePath];
        //  设置界面
        [_dataSource addObjectsFromArray:arr];
    }
    return _dataSource;
}

#pragma mark - 创建界面
- (void)creatUI {
    //  创建顶部的视图
    [self creatTopUI];
    
    //  初始化TaleView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //  设置相关的属性
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = _appInfo;

}
#pragma mark - 创建顶部的视图
- (void)creatTopUI {
    _appInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
//    _appInfo.backgroundColor = [UIColor redColor];
    [self.view addSubview:_appInfo];
    
    //  图标
    _appIcon = [[UIImageView alloc] init];
//    _appIcon.backgroundColor = [UIColor greenColor];
    _appIcon.image = [UIImage imageNamed:@"Icon-iPhone-40"];
    
    [_appInfo addSubview:_appIcon];
    [_appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(_appInfo);
        make.top.equalTo(_appInfo.mas_top).offset(20);
//        make.bottom.equalTo(_appInfo.mas_bottom).offset(-60);
        make.left.equalTo(_appInfo.mas_left).offset(Width/2 - 50);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    //  版本号
    _appVersion = [[UILabel alloc] init];
    _appVersion.text = @"暖心盒子bate1.0";
    _appVersion.textAlignment = NSTextAlignmentCenter;
//    _appVersion.backgroundColor = [UIColor whiteColor];
    [_appInfo addSubview:_appVersion];
    [_appVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appIcon.mas_bottom).offset(10);
//        make.bottom.equalTo(_appInfo.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(Width, 30));
        make.left.equalTo(_appInfo.mas_left);
    }];
    //  软件描述
    _appDesc = [[UILabel alloc] init];
    [_appInfo addSubview:_appDesc];
    _appDesc.textAlignment = NSTextAlignmentCenter;
    _appDesc.text = @"暖心盒子致力于让天气变得更加有趣~";
    _appDesc.textColor = [UIColor lightGrayColor];
    [_appDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appVersion.mas_bottom).offset(10);
//        make.bottom.equalTo(_appInfo.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(Width, 30));
        make.left.equalTo(_appInfo.mas_left);
    }];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"about"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"about"];
    }
    NSDictionary * tempDict = self.dataSource[indexPath.row];
    
    cell.textLabel.text = tempDict[@"title"];
    cell.detailTextLabel.text = tempDict[@"detail"];
    cell.imageView.image = [UIImage imageNamed:tempDict[@"image"]];
    
    return cell;
}

//  cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * tempDict = self.dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        //  QQ用户反馈
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = tempDict[@"detail"];
        [JYWeatherTools showMessageWithAlertView:@"QQ群账号已添加到剪切板，请切换到QQ添加"];
    }else if (indexPath.row == 1) {
        //  微博
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2438032664"]];
    }else {
        //  推荐
        [ShareConfig shareConfig];
        [[ShareConfig CNshareHander] shareToPlatformWithContent:@"来自一个萌萌哒的推荐~" Image:tempDict[@"image"] url:nil ViewController:self];
//        [[ShareConfig CNshareHander] shareToPlatformWithTitle:@"来自一个萌萌哒的推荐~" andContent:@"暖心盒子" ViewController:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
