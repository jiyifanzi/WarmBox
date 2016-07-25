//
//  JYMainViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//



/*
 主页界面，左滑是个人的设置，主页的天气及其他
 
 */
#import "JYMainViewController.h"

#import "JYTabBarController.h"
#import "JYMeViewController.h"
#import "JYMeSearchCityViewController.h"

#import "JYNavBaseController.h"

@interface JYMainViewController () <UIScrollViewDelegate, JYMeViewDelegate, UITabBarControllerDelegate>

//  主页的TabBarcontrooler
@property (nonatomic, strong) JYTabBarController * homeTabBar;
//  个人的设置
@property (nonatomic, strong) JYMeViewController * meViewController;

//  管理两个界面的ScrollerView
@property (nonatomic, strong) UIScrollView * homeScrollView;

//  个人设置界面的UINav
@property (nonatomic, strong) JYNavBaseController * navMe;


@end

@implementation JYMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    static int i = 0;
    if (i == 0) {
        [self creatUI];
    }
    i++;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollHome) name:@"scrollHome" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCity) name:@"addCity" object:nil];
    
}

#pragma mark - 创建用户界面
- (void)creatUI {
    _homeScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //  个人设置界面占有一半的屏幕宽度
    _homeScrollView.contentSize = CGSizeMake(Width + Width / 2.0f, Height);
    _homeScrollView.bounces = NO;
    _homeScrollView.pagingEnabled = YES;
    _homeScrollView.delegate = self;
    _homeScrollView.tag = 11111;
    //  隐藏下方的滑动条
    _homeScrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_homeScrollView];
    
    _meViewController = [[JYMeViewController alloc] init];
    _meViewController.delegate = self;
    _meViewController.view.frame = CGRectMake(0, 0, Width / 2.0f, Height);
    
    _navMe = [[JYNavBaseController alloc] initWithRootViewController:_meViewController];
    _navMe.view.frame = CGRectMake(0, 0, Width / 2.0f, Height);
    //  添加子视图
    [_homeScrollView addSubview:_navMe.view];
    
    _homeTabBar = [[JYTabBarController alloc] init];
    _homeTabBar.view.frame = CGRectMake(Width / 2.0f, 0, Width, Height);
    _homeTabBar.delegate = self;
    //  添加子视图
    [_homeScrollView addSubview:_homeTabBar.view];
    
    //  设置初始位置
    _homeScrollView.contentOffset = CGPointMake(Width / 2.0f, 0);
}


#pragma mark - UIScrolView的代理方法
//  检测此时的状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 11111) {
//        NSLog(@"%.1f",scrollView.contentOffset.x);
        if (scrollView.contentOffset.x == 0) {
            //  让界面的tabView不能滑动
            [[NSNotificationCenter defaultCenter] postNotificationName:JYEnableHomeIterface object:@"1"];

        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:JYEnableHomeIterface object:@"0"];
        }
    }
}

#pragma mark - tabBar的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 0) {
        self.homeScrollView.scrollEnabled = YES;
    }else {
        self.homeScrollView.scrollEnabled = NO;
    }
}

#pragma mark - JYMedelegate的实现
- (void)pushToSearchController {
    JYMeSearchCityViewController * searchCity = [[JYMeSearchCityViewController alloc] init];
    [self.navigationController pushViewController:searchCity animated:YES];
}

- (void)scrollHome {
    [UIView animateWithDuration:0.4 animations:^{
        _homeScrollView.contentOffset = CGPointMake(Width /2, 0);
    }];
}

- (void)addCity {
    [UIView animateWithDuration:0.4 animations:^{
        _homeScrollView.contentOffset = CGPointMake(0, 0);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"scrollHome" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addCity" object:nil];
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
