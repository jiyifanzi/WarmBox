//
//  JYHomeAQIViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeAQIViewController.h"

#import "JYHomeAQIWeatherView.h"
#import "JYHomeAQIDataView.h"

#import "JYHomeAQISugDetailCell.h"
#import "JYWeatherNowHeaderView.h"

#import "JYDayImageView.h"

@interface JYHomeAQIViewController ()<UITableViewDataSource, UITableViewDelegate>

//  顶部的天气视图
@property (nonatomic, strong) JYHomeAQIWeatherView * aqiHeaderView;
//  顶部的AQI数据视图
@property (nonatomic, strong) JYHomeAQIDataView * aqiDataView;
//  最后的建议视图
@property (nonatomic, strong) UITableView * aqiSugTableView;
@property (nonatomic, strong) NSMutableArray * sugDataSource;

@property (nonatomic, strong) UIImageView * backgroundImage;
@property (nonatomic, strong) UIImageView * blurBackImage;


//  顶部的视图
@property (nonatomic, strong) JYWeatherNowHeaderView * topView;

@property (nonatomic, strong) JYDayImageView * dayImageView;

@property (nonatomic, strong) NSString * oneWorld;


@property (nonatomic, strong) UIBarButtonItem * downLoadItem;

@end

@implementation JYHomeAQIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
    
    NSDate * now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * data = [formatter stringFromDate:now];
    [self requestDayImageWithDate:data];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSDate * now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString * data = [formatter stringFromDate:now];
    NSLog(@"=====%@",data);
    //  根据当前日期来设置图片
    
    //  给backGroundImage和blurBackImage设置图片
    _backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //  缓存
    _backgroundImage.image = [UIImage imageNamed:@"aqi_bg.jpg"];
    
    [self.view addSubview:_backgroundImage];
    
    //  暂时不加透明层
    _blurBackImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _blurBackImage.alpha = 0.2;
//    [_blurBackImage setImageToBlur:_backgroundImage.image completionBlock:nil];
    [self.view addSubview:_blurBackImage];
    
    _downLoadItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"downLoad"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(downloadClick)];
    self.navigationItem.rightBarButtonItem = _downLoadItem;
}

#pragma mark - 下载图片
- (void)downloadClick {
    //截图
    //    UIView* cutView = self.view.window.rootViewController.view;
    UIView* cutView = self.view;
    //开启上下文
    //    UIGraphicsBeginImageContext(cutView.frame.size);
    UIGraphicsBeginImageContextWithOptions(cutView.frame.size, NO, 0.0);
    //将cutview的图层渲染到上下文中
    [cutView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //取出uiimage
    UIImage* image= UIGraphicsGetImageFromCurrentImageContext();
    
    //  保存图片
    NSLog(@"%@",image);
    //  回到主线程保存图片
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
    
    //结束上下文
    UIGraphicsEndImageContext();
}
#pragma mark - 图片保存完成后调用的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    [SVProgressHUD showSuccessWithStatus:@"保存成功，请到相册查看"];
    [KVNProgress showSuccessWithStatus:@"保存成功，请到相册查看"];
}



- (void)setModel:(JYWeatherModel *)model {
    if (model) {
        _model = model;
        [self creatUI];
    }
}
#pragma mark - 获取每日推荐图片
- (void)requestDayImageWithDate:(NSString *)date {
    [self.requestManager GET:[NSString stringWithFormat:WB_DayImage,date] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //  解析每日图片的东西
        NSDictionary * tempDick = responseObject[@"data"];
        NSString * url = tempDick[@"largeImg"];
        
        [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:url]];
        //  添加一句话
        _oneWorld = tempDick[@"s"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //  隐藏上下的状态栏
//    self.tabBarController.tabBar.hidden = YES;
}


#pragma mark - homeWeather的代理方法
- (void)setAqiModel:(JYWeatherModel *)model {
    self.model = model;
}

#pragma mark - 懒加载
- (NSMutableArray *)sugDataSource {
    if (!_sugDataSource) {
        _sugDataSource = [NSMutableArray array];
    }
    return _sugDataSource;
}

#pragma mark - 创建视图界面
- (void)creatUI {
//    [_topView removeFromSuperview];
//    
//    _topView = [[JYWeatherNowHeaderView alloc] initWithFrame:CGRectMake(0, 0, Width, 160)];
//    _topView.clipsToBounds = YES;
//    _topView.backgroundColor = [UIColor clearColor];
//    _topView.model = self.model;
//    [self.view addSubview:_topView];
//    //  添加约束
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-44);
//        make.left.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(Width, 160));
//    }];
    [_dayImageView removeFromSuperview];
    _dayImageView = [[JYDayImageView alloc] init];
    [self.view addSubview:_dayImageView];
    
    //  确定当前日期
    NSDate * now = [NSDate date];
    NSDateFormatter * formatterM = [[NSDateFormatter alloc] init];
    formatterM.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatterM.dateFormat = @"MM";
    
    
    NSDateFormatter * formatterD = [[NSDateFormatter alloc] init];
    formatterD.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatterD.dateFormat = @"dd";
    
    NSString * Month = [formatterM stringFromDate:now];
    NSString * Day = [formatterD stringFromDate:now];
    
    
    
    _dayImageView.dateDay.text = Day;
    _dayImageView.dateMonth.text = Month;
    _dayImageView.oneWord.text = _oneWorld;
    _dayImageView.weather.text = self.model.now.cond.txt;
    _dayImageView.cityName.text = self.model.basic.city;
    
    //  添加约束
    [_dayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-44);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(Width, 160));
    }];
    
//    //  移除所有的视图
//    for (UIView * tempView in self.view.subviews) {
//        if ([tempView isKindOfClass:[UIImageView class]]) {
//            
//        }else {
//            [tempView removeFromSuperview];
//        }
//        
//    }
//    
//    //    _backgroundImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //    _backgroundImage.image = [UIImage imageNamed:@"aqi_bg.jpg"];
//    //    [self.view addSubview:_backgroundImage];
//    //
//    //    _blurBackImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    //    _blurBackImage.alpha = 0.4;
//    //    [_blurBackImage setImageToBlur:_backgroundImage.image completionBlock:nil];
//    //    [self.view addSubview:_blurBackImage];
//    
//    _aqiHeaderView = [[JYHomeAQIWeatherView alloc] initWithFrame:CGRectMake(0, 20, Width, 100) andModel:self.model];
//    _aqiHeaderView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_aqiHeaderView];
//    
//    
//    
//    _aqiDataView = [[JYHomeAQIDataView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) andModel:self.model];
//    [self.view addSubview:_aqiDataView];
//    //  添加约束
//    if (self.model.aqi.city.aqi.length == 0) {
//        //  判断此时是否存在aqi
//        //  如果不存在
//        if (self.model.suggestion) {
//            [self.sugDataSource removeAllObjects];
//            //  如果存在suggestio
//            NSArray * dataArray = @[self.model.suggestion.drsg, self.model.suggestion.flu, self.model.suggestion.sport, self.model.suggestion.comf, self.model.suggestion.uv, self.model.suggestion.trav];
//            [self.sugDataSource addObjectsFromArray:dataArray];
//            
//            //  创建UITableView
//            _aqiSugTableView = [[UITableView alloc] init];
//            [self.view addSubview:_aqiSugTableView];
//            
//            //  设置相关属性
//            _aqiSugTableView.delegate = self;
//            _aqiSugTableView.dataSource = self;
//            _aqiSugTableView.rowHeight = 80;
//            _aqiSugTableView.backgroundColor = [UIColor clearColor];
//            [_aqiSugTableView registerNib:[UINib nibWithNibName:@"JYHomeAQISugDetailCell" bundle:nil] forCellReuseIdentifier:@"sugCell"];
//            //  约束
//            [_aqiSugTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_aqiHeaderView.mas_bottom).offset(5);
//                make.left.equalTo(self.view);
//                make.size.mas_equalTo(CGSizeMake(Width, self.view.frame.size.height - _aqiHeaderView.frame.origin.y - _aqiHeaderView.frame.size.height - 100));
//            }];
//            
//        }else {
//            //  没有suggestion
//        }
//        
//        
//    }else {
//        if (self.model.suggestion) {
//            [self.sugDataSource removeAllObjects];
//            //  如果存在suggestio
//            NSArray * dataArray = @[self.model.suggestion.drsg, self.model.suggestion.flu, self.model.suggestion.sport, self.model.suggestion.comf, self.model.suggestion.uv, self.model.suggestion.trav];
//            [self.sugDataSource addObjectsFromArray:dataArray];
//            
//            //  创建UITableView
//            _aqiSugTableView = [[UITableView alloc] init];
//            [self.view addSubview:_aqiSugTableView];
//            
//            //  设置相关属性
//            _aqiSugTableView.delegate = self;
//            _aqiSugTableView.dataSource = self;
//            _aqiSugTableView.rowHeight = 80;
//            _aqiSugTableView.backgroundColor = [UIColor clearColor];
//            [_aqiSugTableView registerNib:[UINib nibWithNibName:@"JYHomeAQISugDetailCell" bundle:nil] forCellReuseIdentifier:@"sugCell"];
//            //  约束
//            [_aqiDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_aqiHeaderView.mas_bottom).offset(5);
//                make.left.equalTo(self.view);
//                make.size.mas_equalTo(CGSizeMake(Width/4, 200));
//            }];
//            
//            //  约束
//            [_aqiSugTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_aqiDataView.mas_bottom).offset(5);
//                make.left.equalTo(self.view);
//                CGFloat aqiSugH = Height - 20 - 100 - 5 - 200 - 60;
//                make.size.mas_equalTo(CGSizeMake(Width, aqiSugH));
//            }];
//            
//        }else {
//            //  没有suggestion
//            [_aqiDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(_aqiHeaderView.mas_bottom).offset(5);
//                make.left.equalTo(self.view);
//                make.size.mas_equalTo(CGSizeMake(Width/3, 200));
//            }];
//        }
//        
//    }
    
}
#pragma mark tanleView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sugDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYHomeAQISugDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sugCell" forIndexPath:indexPath];
    NSArray * titleArray = @[@"穿衣指数", @"感冒指数", @"运动指数", @"舒适程度", @"辐射指数", @"旅游指数"];
    
    cell.model = self.sugDataSource[indexPath.row];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 10;
    
    return cell;
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
