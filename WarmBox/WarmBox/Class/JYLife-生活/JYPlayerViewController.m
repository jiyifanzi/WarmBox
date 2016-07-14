//
//  JYPlayerViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JYLifeVideoModel.h"

#import "JYNewsCell.h"

#import "JYMeDownloadViewController.h"

@interface JYPlayerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AVPlayer * palyer;

//  伪播放界面
@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * playBtnView;

//  底部的toolBar的层
@property (nonatomic, strong) UIToolbar * btnToolBar;

//  播放层
@property (nonatomic, strong) AVPlayerLayer * playerLayer;

//  是否是全屏
@property (nonatomic, assign) BOOL isFullScreen;
//  是否正在播放
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) CATransform3D myTransform;

@property (nonatomic, assign) CGPoint centerBefore;

//  播放按钮
@property (nonatomic, strong) UIButton * buttonPlay;
//  进度条
@property (nonatomic, strong) UIProgressView * progressView;
//  进度文字
@property (nonatomic, strong) UILabel * progressLabel;
//  全屏按钮
@property (nonatomic, strong) UIButton * buttonFull;
//  下载按钮
@property (nonatomic, strong) UIButton * buttonDownload;


//  播放Item
@property (nonatomic, strong) AVPlayerItem * playerItem;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation JYPlayerViewController

#pragma mark - 懒加载
- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
//        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
        _playerItem = [AVPlayerItem new];
        
    }
    return _playerItem;
}

//  创建播放器
- (AVPlayer *)palyer {
    if (!_palyer) {
        //  创建播放对象
        _palyer = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    }
    return _palyer;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatPlayView];
    
    [self requetData];
    
    [self creatUI];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //  显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
    _playerItem = nil;
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
    // 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _playerItem = nil;
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:filePath]];
    // 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}



#pragma mark - 请求数据源
- (void)requetData {
    NSArray * typeidArray = @[@"8", @"18", @"9", @"3", @"2", @"4", @"5"];
    
    NSDictionary * dict = @{@"typeid":typeidArray[arc4random()%7],@"page":@"1"};
    
    [self.requestManager GET:WB_Video parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject;
        NSDictionary * arr1 = [arr firstObject];
        NSArray * dataArray = arr1[@"item"];

        [self.dataSource addObjectsFromArray:[NSArray yy_modelArrayWithClass:[JYLifeVideoModel class] json:dataArray]];
        
        //  刷新界面
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [self requetData];
    }];
}

#pragma mark - 创建播放界面
- (void)creatPlayView {
    //  创建伪播放界面
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Width, 270)];
    _backView.backgroundColor = [UIColor blackColor];
    _myTransform = _backView.layer.transform;
    _centerBefore = _backView.center;
    [self.view addSubview:_backView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120 - 15, Width, 30)];
    label.text = @"视频加载中...";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:label];
    
    
    //  1.创建播放界面
    //  AVPlayerLayer 专门用来展示AVPlayer中视频的图像
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.palyer];
    //  2.设置layer的frame
    _playerLayer.frame = CGRectMake(0, 0, Width, 240);
    //  3.显示在界面上
    [self.backView.layer addSublayer:_playerLayer];
    
    //  2.创建按钮控制层
    _playBtnView = [[UIView alloc] init];
//    _playBtnView.backgroundColor =[UIColor redColor];
    _playBtnView.frame = CGRectMake(0, 240, Width, 30);
    [self.backView addSubview:_playBtnView];
    
    //  3.创建播放按钮
    [self creatMenuBtn];
}

#pragma mark - 创建菜单按钮
- (void)creatMenuBtn {
    _buttonPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonPlay addTarget:self action:@selector(playTheVideo) forControlEvents:UIControlEventTouchUpInside];
    _buttonPlay.imageView.tintColor = [UIColor redColor];
    [_buttonPlay setImage:[[UIImage imageNamed:@"ZFPlayer_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_playBtnView addSubview:_buttonPlay];
    [_buttonPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playBtnView);
        make.left.equalTo(_playBtnView).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _buttonDownload = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonDownload addTarget:self action:@selector(downloadTheVieo) forControlEvents:UIControlEventTouchUpInside];
    _buttonDownload.imageView.tintColor = [UIColor redColor];
    [_buttonDownload setImage:[[UIImage imageNamed:@"ZFPlayer_download"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_playBtnView addSubview:_buttonDownload];
    [_buttonDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playBtnView);
        make.right.equalTo(_playBtnView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _buttonFull = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonFull addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
     _buttonFull.imageView.tintColor = [UIColor redColor];
    [_buttonFull setImage:[[UIImage imageNamed:@"ZFPlayer_fullscreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_playBtnView addSubview:_buttonFull];
    [_buttonFull mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playBtnView);
        make.right.equalTo(_buttonDownload.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    

    
    
    _progressView = [[UIProgressView alloc] init];
    //  加载条颜色
    _progressView.tintColor = [UIColor redColor];
    _progressView.trackTintColor = [UIColor whiteColor];
    [_playBtnView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_buttonPlay);
        make.left.equalTo(_buttonPlay.mas_right).offset(5);
        make.right.equalTo(_buttonFull.mas_left).offset(-5);
    }];
    
    _progressLabel = [[UILabel alloc] init];
    [_playBtnView addSubview:_progressLabel];
    _progressLabel.font = [UIFont systemFontOfSize:11.0];
    _progressLabel.textColor = [UIColor whiteColor];
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_playBtnView.mas_bottom);
        make.right.equalTo(_buttonFull.mas_left).offset(-5);
    }];
    
}

//  计算时间
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    //  获取进度信息
    id playbackTimeObserver = [self.playerLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//        CMTime duration = weakSelf.playerItem.duration;// 获取视频总长度
        CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
        
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        [weakSelf.progressView setProgress:currentSecond/totalSecond animated:YES];
        
        NSString *timeString = [weakSelf convertTime:currentSecond];
        weakSelf.progressLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,[weakSelf convertTime:totalSecond]];
    }];
}
//  计算时间
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:d];
    return showtimeNew;
}



#pragma mark - KVO监听进度变化
// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            //  更改视频的进度
            [self monitoringPlayback:self.playerItem];
        }
    }
}

#pragma mark - 播放
- (void)playTheVideo {
    
    if (_isPlaying) {
        [self.palyer pause];
        [_buttonPlay setImage:[[UIImage imageNamed:@"ZFPlayer_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _isPlaying = NO;
    }else {
        [self.palyer play];
        
        [_buttonPlay setImage:[[UIImage imageNamed:@"ZFPlayer_pause"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _isPlaying = YES;
    }
    

}
#pragma mark - 全屏
- (void)fullScreen {
    if (_isFullScreen) {
        //  非全屏
        [_buttonFull setImage:[[UIImage imageNamed:@"ZFPlayer_fullscreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _backView.frame = CGRectMake(0, 64, 270, Width);
        _playerLayer.frame = CGRectMake(0, 0, Width, 240);
        _playBtnView.frame = CGRectMake(0, 240, Width, 30);
        
        [UIView animateWithDuration:0.3 animations:^{
            //  隐藏状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            CGAffineTransform currentTransform = _backView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI_2 * 3); // 在现在的基础上旋转指定角度
            _backView.transform = newTransform;
            
            _backView.center = _centerBefore;
            self.btnToolBar.hidden = NO;
            self.navigationController.navigationBarHidden = NO;
            
            
        } completion:^(BOOL finished) {
            
        }];
        _isFullScreen = NO;
        
    }else {
        //  全屏
        [_buttonFull setImage:[[UIImage imageNamed:@"ZFPlayer_shrinkscreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _backView.frame = CGRectMake(0, 0, Height,Width);
        _playerLayer.frame = CGRectMake(0, 0, Height, Width - 30);
        _playBtnView.frame = CGRectMake(0, Width - 30, Height, 30);
        
        [UIView animateWithDuration:0.3 animations:^{
            //  显示状态栏
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            _backView.transform = CGAffineTransformMakeRotation(M_PI_2);
            _backView.center = self.view.center;
            self.btnToolBar.hidden = YES;
            self.navigationController.navigationBarHidden = YES;
            
        } completion:^(BOOL finished) {
            
        }];
        _isFullScreen = YES;
    }
}
#pragma mark - 下载
- (void)downloadTheVieo {
    JYMeDownloadViewController * dde = [JYMeDownloadViewController jyDownLoadManager];
    
    if (self.url.length != 0) {
        [JYWeatherTools showMessageWithAlertView:@"已经添加到下载队列"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadTheVieo" object:self.url userInfo:@{@"url":self.url, @"title":self.videotitle}];
    }else
    {
        [JYWeatherTools showMessageWithAlertView:@"文件已经下载，请勿重复下载"];
    }
    
   
}


#pragma mark - 创建界面
- (void)creatUI {
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    //  添加约束
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
//    _tableView.backgroundColor= [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"JYNewsCell" bundle:nil] forCellReuseIdentifier:@"video"];
    
    
//    //  创建播放按钮的界面
//    _btnToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    _btnToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewFrameH - 44, viewFrameW, 44)];
//    _btnToolBar.tintColor = [UIColor whiteColor];
//    _btnToolBar.barStyle = UIBarStyleBlack;
//    //  添加三个按钮
//    
//    UIBarButtonItem * selectImage = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
//    UIBarButtonItem * voice = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
//    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
//    
//    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:@selector(selectImageBtnClick)];
//    [_btnToolBar setItems:@[selectImage,space, voice,space, share] animated:YES];
//    
//    [self.view addSubview:_btnToolBar];
    //  创建播放界面的按钮
    
    //  创建缓存按钮
    UIBarButtonItem * downed = [[UIBarButtonItem alloc] initWithTitle:@"缓存" style:UIBarButtonItemStyleDone target:self action:@selector(downedClick)];
    self.navigationItem.rightBarButtonItem = downed;
}
#pragma mark - 查看下载
- (void)downedClick {
    JYMeDownloadViewController * dde = [JYMeDownloadViewController jyDownLoadManager];
    [self.navigationController pushViewController:dde animated:YES];
}

//#pragma mark - 菜单按钮的点击事件
//- (void)selectImageBtnClick {
//    //  下载
//    //  发送通知
////    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadTheVieo" object:self.url];
//   
//}

#pragma mark - uitableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JYNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"video" forIndexPath:indexPath];
    
    cell.lifeModel = self.dataSource[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYLifeVideoModel * model = self.dataSource[indexPath.row];
    //  停止播放
    [self.palyer pause];
    self.playerItem = nil;
    
    
    //  更改播放源
    self.url = model.video_url;
    self.progressLabel.text = nil;
    self.progressView.progress = 0;
    [_buttonPlay setImage:[[UIImage imageNamed:@"ZFPlayer_play"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _isPlaying = NO;
    
    [self.palyer replaceCurrentItemWithPlayerItem:self.playerItem];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - 创建按钮


#pragma mark - 开始播放



#pragma mark - 检测滑动返回


#pragma mark - 移除观察者
- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
//    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
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
