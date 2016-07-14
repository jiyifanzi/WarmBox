//
//  JYBaseViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/29.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"

@interface JYBaseViewController () <CLLocationManagerDelegate>



@property (nonatomic, strong) UIImageView * backImage;

@end

@implementation JYBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBGImage) name:@"changBG" object:nil];
//
//    _backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    _backImage.contentMode =UIViewContentModeScaleAspectFill;
//    [self.view addSubview:_backImage];
//    
    _WholeBlueBackImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _WholeBlueBackImage.clipsToBounds = YES;
     _WholeBlueBackImage.alpha = 1;
    _WholeBlueBackImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_WholeBlueBackImage];
    
    [self changeBGImage];

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    //  判断定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位可用");
        //  授权
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            //  询问授权
            [self.locationManager requestWhenInUseAuthorization];
        }
    }else {
        NSLog(@"定位服务不可用");
    }
}

#pragma mark - 改变皮肤
- (void)changeBGImage {

    //  1.获取单例对象
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //  2.读取数据
    NSData * data = [user objectForKey:@"SkinBGImage"];
    
//    __weak __typeof(self)weakSelf = self;
    if (data.length == 0) {
        [_WholeBlueBackImage setImageToBlur:[UIImage imageNamed:@"1.jpg"] completionBlock:^{
//            weakSelf.backImage.image = [UIImage imageWithData:data];
        }];
    }else {
//        [_blueBackImage setImageToBlur:[UIImage imageWithData:data] completionBlock:^{
////            weakSelf.backImage.image = [UIImage imageWithData:data];
//        }];
        [_WholeBlueBackImage setImage:[UIImage imageWithData:data]];
    }
}
#pragma mark - 是否显示背景图
- (void)willShowTheBGImgae:(BOOL)yesOrNo {
    _WholeBlueBackImage.hidden = !yesOrNo;
    _backImage.hidden = !yesOrNo;
}

#pragma mark - 懒加载
//  实例化网络请求管理者
- (AFHTTPSessionManager *)requestManager {
    if (!_requestManager) {
        _requestManager = [AFHTTPSessionManager manager];
        //self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"charset=UTF-8", nil];
        //  更改json解析器的解析支持文件格式
        _requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _requestManager.responseSerializer.acceptableContentTypes = [_requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    }
    return _requestManager;
}

//  实例化定位对象
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        //  设置相关的属性
        //  定位精度：最高
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //  自动过滤距离
        _locationManager.distanceFilter = 2000;
        //  设置定位的用途 -- 只需要拿到当前一瞬间的位置
        _locationManager.activityType = CLActivityTypeOther;
        //  设置代理
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (NSMutableArray *)locationArray {
    if (!_locationArray) {
        _locationArray = [NSMutableArray array];
    }
    return _locationArray;
}


#pragma mark - 开始定位
- (void)startLocation {
    [self.locationManager startUpdatingLocation];
    [KVNProgress showWithStatus:@"正在定位"];
    
//    [SVProgressHUD showWithStatus:@"正在定位..."];
}

#pragma mark - 定位服务的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //  获取当前定位的东西
    //  经纬度
    CLLocationCoordinate2D coord = newLocation.coordinate;
 
    //  转码
    [JYGencoder getAddressWithCoordinate:coord didFinish:^(NSDictionary *infoDict) {
        
//        [SVProgressHUD showSuccessWithStatus:@"定位成功"];
        [KVNProgress showSuccessWithStatus:@"定位成功"];
        NSMutableString * cityName = infoDict[@"City"];
        NSString * city = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
        self.currentLocation = city;
        //NSLog(@"%@",cityName);
        //NSLog(@"%@",self.currentLocation);
        [self.locationArray addObject:self.currentLocation];
        //  发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WB_StrartCityName" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:JYGetDataFromDB object:nil];
        
        [JYWeatherTools changeCityLocationValueWithCityName:city];
        //  定位到的城市数据，存到数据库
        //  存入前，先检查是否已经有当前城市数据
        if ([[JYBasicDataManager new] checkIsInDBWithCityName:city]) {
            //  如果有收藏，就不管
            NSLog(@"===数据已经存在 %@",city);
           
            
        }else  {
            //  没有就存入数据库
            [[JYBasicDataManager new] insertDataWithCityName:city andLocation:@"1"];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    [SVProgressHUD showErrorWithStatus:@"定位失败,请检查网络或者稍后再试"];
    [KVNProgress showErrorWithStatus:@"定位失败，请检查网络或者稍后再试"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changBG" object:nil];
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
