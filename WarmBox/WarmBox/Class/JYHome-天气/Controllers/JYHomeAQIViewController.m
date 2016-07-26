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
    
    //  获取数据前
    [self getDataFromLocalDB];
    
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

#pragma mark - 从本地数据库找数据 如果有，就直接取，再做请求
- (void)getDataFromLocalDB {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EverDayData"];
    //  创建文件夹
    [fileManager createDirectoryAtPath:FilePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //  从文件夹中找相应的数据，如果有，就读取
    NSArray * fileContents = [fileManager contentsOfDirectoryAtPath:FilePath error:nil];
    if ((fileContents.count == 1 && [fileContents.firstObject isEqualToString:@".DS_Store"]) || fileContents.count == 0) {
        //  没有数据，从网络请求
        return;
    }else {
        //  结归档，设置
        NSMutableData * readDataImage = [NSMutableData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/EverDayImage.plist",FilePath]];
        NSKeyedUnarchiver * unarchiverImage = [[NSKeyedUnarchiver alloc] initForReadingWithData:readDataImage];
        UIImage * image = [unarchiverImage decodeObjectForKey:@"EverDayImage"];
        //  设置
        _backgroundImage.image = image;
        
        NSMutableData * readDataOneWord = [NSMutableData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/EverDayOneWord.plist",FilePath]];
        NSKeyedUnarchiver * unarchiverWord = [[NSKeyedUnarchiver alloc] initForReadingWithData:readDataOneWord];
        NSString * oneWord = [unarchiverWord decodeObjectForKey:@"EverDayOneWord"];
        
        _oneWorld = oneWord;
        
    }
    
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
    
    if (_oneWorld.length != 0 && _backgroundImage.image) {
        return;
    }
    
    [self.requestManager GET:[NSString stringWithFormat:WB_DayImage,date] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //  解析每日图片的东西
        NSDictionary * tempDick = responseObject[@"data"];
        NSString * url = tempDick[@"largeImg"];
        
        NSString * FilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/EverDayData"];
        
        
        [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //  可以获取到image
            //  存入本地
            NSMutableData * data = [NSMutableData data];
            NSKeyedArchiver * modelArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [modelArchiver encodeObject:image forKey:@"EverDayImage"];
            [modelArchiver finishEncoding];
            //  写入
            [data writeToFile:[NSString stringWithFormat:@"%@/EverDayImage.plist",FilePath] atomically:NO];
        }];
        //  添加一句话
        
        _oneWorld = tempDick[@"s"];
        //  将请求到的数据 - 照片+每日推荐的话，归档存入本地 如果没网的话，从本地获取
        
        NSMutableData * data = [NSMutableData data];
        NSKeyedArchiver * modelArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [modelArchiver encodeObject:_oneWorld forKey:@"EverDayOneWord"];
        [modelArchiver finishEncoding];
        [data writeToFile:[NSString stringWithFormat:@"%@/EverDayOneWord.plist",FilePath] atomically:NO];
        
        
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
