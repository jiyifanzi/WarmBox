//
//  JYMeViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeViewController.h"
#import "JYMeSearchCityViewController.h"

#import "JYMeCityCell.h"
#import "JYSkinViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

@interface JYMeViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

//  用户头像
@property (nonatomic, strong) UIButton * iconImage;
//  用户资料
@property (nonatomic, strong) UIButton * userDataBtn;
//  用户设置
@property (nonatomic, strong) UIButton * userSetBtn;

//  管理城市界面的collection
@property (nonatomic, strong) UICollectionView * citysCollectionView;
//  存储城市的数据源
@property (nonatomic, strong) NSMutableArray * cityDataSource;

@property (nonatomic, strong) NSMutableArray * cityNameDataSource;

//  判断是否在抖动，（是否处在编辑的状态）
@property (nonatomic, assign) BOOL isEditting;

@end

@implementation JYMeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
    [self getDataFromDB];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    //  注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromDB) name:JYGetDataFromDB object:nil];
    
    [self creatUserInterface];
    
    [self creatUI];
}

#pragma mark - 懒加载
- (NSMutableArray *)cityDataSource {
    if (!_cityDataSource) {
        _cityDataSource = [NSMutableArray array];
    }
    return _cityDataSource;
}
- (NSMutableArray *)cityNameDataSource {
    if (!_cityNameDataSource) {
        _cityNameDataSource = [NSMutableArray array];
    }
    return _cityNameDataSource;
}

#pragma mark - 从数据库获取数据
- (void)getDataFromDB {
    
//    [self.cityNameDataSource removeAllObjects];
    
    NSArray * arr = [[JYBasicDataManager new] getAllData];
    
    
    NSMutableArray * dataArrFor = [NSMutableArray array];
    for (NSString * tempStr in arr) {
        NSArray *seqArr = [tempStr componentsSeparatedByString:@"+"];
        [dataArrFor addObject:[seqArr firstObject]];
    }
    
    for (NSString * temp in dataArrFor) {
        [self requestDataWithCityName:temp];
    }

//    [self.cityNameDataSource addObjectsFromArray:dataArrFor];
//    [self.citysCollectionView reloadData];
    
    if (self.cityNameDataSource.count == 0) {
        [self.cityNameDataSource addObjectsFromArray:dataArrFor];
    }
    //  添加前进行循环遍历，看看是否有新增元素，有的话，放在最后面
    if (self.cityNameDataSource.count < dataArrFor.count) {
        //  只添加最后一个
        [self.cityNameDataSource addObject:[dataArrFor lastObject]];
        [self requestDataWithCityName:[dataArrFor lastObject]];
    }
    
    [self.citysCollectionView reloadData];
}

#pragma mark - 以城市名称获取数据

- (void)requestDataWithCityName:(NSString *)cityName {
    //  更改编码
    NSString * cityNameStr = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.requestManager.responseSerializer.acceptableContentTypes = [self.requestManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    [self.requestManager.requestSerializer setValue:@"66bc66db9d0b9dcc7b9a4c712830549a" forHTTPHeaderField:@"apikey"];
    
    //  请求数据
    [self.requestManager GET:[NSString stringWithFormat:WB_Weather,cityNameStr] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * dataArray = responseObject[@"HeWeather data service 3.0"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYWeatherModel class] json:dataArray];
        
        [self.cityDataSource addObject:[modelArray firstObject]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 创建全局视图
- (void)creatUI {
    //  创建布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //  创建collection
    _citysCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 130, Width / 2, 180) collectionViewLayout:layout];
    [self.view addSubview:_citysCollectionView];
    //  设置相关的属性
    _citysCollectionView.delegate = self;
    _citysCollectionView.dataSource = self;
    _citysCollectionView.backgroundColor = [UIColor clearColor];

    
    //  注册cell
    [_citysCollectionView registerNib:[UINib nibWithNibName:@"JYMeCityCell" bundle:nil] forCellWithReuseIdentifier:@"cityCell"];
    
    
    //  创建刷新按钮
    UIButton * buttonRE = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRE setBackgroundImage:[UIImage imageNamed:@"wea_home page_refresh"] forState:UIControlStateNormal];
    [buttonRE addTarget:self action:@selector(getDataFromDB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonRE];
    
    //  添加约束
    [buttonRE mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    //  创建皮肤按钮
    UIButton * buttonSkin = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSkin setBackgroundImage:[UIImage imageNamed:@"icon_skin_sort_01"] forState:UIControlStateNormal];
    [buttonSkin addTarget:self action:@selector(skinSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSkin];
    //  添加约束
    [buttonSkin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view.mas_left).offset(10);
    }];
}
#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cityNameDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    JYMeCityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCell" forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 15;
    
    //  如果处在编辑状态
    if (self.isEditting) {
        //  让图标抖动
        cell.closeButton.hidden = NO;
        cell.transform = CGAffineTransformMakeRotation(-0.05);
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionLayoutSubviews|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            cell.transform = CGAffineTransformMakeRotation(0.05);
        } completion:nil];
        //  为删除按钮添加点击事件
        [cell.closeButton addTarget:self action:@selector(delegeCity:) forControlEvents:UIControlEventTouchUpInside];
        cell.closeButton.tag = 100 + indexPath.row;
    }else {
        cell.closeButton.hidden = YES;
        //  让形变清零
        cell.transform = CGAffineTransformIdentity;
    }
    
    cell.cityName = self.cityNameDataSource[indexPath.row];
    
    //  出来是一个城市名
    NSString * locationCityName = [[JYBasicDataManager new] findLocationInDB];
    //  确定location图标
    if ([locationCityName isEqualToString:cell.cityName]) {
        cell.location.hidden=  NO;
    }else {
        cell.location.hidden = YES;
    }

    for (JYWeatherModel * tempModel in self.cityDataSource) {
        if ([tempModel.basic.city isEqualToString:cell.cityName]) {
            cell.model = tempModel;
        }
    }
 

    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //算宽高
    CGFloat cellW = (Width/2) / 2 - 5;
    CGFloat cellH = 45;
    
    return CGSizeMake(cellW, cellH);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//  collection的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    
    NSString * cityName = self.cityNameDataSource[indexPath.row];
    //  改变city的location值
    [JYWeatherTools changeCityLocationValueWithCityName:cityName];
    //  让天气界面刷新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSelfModel" object:cityName];
    
    //  让主界面滑动
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollHome" object:nil];
    
    [self getDataFromDB];
    
    [self.citysCollectionView reloadData];
}


#pragma mark - cell上删除图标的事件
- (void)delegeCity:(UIButton *)button {
    //  获取点击时的model
    NSString * cityeName = self.cityNameDataSource[button.tag - 100];
    //  从数据库中删除
    [[JYBasicDataManager new] deleteDataWithCityName:cityeName];
    //  从本页界面删除
    [self.cityNameDataSource removeObjectAtIndex:(button.tag - 100)];
    //  刷新界面
    [self.citysCollectionView reloadData];
}


#pragma mark - 创建顶部视图
- (void)creatUserInterface {
    //  此时屏幕的宽度
    CGFloat screenW = Width / 2;
    
    CGFloat iconW = 60;
    CGFloat iconH = iconW;
    
    //  创建用户头像
    _iconImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_iconImage setBackgroundImage:[UIImage imageNamed:@"yunduo.jpg"] forState:UIControlStateNormal];
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 30;
    [self.view addSubview:_iconImage];
    //  添加约束
    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset((screenW - iconW)/2);
        make.size.mas_equalTo(CGSizeMake(iconW, iconH));
    }];
    
    //  创建用户资料和用户设置
    _userDataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userDataBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_userDataBtn setTintColor:[UIColor whiteColor]];
//    _userDataBtn.backgroundColor = [UIColor redColor];
    [_userDataBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userDataBtn];
    //  添加约束
    [_userDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20 + iconH + 10);
        make.left.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake((screenW - 20 * 3)/2, 30));
    }];
    //  创建用户设置
    _userSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userSetBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_userSetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_userSetBtn addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userSetBtn];
    //  添加约束
    [_userSetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20 + iconH + 10);
        make.left.equalTo(_userDataBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake((screenW - 20 * 3)/2, 30));
    }];
    
}

#pragma mark - 编辑按钮的点击事件
- (void)editButtonClick:(UIButton *)button {
    if ([button.currentTitle isEqualToString:@"编辑"]) {
        self.isEditting = YES;
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [self.citysCollectionView reloadData];
    }else {
        self.isEditting = NO;
        [button setTitle:@"编辑" forState:UIControlStateNormal];
        [self.citysCollectionView reloadData];
    }
}

#pragma mark - 添加城市的点击事件
- (void)addCity {
    [self.delegate pushToSearchController];
}

#pragma mark - 皮肤选择的界面
- (void)skinSelect {
    
    JYSkinViewController * skin = [[JYSkinViewController alloc] init];
//    [self.navigationController pushViewController:skin animated:YES];
    
//    CATransition* transition = [CATransition animation];
//    
//    transition.type = kCATransitionMoveIn;//可更改为其他方式
//    transition.subtype = kCATransitionFromRight;//可更改为其他方式
//
//    
//    [self.navigationController.view.layer
//     addAnimation:transition forKey:kCATransition];
//    
//    [self.navigationController pushViewController:skin animated:NO];

//    [skin setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    // typedef enum {
//    //  UIModalTransitionStyleCoverVertical = 0,
//    //  UIModalTransitionStyleFlipHorizontal,
//    //  UIModalTransitionStyleCrossDissolve,
//    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_2
//    //  UIModalTransitionStylePartialCurl,
//    //#endif
//    // } UIModalTransitionStyle;
//    [self presentModalViewController:skin animated:YES];

     AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window.rootViewController presentViewController:skin animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:JYGetDataFromDB object:nil];
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
