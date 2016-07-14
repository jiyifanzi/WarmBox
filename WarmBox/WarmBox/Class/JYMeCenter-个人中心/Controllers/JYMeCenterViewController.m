//
//  JYMeCenterViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/11.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYMeCenterViewController.h"

#import "AppDelegate.h"

//  下载管理
#import "JYMeDownloadViewController.h"
//  关于
#import "JYMeAboutViewController.h"



@interface JYMeCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
//  设置界面的tableView
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) JYMeDownloadViewController * download;

//  顶部的试图
@property (nonatomic, strong) UIImageView * backImageView;
//  整体的View
@property (nonatomic, strong) UIView * totalView;


@end

@implementation JYMeCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人设置";
    
    [self willShowTheBGImgae:NO];
    
    [self setTopBackImage];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTopUI];
    
    [self creatUI];
}

#pragma makr - 懒加载
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"MeCenter.plist" ofType:nil];
        NSArray * arr = [NSArray arrayWithContentsOfFile:filePath];
        
        [_dataSource addObjectsFromArray:arr];
    }
    return _dataSource;
}
- (JYMeDownloadViewController *)download {
    if (!_download) {
        _download = [JYMeDownloadViewController jyDownLoadManager];
    }
    return _download;
}

#pragma mark - 创建顶部视图
- (void)creatTopUI {
    _totalView = [[UIView alloc] initWithFrame:self.view.bounds];
    _totalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalView];
    
    NSLog(@"%@",self.WholeBlueBackImage);
    NSLog(@"%@",self.WholeBlueBackImage.image);
    
    //
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
//    _backImageView.image = [UIImage imageNamed:@"bigFrish"];
    _backImageView.image = self.WholeBlueBackImage.image;
    _backImageView.clipsToBounds = YES;
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_totalView addSubview:_backImageView];
    
}

#pragma mark - 设置顶部的图片
- (void)setTopBackImage {
    _backImageView.image = self.WholeBlueBackImage.image;
}

#pragma mark - 创建界面
- (void)creatUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableHeaderView;
}


#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"meCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"meCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary * dictTemp = self.dataSource[indexPath.row];
    
    cell.textLabel.text = dictTemp[@"title"];
    cell.imageView.image =[UIImage imageNamed:dictTemp[@"image"]];
    if (indexPath.row == 1) {
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/default"]];
        cell.detailTextLabel.text = [JYWeatherTools getCacheSizeWithCacheFilePath:path];
    }else if (indexPath.row == 3) {
        cell.detailTextLabel.text = @"1.0bate";
    }
    
    
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate * delegate= [UIApplication sharedApplication].delegate;
    //  进行不同功能的选中
    //  下载
    if (indexPath.row == 0) {
//        JYMeDownloadViewController * download = [[JYMeDownloadViewController alloc] init];
        JYMeDownloadViewController * download = [JYMeDownloadViewController jyDownLoadManager];
        self.download.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.download animated:YES];
        
    }else if (indexPath.row == 1) {
        //  清空缓存
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否清除本地缓存？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * btn1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //  清空缓存
            NSFileManager* manager = [NSFileManager defaultManager];
            NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/default/com.hackemist.SDWebImageCache.default"]];
            NSError * error = nil;
            NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:nil];
            for (NSString * fileName in contentsArray) {
                NSString * tempPath = [NSString stringWithFormat:@"%@/%@",path,fileName];
                [manager removeItemAtPath:tempPath error:&error];
            }
            [self.tableView reloadData];
        }];
        
        UIAlertAction * btn2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:btn1];
        [alertController addAction:btn2];
        
        [delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        JYMeAboutViewController * about =[[JYMeAboutViewController alloc] init];
        about.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:about animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y < 0) {
        CGRect frame = self.backImageView.frame;
        frame.size.height = 240 - scrollView.contentOffset.y;
        self.backImageView.frame = frame;
        self.tableView.frame = CGRectMake(0, 0, Width, Height);
    }else if(self.tableView.contentOffset.y >0 && self.tableView.contentOffset.y < 140){
        CGRect frame = self.backImageView.frame;
        frame.size.height = 240 - scrollView.contentOffset.y;
        
        self.backImageView.frame = frame;
    }
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
