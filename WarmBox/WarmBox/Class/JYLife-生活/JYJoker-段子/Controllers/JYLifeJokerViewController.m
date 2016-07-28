//
//  JYLifeJokerViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYLifeJokerViewController.h"

#import "JYLifeJokerCell.h"
#import "JYLifeJokerModel.h"


@interface JYLifeJokerViewController ()<UITableViewDataSource, UITableViewDelegate>

//  笑话界面的tableView
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;



@end

@implementation JYLifeJokerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self willShowTheBGImgae:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"段子";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatUI];
    
    [self requestData];
    
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 懒加载
- (NSMutableArray *)videoDataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 创建界面
- (void)creatUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Width, Height) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    //  设置相关的属性
    _tableView.rowHeight = 240;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //  注册cell
//    [_tableView registerNib:[UINib nibWithNibName:@"JYLifeJokerCell" bundle:nil] forCellReuseIdentifier:@"jokerCell"];
    
    //  添加刷新界面
    [self addMJRefresh];
}

#pragma mark - 添加刷新控件
- (void) addMJRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
//        [KVNProgress showWithStatus:@"正在加载..."];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestData];
    }];
}

#pragma mark - 请求数据
- (void)requestData {
    [self.requestManager GET:@"http://c.3g.163.com/recommend/getChanRecomNews?channel=duanzi&size=20" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * dataArray = responseObject[@"段子"];
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.videoDataSource removeAllObjects];
        }

        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYLifeJokerModel class] json:dataArray];

        
        if (self.videoDataSource.count == 0) {
            [self.videoDataSource addObjectsFromArray:modelArray];
        }
        
        
        for (int i = 0; i < modelArray.count; i++) {
            JYLifeJokerModel * modelTemp = modelArray[i];
            
            int flag = 1;
            for (int j = i; j < self.videoDataSource.count; j++) {
                JYLifeJokerModel * modelTemp2 = self.videoDataSource[j];
                if ([modelTemp.title isEqualToString:modelTemp2.title]) {
                    flag = 0;
                }
            }
            if (flag == 1) {
                [self.videoDataSource addObject:modelTemp];
            }
        }
        

        //  刷新界面
        [self.tableView reloadData];
        
        if ([self.tableView.mj_header isRefreshing]) {
//            [KVNProgress showSuccessWithStatus:@"加载完成"];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [KVNProgress showErrorWithStatus:@"加载失败，请检查网络或稍后再试"];
    }];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYLifeJokerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"jokerCell"];
    if (!cell) {
        cell = [[JYLifeJokerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jokerCell"];
    }
    cell.delegate = self;
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JYLifeJokerModel * model = self.dataSource[indexPath.row];
    //  根据图片来判断
    if (model.img.length == 0) {
        //  纯文本
        CGRect textFrame = [model.digest  boundingRectWithSize:CGSizeMake(Width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
        return textFrame.size.height + 10 + 30;
    }
    
    //  有图片
    CGRect textFrame = [model.digest  boundingRectWithSize:CGSizeMake(Width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    //  获取图片的宽高
    NSArray * WHArray = [model.pixel componentsSeparatedByString:@"*"];
    //  第一个元素为宽 第二个为高
    CGFloat imageW = [NSString stringWithFormat:@"%@",WHArray.firstObject].floatValue;
    CGFloat imageH = [NSString stringWithFormat:@"%@",WHArray.lastObject].floatValue;
    return textFrame.size.height + imageH/imageW * (Width - 10) - 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
