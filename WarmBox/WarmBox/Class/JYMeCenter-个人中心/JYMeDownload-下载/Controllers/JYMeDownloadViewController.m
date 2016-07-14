//
//  JYMeDownloadViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/11.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYMeDownloadViewController.h"

//  正在下载
#import "JYDownloadOnLineCell.h"

//  播放界面
#import "JYPlayerViewController.h"

@interface JYMeDownloadViewController ()<UITableViewDataSource, UITableViewDelegate, JYDownloadOnLineDelegate>

@property (weak, nonatomic) IBOutlet UITableView *downTableView;

//  正在下载的数据
@property (nonatomic, strong) NSMutableArray * downloadOnLineSource;
//  已经下载完成的数据
@property (nonatomic, strong) NSMutableArray * downloadedSource;

@end

@implementation JYMeDownloadViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self willShowTheBGImgae:NO];
    
    [self requestDataFromDB];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.navigationItem.title = @"下载管理";
    
    [self creatUI];
    
   
    
}

- (instancetype)init {
    //  抛出异常
    @throw [NSException exceptionWithName:@"init Error" reason:@"这个类不能通过init方法创建对象" userInfo:nil];
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        //  接收通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData:) name:@"DownloadTheVieo" object:nil];
    }
    return self;
}

#pragma mark - 单例
+ (instancetype)jyDownLoadManager {
    static JYMeDownloadViewController * obj = nil; //设置静态变量 static修饰 全局生命周期
    if (obj == nil) {
        @synchronized(self){ // 多线程
            //  创建对象
            obj = [[JYMeDownloadViewController alloc]initPrivate];
        }
    }
    return obj;
}


#pragma mark - 懒加载
- (NSMutableArray *)downloadedSource {
    if (!_downloadedSource) {
        _downloadedSource = [NSMutableArray array];
    }
    return _downloadedSource;
}
- (NSMutableArray *)downloadOnLineSource {
    if (!_downloadOnLineSource) {
        _downloadOnLineSource = [NSMutableArray array];
    }
    return _downloadOnLineSource;
}
//  从数据库获取数据
- (void)requestDataFromDB {
    //  清空数据源
    [self.downloadedSource removeAllObjects];
    
    [self.downloadedSource addObjectsFromArray:[JYWeatherTools requestVideoFromDB]];
    
    //  查看正在下载的电影是否和已经下载完成的相同
    for (JYDownloadModel * model in self.downloadOnLineSource) {
        for (JYDownloadModel * tempModel in self.downloadedSource) {
            if ([tempModel.title isEqualToString:model.title]) {
                [self.downloadedSource removeObject:tempModel];
            }
        }
    }
    
    
    
    [self.downTableView reloadData];
}


//  获取数据
- (void)requestData:(NSNotification *)not {
    NSDictionary * dict = [not userInfo];
    //  存数据
    JYDownloadModel * model = [[JYDownloadModel alloc] init];
    model.title = dict[@"title"];
    model.url = dict[@"url"];
    

    
    [self.downloadOnLineSource addObject:model];
    [self.downTableView reloadData];
}

#pragma mark - 创建UI 
- (void)creatUI {
    _downTableView.delegate = self;
    _downTableView.dataSource = self;
    [_downTableView registerNib:[UINib nibWithNibName:@"JYDownloadOnLineCell" bundle:nil] forCellReuseIdentifier:@"onDown"];
}

#pragma mark - tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.downloadOnLineSource.count;
    }else {
        return self.downloadedSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //  正在下载
        JYDownloadOnLineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"onDown" forIndexPath:indexPath];
        JYDownloadModel * model = self.downloadOnLineSource[indexPath.row];
        
        cell.model = model;
        
        cell.delegate = self;
        
        return cell;
    }
    //  本地缓存
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"didDown"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"didDown"];
    }
    JYDownloadModel * model = self.downloadedSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = model.filePath;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  调用播放
    JYDownloadModel * model = [JYDownloadModel new];
    if (indexPath.section == 0) {
        model = self.downloadOnLineSource[indexPath.row];
    }else {
        model = self.downloadedSource[indexPath.row];
    }
    
    if (model.filePath.length != 0) {
        NSLog(@"文件路径%@",model.filePath);
        JYPlayerViewController * player =[[JYPlayerViewController alloc] init];
        player.filePath = model.filePath;
        player.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:player animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"正在下载";
    }
    return @"本地";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    }
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  将新增元素及删除元素同时返回，出现多选删除的状态
    return UITableViewCellEditingStyleDelete;
}

//  左滑删除数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //  判断此时为删除的情况
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //   删除数据
        if (indexPath.section == 0) {
            //  此时是下载
            JYDownloadModel * model = self.downloadOnLineSource[indexPath.row];
            [self.downloadOnLineSource removeObject:model];
            [JYWeatherTools removeVideoFromDBWithName:[NSString stringWithFormat:@"%@.mp4",model.title]];
            [self requestDataFromDB];
            
        }else {
            JYDownloadModel * model = self.downloadedSource[indexPath.row];
            //  此时是缓存
            //  从数据库删
            [self.downloadedSource removeObject:model];
            [JYWeatherTools removeVideoFromDBWithName:model.title];
            [self requestDataFromDB];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeOnlineandGetDataDBWithModel:(JYDownloadModel *)model {
//    for (JYDownloadModel * temp in self.downloadOnLineSource) {
//        if ([temp.title isEqualToString:model.title]) {
//            [self.downloadOnLineSource removeObject:temp];
//        }
//    }
    
    [self.downloadOnLineSource removeObject:model];
    [self.downTableView reloadData];
    [self requestDataFromDB];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DownloadTheVieo" object:nil];
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
