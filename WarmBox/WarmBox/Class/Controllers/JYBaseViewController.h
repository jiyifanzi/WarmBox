//
//  JYBaseViewController.h
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYBaseViewController : UIViewController

//  网络请求管理者
@property (nonatomic, strong) AFHTTPSessionManager * requestManager;

//  定位的对象
@property (nonatomic, strong) CLLocationManager * locationManager;

//  当前的位置
@property (nonatomic, strong) NSString * currentLocation;
@property (nonatomic, strong) NSMutableArray * locationArray;

@property (nonatomic, strong) UIImageView * WholeBlueBackImage;
//  开始定位
- (void)startLocation;

//  是否显示背景图
- (void)willShowTheBGImgae:(BOOL)yesOrNo;
@end
