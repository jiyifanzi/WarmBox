//
//  JYHomeViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYHomeViewController.h"

#import "JYHomeAQIViewController.h"
#import "JYHomeWeatherViewController.h"

@interface JYHomeViewController () <UIScrollViewDelegate>
//  管理两个界面的scrolView;
@property (nonatomic, strong) UIScrollView * homeScrollView;
//  首页AQI 空气质量界面
@property (nonatomic, strong) JYHomeAQIViewController * homeAQI;
//  首页天气界面
@property (nonatomic, strong) JYHomeWeatherViewController * homeWeather;

@property (nonatomic, strong) UINavigationController * navHomeWeather;
@property (nonatomic, strong) UINavigationController * navHomeAQI;

@end

@implementation JYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
    
    //  通知中心接受消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableWholeInterFace:) name:JYEnableHomeIterface object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
//
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)enableWholeInterFace:(NSNotification *)not {
    self.view.userInteractionEnabled = [[not object] isEqualToString:@"1"] ? NO:YES;
}

#pragma mark - 创建界面
- (void)creatUI {
    _homeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _homeScrollView.contentSize = CGSizeMake(Width * 2.0f, Height);
    _homeScrollView.bounces = NO;
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.delegate = self;
    //  隐藏下方的滑动条
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_homeScrollView];
    
    _homeWeather = [[JYHomeWeatherViewController alloc] init];
//    _homeWeather.view.frame = CGRectMake(0, 0, Width, Height);
    _navHomeWeather = [[UINavigationController alloc] initWithRootViewController:_homeWeather];
    _navHomeWeather.view.frame = CGRectMake(0, 0, Width, Height);
    
    //  添加子视图
    [_homeScrollView addSubview:_navHomeWeather.view];
    
    _homeAQI = [[JYHomeAQIViewController alloc] init];
//    _homeAQI.view.frame = CGRectMake(Width, 0, Width, Height);
    _navHomeAQI = [[UINavigationController alloc] initWithRootViewController:_homeAQI];
    _navHomeAQI.view.frame = CGRectMake(Width, 0, Width, Height);
    //  添加子视图
    [_homeScrollView addSubview:_navHomeAQI.view];
    
    //  设置homeWeather的代理是homeAQI，为AQI界面的model赋值
    _homeWeather.delegate = _homeAQI;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x / Width == 1) {
//        NSLog(@"第二");
        [_homeAQI requestDayImageWithDate:[JYWeatherTools getNowDataWithFormate:@"yyyy-MM-dd"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JYEnableHomeIterface object:nil];
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
