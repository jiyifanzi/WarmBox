//
//  JYTabBarController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYTabBarController.h"

#import "JYNavBaseController.h"

//  天气界面
#import "JYHomeWeatherViewController.h"
#import "JYHomeViewController.h"

//  日历
#import "JYCalendarViewController.h"

//  生活
#import "JYLifeViewController.h"

//  个人中心
#import "JYMeCenterViewController.h"

@interface JYTabBarController ()

@end

@implementation JYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
}

#pragma mark - 创建视图
- (void) creatUI {
    //  天气
    JYHomeViewController * homeWeather = [[JYHomeViewController alloc] init];
//    JYNavBaseController * navWeather = [[JYNavBaseController alloc] initWithRootViewController:homeWeather];
//    navWeather.title = @"天气";
//    navWeather.tabBarItem.image = [[UIImage imageNamed:@"weather"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navWeather.tabBarItem.selectedImage = [[UIImage imageNamed:@"weather_SL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    //  7.6设置选中时文字的颜色
//    NSDictionary * dict2 = @{NSForegroundColorAttributeName : [UIColor colorWithRed:25/255.0 green:178/255.0 blue:25/255.0 alpha:1.0]};
//    [navWeather.tabBarItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
//    
    
    //  日历
    JYCalendarViewController * calendar = [[JYCalendarViewController alloc] init];
//    JYNavBaseController * navCalendar = [[JYNavBaseController alloc] initWithRootViewController:calendar];
//    navCalendar.title = @"日历";
//    navCalendar.tabBarItem.image = [[UIImage imageNamed:@"calendar_SL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navCalendar.tabBarItem.selectedImage = [[UIImage imageNamed:@"calendar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
    //  生活
    JYLifeViewController * life = [[JYLifeViewController alloc] init];
//    JYNavBaseController * navLife = [[JYNavBaseController alloc] initWithRootViewController:life];
//    navLife.title = @"生活";
//    navLife.tabBarItem.image = [[UIImage imageNamed:@"books"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navLife.tabBarItem.selectedImage = [[UIImage imageNamed:@"books_SL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
    
    //  个人中心
    JYMeCenterViewController * meCenter = [[JYMeCenterViewController alloc] init];
//    JYNavBaseController * navMeCenter = [[JYNavBaseController alloc] initWithRootViewController:meCenter];
//    navMeCenter.title = @"设置";
//    navMeCenter.tabBarItem.image = [[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    navMeCenter.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting_SL"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    
    //  存储控制器的数组
    NSArray * viewArray = @[homeWeather, calendar, life, meCenter];
    //  存储标题的数组
    NSArray * titleArray = @[@"天气",@"日历", @"生活", @"设置"];
    //  存储选中时图片的数组
    NSArray * selectedImage = @[@"weather_SL", @"calendar", @"books_SL", @"setting_SL"];
    //  存储未选中的图
    NSArray * imageArray = @[@"weather", @"calendar_SL", @"books", @"setting"];
    
    
    //  存储控制器的数组
    NSMutableArray * navArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < viewArray.count; i++) {
        JYNavBaseController * navTemp = [[JYNavBaseController alloc] initWithRootViewController:viewArray[i]];
        navTemp.title = titleArray[i];
        navTemp.tabBarItem.image = [[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        navTemp.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NSDictionary * dict2 = @{NSForegroundColorAttributeName : [UIColor colorWithRed:6/255.0 green:6/255.0 blue:6/255.0 alpha:1.0]};
        [navTemp.tabBarItem setTitleTextAttributes:dict2 forState:UIControlStateSelected];
        
        //  添加
        [navArray addObject:navTemp];
    }
    
    
    
    self.viewControllers = navArray;

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
