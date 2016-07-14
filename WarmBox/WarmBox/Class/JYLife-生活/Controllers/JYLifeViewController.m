//
//  JYLifeViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYLifeViewController.h"
#import "JYScrollView.h"
#import "JYNewsCell.h"

#import "JYWebViewController.h"

#import "JYLifeVideoViewController.h"
#import "JYLifeJokerViewController.h"
#import "JYMeDownloadViewController.h"



#define Btn_Tag 1000

@interface JYLifeViewController ()<JYScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

//  本界面总的tableView
@property (nonatomic, strong) UITableView * lifeTableView;

//  底部黑色层
@property (nonatomic, strong) UIView * backView;

//  容纳scrollView的View
@property (nonatomic, strong) UIView * topView;
//  容纳btn的View
@property (nonatomic, strong) UIView * btnView;
//  有一个图片的轮播器 展示数据
@property (nonatomic, strong) JYScrollView * scrollView;
//  四个按钮 健康、新闻、工具、娱乐
@property (nonatomic, strong) UIButton * healthBtn;
@property (nonatomic, strong) UIButton * newsBtn;
@property (nonatomic, strong) UIButton * toolsBtn;
@property (nonatomic, strong) UIButton * entermentBtn;

//  保存图片的数组
@property (nonatomic, strong) NSMutableArray * imageArray;
//  保存标题的数组
@property (nonatomic, strong) NSMutableArray * titleArray;

//  保存新闻的数组
@property (nonatomic, strong) NSMutableArray * newsArray;

//  保存咨询的数组
@property (nonatomic, strong) NSMutableArray * dataSource;

//  存储id的数组
@property (nonatomic, strong) NSMutableArray * myIdArray;
//  保存下来刷新时的id
@property (nonatomic, strong) NSString * id_index;

@property (nonatomic, assign) NSInteger id_indexNumber;


@end

@implementation JYLifeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"生活";
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
    
    [self willShowTheBGImgae:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    
    [self creatUI];
    
    [self.lifeTableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (NSMutableArray *)myIdArray {
    if (!_myIdArray) {
//        _myIdArray = [NSMutableArray arrayWithArray:@[@"popular", @"recomm", @"ent", @"life", @"health", @"tech", @"auto", @"sports", @"mil", @"finance", @"edu", @"photograph", @"travel", @"food", @"astro"]];
        _myIdArray = [NSMutableArray arrayWithArray:@[@"T1348648517839", @"T1348649079062", @"T1348650593803", @"T1348649580692", @"T1348648756099", @"T1368497029546",@"T1348654151579"]];
    }
    return _myIdArray;
}

#pragma mark - 获取数据
- (void)requestData {
    [self.requestManager GET:@"http://c.m.163.com/nc/article/headline/T1348647853363/0-20.html?from=toutiao%2Bd&size=20&version=9.0&spever=false&net=wifi&lat=&lon=&ts=1464655209&encryption=1&canal=appstore" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[@"T1348647853363"];
        
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYNewsModel class] json:arr];
        for (JYNewsModel * tempModel in modelArray) {
            if (tempModel.url_3w.length == 0) {
                
            }else {
                [self.imageArray addObject:tempModel.imgsrc];
                [self.titleArray addObject:tempModel.title];
                [self.newsArray addObject:tempModel];
            }
        }
        
        [self creatScrollView];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)requestDataWithId:(NSString *)myid{
    //0-10;
    
    NSString * size = [NSString stringWithFormat:@"%ld-%ld",_id_indexNumber,_id_indexNumber + 10];
    [self.requestManager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/%@.html",myid,size] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * arr = responseObject[myid];
        
        if ([self.lifeTableView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        //  将img不为空的数组转换成模型，存储到newsArray
        
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYNewsModel class] json:arr];
        for (JYNewsModel * tempModel in modelArray) {
            if (tempModel.url_3w.length == 0) {
                
            }else {
                [self.dataSource addObject:tempModel];
            }
        }

        
        self.lifeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //  刷新界面
        [self.lifeTableView reloadData];
        
        if ([self.lifeTableView.mj_header isRefreshing]) {
//            [KVNProgress showSuccessWithStatus:@"加载完成"];
        }
        
        [self.lifeTableView.mj_header endRefreshing];
        [self.lifeTableView.mj_footer endRefreshing];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求出错%@",error);
        NSString * tmpeStr = self.myIdArray[arc4random()%self.myIdArray.count];
        [self requestDataWithId:tmpeStr];
    }];

    
}

#pragma mark - 创建界面
- (void)creatUI {
    
    //  创建伪播放界面
//    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Width, Width/2)];
//    _backView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_backView];
//    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, Width, 30)];
//    label.text = @"视频加载中...";
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    [_backView addSubview:label];
    
    //  顶部视图 包含scrollView和按钮
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Width/2 + 50 + 20)];

    _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, Width/2, Width, 70)];
    _btnView.backgroundColor = [UIColor whiteColor];
    [_topView addSubview:_btnView];
//    _topView.backgroundColor = [UIColor redColor];
    
    //  创建tableView
    _lifeTableView = [[UITableView alloc] init];
    [self.view addSubview:_lifeTableView];
    //  约束
    [_lifeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    //  设置相关的属性
    _lifeTableView.delegate = self;
    _lifeTableView.dataSource = self;
    _lifeTableView.tableHeaderView = _topView;
    _lifeTableView.backgroundColor = [UIColor clearColor];
    _lifeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //  注册cell
    [_lifeTableView registerNib:[UINib nibWithNibName:@"JYNewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    [self addMJRefresh];
    
    //  创建Btn
//    CGFloat margin = 10;
    CGFloat btnMargin = (Width - 50 * 4) / 5;
    CGFloat btnX = 0;
    CGFloat btnY = 5;
    CGFloat btnW = 50;
    CGFloat btnH = btnW;
    NSArray * btnImageArray = @[@"jiankang", @"xinwen", @"yule", @"downLoadMe"];
    NSArray * titleArray = @[@"首页", @"视频", @"段子", @"下载"];
    
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        btnX = btnMargin +(btnW+btnMargin) * i;
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [button setBackgroundImage:[UIImage imageNamed:btnImageArray[i]] forState:UIControlStateNormal];
        button.tag = Btn_Tag + i;
        [button addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnView addSubview:button];
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(btnX, btnY + 5 + btnH, btnW, 13);
        label.text = titleArray[i];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentCenter;
        [_btnView addSubview:label];
    }
}

#pragma mark - 菜单按钮的点击事件
- (void) menuBtnClick:(UIButton *)button {
    if (button.tag == Btn_Tag + 1) {
        //  视频
        JYLifeVideoViewController * lifeVideo = [[JYLifeVideoViewController alloc] init];
        lifeVideo.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lifeVideo animated:YES];
    }else if (button.tag == Btn_Tag + 2) {
        //  段子
        JYLifeJokerViewController * lifeJoker = [[JYLifeJokerViewController alloc] init];
        lifeJoker.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lifeJoker animated:YES];
    }else if (button.tag == Btn_Tag + 0) {
        //  主页
        [UIView animateWithDuration:0.3 animations:^{
            self.tabBarController.selectedIndex = 0;
        }];
    }else if (button.tag == Btn_Tag + 3) {
        //  下载管理
        JYMeDownloadViewController * download = [JYMeDownloadViewController jyDownLoadManager];
        download.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:download animated:YES];
    }
}

#pragma mark - 添加刷新控件
- (void) addMJRefresh {
    self.lifeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString * tmpeStr = self.myIdArray[arc4random()%self.myIdArray.count];
        self.id_index = tmpeStr;
        _id_indexNumber = 0;
//        [KVNProgress showWithStatus:@"正在加载..."];
        [self requestDataWithId:tmpeStr];
    }];
    
    self.lifeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _id_indexNumber += 10;
//        [KVNProgress showWithStatus:@"正在加载..."];
        [self requestDataWithId:self.id_index];
    }];
}

#pragma mark - 更改顶部标题
- (void)setId_index:(NSString *)id_index {
    _id_index = id_index;
    // @[@"T1348648517839"娱乐, @"T1348649079062"体育, @"T1348650593803"时尚, @"T1348649580692"科技, @"T1348648756099"财经, @"T1368497029546"历史,@"T1348654151579"游戏]
    
    if ([id_index isEqualToString:@"T1348648517839"]) {
        self.navigationItem.title = @"娱乐";
    }else if ([id_index isEqualToString:@"T1348649079062"]) {
        self.navigationItem.title = @"体育";
    }else if ([id_index isEqualToString:@"T1348650593803"]) {
        self.navigationItem.title = @"时尚";
    }else if ([id_index isEqualToString:@"T1348649580692"]) {
        self.navigationItem.title = @"科技";
    }else if ([id_index isEqualToString:@"T1348648756099"]) {
        self.navigationItem.title = @"财经";
    }else if ([id_index isEqualToString:@"T1368497029546"]) {
        self.navigationItem.title = @"历史";
    }else if ([id_index isEqualToString:@"T1348654151579"]) {
        self.navigationItem.title = @"游戏";
    }
}

#pragma mark - uitableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYWebViewController * webView = [[JYWebViewController alloc] init];
    JYNewsModel * model = self.dataSource[indexPath.row];
    if ([model.url_3w isEqualToString:@""]) {
        NSLog(@"%@==%@",model.url_3w, model.url);
        webView.url = model.docid;
    }else {
        NSLog(@"%@==%@",model.url_3w, model.url);
        webView.url3G = model.url_3w;
    }
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellH = Height / 7.0f;
    return cellH;
}
#pragma mark - tableView滑动的时候的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"%.1f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= Width/2) {

    }else {

    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}


#pragma mark - 创建scrollView
- (void)creatScrollView {
    _scrollView = [[JYScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Width / 2) imageNum:(int)self.imageArray.count];
    _scrollView.delegate = self;
//    [self.view addSubview:_scrollView];
    [_topView addSubview:_scrollView];
    
    //  让scrollView展示数据
    [_scrollView showWithImageArray:self.imageArray titleArray:self.titleArray];
}
#pragma mark - JYscrollView的代理方法
- (void)scrollViewDidClickedAtPage:(NSInteger)page {
    NSLog(@"%.1ld",(long)page);
    //  跳转到对应的网页
    JYNewsModel * newModel = self.newsArray[page];
    
    NSLog(@"%@",newModel.url);
    NSLog(@"%@",newModel.docid);
    
    JYWebViewController * webView = [[JYWebViewController alloc] init];
    
    if ([newModel.url_3w isEqualToString:@""]) {
        
        NSLog(@"%@==%@",newModel.url_3w, newModel.url);
        webView.url = newModel.docid;
    }else {
        NSLog(@"%@==%@",newModel.url_3w, newModel.url);
        webView.url3G = newModel.url_3w;
    }
    
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
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
