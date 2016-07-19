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
//  登录
#import "JYMeLoginViewController.h"



@interface JYMeCenterViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
//  设置界面的tableView
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) JYMeDownloadViewController * download;

//  顶部的试图
@property (nonatomic, strong) UIImageView * backImageView;
//  整体的View
@property (nonatomic, strong) UIView * totalView;


@property (nonatomic, strong) UIView * tableHeaderView;
//  用户头像
@property (nonatomic, strong) UIButton * userIconBtn;
//  用户名字
@property (nonatomic, strong) UILabel * userNameLabel;
//  登录按钮
@property (nonatomic, strong) UIBarButtonItem * userLoginBtn;
//  是否已经登录
@property (nonatomic, assign) BOOL isLogined;

@end

@implementation JYMeCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人设置";
    
    [self willShowTheBGImgae:NO];
    
//    [self setTopBackImage];
    
    [self.tableView reloadData];
    
    //  获取当前的登录对象
    AVUser * currentUser =  [AVUser currentUser];
    
    if (currentUser) {
        _userNameLabel.text = currentUser.username;
        //  设置用户头像
        //  下载数据
//        AVQuery *query = [AVQuery queryWithClassName:@"File"];
//        [query whereKey:@"name" containsString:[NSString stringWithFormat:@"%@UserIcon",currentUser.username]];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            NSArray<AVObject *> *priorityEqualsZeroTodos = objects;// 符合 priority = 0 的 Todo 数组
//            NSLog(@"%@",priorityEqualsZeroTodos);
//            
//            
//        }];
//        
//        // 如果这样写，第二个条件将覆盖第一个条件，查询只会返回 priority = 1 的结果
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        }];
        
        
        /*
         NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/userIcon.plist"]];
         
         //  读取归档文件
         NSMutableData *readData = [NSMutableData dataWithContentsOfFile:filepath];
         
         AVFile * userIcon = [AVFile fileWithName:[NSString stringWithFormat:@"%@userIcon",registerUser.username] data:readData];
         
         //  新表
         AVObject * todo = [AVObject objectWithClassName:@"UserAllInfo"];
         
         [todo setObject:userIcon forKey:@"userIcon"];
         
         [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (succeeded) {
         //  成功
         [SVProgressHUD setMinimumDismissTimeInterval:1];
         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
         
         }else {
         NSLog(@"%@",error);
         [SVProgressHUD showErrorWithStatus:@"注册失败，请重试"];
         }
         }];
         */
        
        
        AVQuery *query = [AVQuery queryWithClassName:@"UserAllInfo"];
        [query whereKeyExists:@"userIcon"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // objects 返回的就是有图片的
            NSLog(@"%@",objects);
            for (AVObject * queryObj in objects) {
                NSDictionary *  dict = [queryObj valueForKey:@"localData"];
                
                AVFile * file = [dict valueForKey:@"userIcon"];
                 
                NSLog(@"%@",file.name);
                
                if ([file.name isEqualToString:[NSString stringWithFormat:@"%@userIcon",currentUser.username]]) {
                    //  找到了
                    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        //   获取数据
                        if (!error) {
                            NSMutableData *readData = [NSMutableData dataWithData:file.getData];
                            //  创建解归档
                            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
                            //  decodeObjectForKey key就是名字
                            UIImage * userImage = [unarchiver decodeObjectForKey:@"userIcon"];
                            //  回主线程刷新
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_userIconBtn setBackgroundImage:userImage forState:UIControlStateNormal];
                            });
                        }
                    }];
                    
                }
            }
        }];
        
        
        
        
//        [AVFile getFileWithObjectId:@"578ceee3a34131005b7f4145" withBlock:^(AVFile *file, NSError *error) {
//            if (error) {
//                NSLog(@"%@",error);
//            }else {
//                NSMutableData *readData = [NSMutableData dataWithData:file.getData];
//                //  创建解归档
//                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
//                //  decodeObjectForKey key就是名字
//                UIImage * userImage = [unarchiver decodeObjectForKey:@"userIcon"];
//                //  回主线程刷新
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_userIconBtn setBackgroundImage:userImage forState:UIControlStateNormal];
//                });
//            }
//        }];
//        
//        
      
        _isLogined = YES;
        [_userLoginBtn setTitle:@"退出"];
        
    }else {
        [_userLoginBtn setTitle:@"登录"];
        _isLogined = NO;
    }
    
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
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    //  1.获取单例对象
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //  2.读取数据
    NSData * data = [user objectForKey:@"SkinBGImage"];
    //  设置背景图片
    if (data.length == 0) {
        [_backImageView setImageToBlur:[UIImage imageNamed:@"1.jpg"] completionBlock:^{
        }];
    }else {
        [_backImageView setImage:[UIImage imageWithData:data]];
    }

    _backImageView.image = self.WholeBlueBackImage.image;
    _backImageView.clipsToBounds = YES;
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_totalView addSubview:_backImageView];
    
    //  登录按钮
    _userLoginBtn = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(userLogin)];
    self.navigationItem.rightBarButtonItem = _userLoginBtn;
}

#pragma mark - 登录按钮的点击事件
- (void)userLogin {
    if (_isLogined) {
        //  已经登录
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"温馨提醒" message:@"是否退出当前登录的用户？" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alertView show];
        
    }else {
        //  没有登录
        JYMeLoginViewController * loginViewController = [[JYMeLoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
#pragma mark - uilaertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //  是
        [AVUser logOut];
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        
        [_userLoginBtn setTitle:@"登录"];
        _userNameLabel.text = @"请先登录";        //  否
        [_userIconBtn setBackgroundImage:nil forState:UIControlStateNormal];
        _isLogined = NO;
    }
}


#pragma mark - 设置顶部的图片
- (void)setTopBackImage {
//    _backImageView.image = self.WholeBlueBackImage.image;
    //  1.获取单例对象
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //  2.读取数据
    NSData * data = [user objectForKey:@"SkinBGImage"];
    
    if (data.length == 0) {
        [_backImageView setImageToBlur:[UIImage imageNamed:@"1.jpg"] completionBlock:^{
            //            weakSelf.backImage.image = [UIImage imageWithData:data];
        }];
    }else {
        //        [_blueBackImage setImageToBlur:[UIImage imageWithData:data] completionBlock:^{
        ////            weakSelf.backImage.image = [UIImage imageWithData:data];
        //        }];
        [_backImageView setImage:[UIImage imageWithData:data]];
    }

}

#pragma mark - 创建界面
- (void)creatUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = _tableHeaderView;
    
    //  头像
    _userIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userIconBtn.backgroundColor = [UIColor redColor];
    _userIconBtn.clipsToBounds = YES;
    _userIconBtn.layer.cornerRadius = 40;
    [_tableHeaderView addSubview:_userIconBtn];
    [_userIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).offset(84);
        make.centerX.equalTo(_tableHeaderView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    //  名称
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.text = @"用户昵称";
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.font = [UIFont boldSystemFontOfSize:18];
//    _userNameLabel.backgroundColor = [UIColor yellowColor];
    [_tableHeaderView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIconBtn.mas_bottom).offset(10);
        make.centerX.equalTo(_tableHeaderView);
        make.left.equalTo(_tableHeaderView.mas_left).offset(80);
        make.right.equalTo(_tableHeaderView.mas_right).offset(-80);
    }];
    
    
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
        cell.detailTextLabel.text = @"1.0.4";
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


#pragma mark - scrollView的代理方法
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
