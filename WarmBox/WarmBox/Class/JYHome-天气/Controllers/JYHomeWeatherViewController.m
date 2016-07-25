//
//  JYHomeWeatherViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeWeatherViewController.h"

#import "JYWeatherNowHeaderView.h"

#import "JYWeatherNewHourCell.h"

#import "JYWeatherDailyCell.h"
#import "JYWeatherAQISugCell.h"

#import "JYHomeAQIWeatherView.h"

@interface JYHomeWeatherViewController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

//  天气界面的TableView
@property (nonatomic, strong) UITableView * weatherTableView;
//  天气界面的数据源
@property (nonatomic, strong) NSMutableArray * weathDataSource;

@property (nonatomic, strong) NSString * currentCityName;

//  顶部的视图
@property (nonatomic, strong) JYWeatherNowHeaderView * topView;
//  顶部的天气视图
@property (nonatomic, strong) JYHomeAQIWeatherView * aqiHeaderView;

//  背景图
@property (nonatomic, strong) UIImageView * backImageView;
//  模糊图层
@property (nonatomic, strong) UIImageView * blurImageView;

@property (nonatomic, strong) UIView * viewTotal;

@property (nonatomic, strong) NSString * weather_CityName;

//  刷新按钮
@property (nonatomic, strong) UIBarButtonItem * refreshBtnItem;
//  添加按钮
@property (nonatomic, strong) UIBarButtonItem * addBtnItem;



@property (nonatomic, strong) CAEmitterLayer * fireEmitter;

@end

@implementation JYHomeWeatherViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
//    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"天气";
    
    
    //  添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startCityName) name:@"WB_StrartCityName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelfModle:) name:@"changeSelfModel" object:nil];
    

    [self creatUI];
    //  初始加载数据
    NSArray * dataArr = [[JYBasicDataManager new] getAllData];
    NSMutableArray * dataArrFor = [NSMutableArray array];
    for (NSString * tempStr in dataArr) {
        NSArray *seqArr = [tempStr componentsSeparatedByString:@"+"];
        [dataArrFor addObject:[seqArr firstObject]];
    }
    //  查询数据 找出定位的数据
    NSString * str = [[JYBasicDataManager new] findLocationInDB];
    
    if (str.length != 0) {
        [self requestDataWithCityName:str];
    }

    
    //  首次启动界面
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        
        [self startLocation];
    }else{
        NSLog(@"不是第一次启动");

    }
}

#pragma mark - 懒加载
- (NSMutableArray *)weathDataSource {
    if (!_weathDataSource) {
        _weathDataSource = [NSMutableArray array];
    }
    return _weathDataSource;
}

#pragma mark - 通知中心的方法
- (void)startCityName {
    [self requestDataWithCityName:self.currentLocation];
}

- (void)changeSelfModle:(NSNotification *)notification {
    NSLog(@"%@",[notification object]);
    
    [self requestDataWithCityName:[notification object]];
    [UIView animateWithDuration:0.3 animations:^{
        //  让顶部视图位
        self.topView.frame = CGRectMake(0, 64, Width, 200);
        self.weatherTableView.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - 请求数据
- (void)requestDataWithCityName:(NSString *)cityName {

    //  更改编码
    NSString * cityNameStr = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.requestManager.responseSerializer.acceptableContentTypes = [self.requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [self.requestManager.requestSerializer setValue:@"66bc66db9d0b9dcc7b9a4c712830549a" forHTTPHeaderField:@"apikey"];
    
    //  请求数据
    [self.requestManager GET:[NSString stringWithFormat:WB_Weather,cityNameStr] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * dataArray = responseObject[@"HeWeather data service 3.0"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYWeatherModel class] json:dataArray];

        //  清空数据
        [self.weathDataSource removeAllObjects];
        
        //  添加数据
        [self.weathDataSource addObjectsFromArray:modelArray];
        
        //  设置顶部的图片
        [self setTopViewImage];
        
        //  让代理去设置model
        [self.delegate setAqiModel:[modelArray firstObject]];
        
        [self.weatherTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 创建界面
- (void)creatUI {
    //  创建UINavgationBarItem
//    UIImage * image = [[UIImage alloc] init];
    
    _refreshBtnItem.tintColor = [UIColor whiteColor];
    _refreshBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"auto_location_icon_img"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]  style:UIBarButtonItemStyleDone target:self action:@selector(refershButtonClick)];
    self.navigationItem.rightBarButtonItem = _refreshBtnItem;
    
    //  添加按钮
    _addBtnItem.tintColor = [UIColor whiteColor];
    _addBtnItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"CommonAdd2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStyleDone target:self action:@selector(addButtonClick)];
    self.navigationItem.leftBarButtonItem = _addBtnItem;

    
    // 设置初始的背景图片
    _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backImageView.image = [UIImage imageNamed:@"sunny.jpg"];
    [self.view addSubview:_backImageView];
    //  设置初始的背景模糊效果
    _blurImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _blurImageView.alpha = 0;
    [_blurImageView setImageToBlur:[UIImage imageNamed:@"sunny.jpg"] completionBlock:nil];
    [self.view addSubview:_blurImageView];
    
    
    _viewTotal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _viewTotal.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewTotal];
    

    
    //  初始化 UITableVIew
    _weatherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height) style:UITableViewStylePlain];
    [self.view addSubview:_weatherTableView];

    _weatherTableView.backgroundColor = [UIColor clearColor];
    //  设置相关的属性
    _weatherTableView.delegate = self;
    _weatherTableView.dataSource = self;
    _weatherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _weatherTableView.showsHorizontalScrollIndicator = NO;
    _weatherTableView.showsVerticalScrollIndicator = NO;

    //  注册cell
    //  1.小时预告
    //  1.1新小时预报
    [_weatherTableView registerNib:[UINib nibWithNibName:@"JYWeatherNewHourCell" bundle:nil] forCellReuseIdentifier:@"hourCell"];
    
    //  2.每天预告
    [_weatherTableView registerNib:[UINib nibWithNibName:@"JYWeatherDailyCell" bundle:nil] forCellReuseIdentifier:@"dailyCell"];
    //  3.每日建议
    [_weatherTableView registerNib:[UINib nibWithNibName:@"JYWeatherAQISugCell" bundle:nil] forCellReuseIdentifier:@"sugCell"];
    
    //  设置相关的headerView
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 200)];
    view.backgroundColor = [UIColor clearColor];
    _weatherTableView.tableHeaderView = view;

    _topView = [[JYWeatherNowHeaderView alloc] initWithFrame:CGRectMake(0, 64, Width, 200)];
    _topView.clipsToBounds = YES;
    _topView.backgroundColor = [UIColor clearColor];
    [self.viewTotal addSubview:_topView];
    
//    _topView.backgroundColor = [UIColor grayColor];
}

#pragma mark - 刷新
- (void)refershButtonClick {
    [self startLocation];
}

#pragma mark - 添加
- (void)addButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addCity" object:nil];
}


#pragma mark - 设置顶部的图片
- (void)setTopViewImage{
    JYWeatherModel * model = [self.weathDataSource firstObject];

    NSString * imageName = [JYWeatherTools getBackImageNameWithWeatherNumber:model.now.cond.code];
    
    UIImage * backImage = [UIImage imageNamed:imageName];
    
    _backImageView.image = nil;
    _backImageView.image = backImage;
    
    
    _blurImageView.alpha = 0;
    if (backImage) {
        [_blurImageView setImageToBlur:backImage completionBlock:nil];
    }
    
    [_topView removeFromSuperview];
    [_aqiHeaderView removeFromSuperview];
    
    _topView = [[JYWeatherNowHeaderView alloc] initWithFrame:CGRectMake(0, 64, Width, 200)];
    _topView.clipsToBounds = YES;
    _topView.backgroundColor = [UIColor clearColor];
    _topView.model = model;
    [self.viewTotal addSubview:_topView];
    
    _aqiHeaderView  = [[JYHomeAQIWeatherView alloc] initWithFrame:CGRectMake(0, 64, Width, 80)];
    _aqiHeaderView.backgroundColor = [UIColor clearColor];
    _aqiHeaderView.alpha = 0;
    _aqiHeaderView.layer.masksToBounds = YES;
    _aqiHeaderView.layer.cornerRadius = 10;
    
    _aqiHeaderView.model = model;
    _aqiHeaderView.backgroundImage.image = backImage;
    
    [_aqiHeaderView removeFromSuperview];

    [self.view addSubview:_aqiHeaderView];
}

#pragma mark - UITableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    //  第一组 每小时的天气预报
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JYWeatherModel * model = [self.weathDataSource firstObject];
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        if (model.suggestion) {
            return 1;
        }
        return 0;
    }
    return 2;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        //  小时预报时有返回
//        UIView * hourDescView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//        
//        NSArray * labelName = @[@"  时间", @"温度", @"湿度", @"降水概率"];
//        for (int i = 0; i < 4; i++) {
//            UILabel * tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width / 4, 0, self.view.frame.size.width / 4, 20)];
//            tempLabel.text = labelName[i];
//            tempLabel.textAlignment = NSTextAlignmentCenter;
//            tempLabel.textColor = [UIColor whiteColor];
//            [hourDescView addSubview:tempLabel];
//        }
//        
//        
//        return hourDescView;
//    }
//    
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        JYWeatherModel * model = [self.weathDataSource firstObject];
//        if (model.hourly_forecast.count == 0) {
//            return 0;
//        }
//        
//        return 0;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYWeatherModel * model = [self.weathDataSource firstObject];

    //  如果是第一段，表示是小时预报
    if (indexPath.section == 0) {
        
        
//        JYWeatherHourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hourCell" forIndexPath:indexPath];
//        
//               //  设置背景图片的透明度
//        if (model) {
//            cell.bgImageView.alpha = 1;
//        }
//        cell.hourlyModel = model.hourly_forecast[indexPath.row];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
        JYWeatherNewHourCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hourCell" forIndexPath:indexPath];
        
        //  设置背景图片的透明度
        if (model) {
            cell.bgImageView.alpha = 1;
        }
        
        cell.modelArray = model.hourly_forecast;
        
        NSLog(@"%@",cell.modelArray);
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.section == 1) {
        //  如果是第二段，表示是每天的预报
        JYWeatherDailyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dailyCell" forIndexPath:indexPath];
        cell.modelArray = model.daily_forecast;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if (indexPath.section == 2) {
        //  如果是第三段，表示是今日AQI信息
        JYWeatherAQISugCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sugCell" forIndexPath:indexPath];
        cell.model = model;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    JYWeatherModel * model = [self.weathDataSource firstObject];
//    _aqiHeaderView  = [[JYHomeAQIWeatherView alloc] initWithFrame:CGRectMake(10, 0, Width - 20, 100) andModel:model];
//    _aqiHeaderView.backgroundColor = [UIColor whiteColor];
//    _aqiHeaderView.alpha = 0;
//    return _aqiHeaderView;
//}
//  设置头的距离
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 100;
//    }
//    return 0;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     JYWeatherModel * model = [self.weathDataSource firstObject];
    if (indexPath.section == 0) {
        if (model.hourly_forecast.count == 0) {
            return 0;
        }
        return 200;
    }else if (indexPath.section == 1) {
        return 260;
    }else if (indexPath.section == 2) {
        if (model.suggestion) {
            return 280;
        }
        return 0;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.weatherTableView.contentOffset.y < 0) {
        
        CGRect frame = self.topView.frame;
        frame.size.height = 200 - scrollView.contentOffset.y;
        self.topView.frame = frame;
        self.weatherTableView.frame = CGRectMake(0, 64, Width, Height);
        
    }else if(self.weatherTableView.contentOffset.y > 0 && self.weatherTableView.contentOffset.y < 200){
        
        
        CGRect frame = self.topView.frame;
        frame.size.height = 200 - scrollView.contentOffset.y;
        self.topView.frame = frame;
    }

    
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
    
//    NSLog(@"%.1f",percent);
    
    self.blurImageView.alpha = percent;
    self.aqiHeaderView.alpha = percent * 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WB_StrartCityName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeSelfModel" object:nil];
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
