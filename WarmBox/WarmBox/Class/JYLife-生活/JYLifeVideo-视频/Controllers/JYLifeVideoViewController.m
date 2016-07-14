//
//  JYLifeVideoViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYLifeVideoViewController.h"

#import "JYLifeVideoModel.h"
#import "JYLifeVideoCell.h"

#import "JYPlayerViewController.h"



//  宏 屏幕宽高
#define Width [[UIScreen mainScreen]bounds].size.width
#define Height [[UIScreen mainScreen]bounds].size.height
//  默认标签栏的高度
#define tagHeight 30
//  标签按钮的tag值
#define Btn_Tag 300
#define Top_Tag 200
#define Con_Tag 100
//  默认一个屏幕显示几个标签
#define tagWidth Width / 5

@interface JYLifeVideoViewController ()<UITableViewDataSource, UITableViewDelegate,JYLifeVideoCellDelegate>

//  本界面的tableView
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;

//  本界面的数据源
@property (nonatomic, strong) NSMutableArray * videoDataSource;


//  http://api.iclient.ifeng.com/ifengvideoList?page=1&listtype=list&typeid=2

//  1.标签栏的视图
@property (nonatomic, strong) UIScrollView * topScrollView;
//  2.选中的下标
@property (nonatomic, assign) NSInteger seletcedIndex;
//  3.管理顶部标签栏的数组
@property (nonatomic, strong) NSMutableArray * topViewArray;

//  本页面的typerID
@property (nonatomic, strong) NSString * typeID;


@end

@implementation JYLifeVideoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self willShowTheBGImgae:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //http://api.iclient.ifeng.com/ifengvideoList?page=1&listtype=list&typeid=2
    
    self.navigationItem.title = @"视频";
    
    [self creatUI];
    
    _typeID = @"8";
    
    [self requestDataWithTypeID:@"8" andPageSize:@"1"];
}

#pragma mark - 懒加载
- (NSMutableArray *)videoDataSource {
    if (!_videoDataSource) {
        _videoDataSource = [NSMutableArray array];
    }
    return _videoDataSource;
}
#pragma mark - 懒加载
- (NSMutableArray *)topViewArray {
    if (!_topViewArray) {
        _topViewArray = [NSMutableArray array];
    }
    return _topViewArray;
}

#pragma mark - 创建界面
- (void)creatUI {
    
    NSArray * nameArray = @[@"生活", @"美食", @"影视", @"历史", @"段子", @"社会",@"军事"];
    //
    
    //  顶部标签栏的UI
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Width, tagHeight)];
    _topScrollView.contentSize = CGSizeMake(tagWidth * nameArray.count, tagHeight);
    _topScrollView.tag = Top_Tag;
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    //  添加标签
    for (int i = 0; i < nameArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * tagWidth, 0, tagWidth - 2, tagHeight);
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        button.tag = Btn_Tag + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
        [self.topViewArray addObject:button];
        if (i == 0) {
            _seletcedIndex = i;
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else {
            button.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [self.topScrollView addSubview:button];
    }
    [self.view addSubview:_topScrollView];
    
    
    //  设置相关的属性
//    _videoTableView.rowHeight = 240;
    _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //  注册cell
    [_videoTableView registerNib:[UINib nibWithNibName:@"JYLifeVideoCell" bundle:nil] forCellReuseIdentifier:@"videoCell"];
    
    //  添加刷新界面
    [self addMJRefresh];
}


#pragma mark - 按钮的点击事件
- (void)changeView:(UIButton *)button {
    //  改变mainScrollView的contentOffset，并且改变按钮的放大状态
    [UIView animateWithDuration:0.4 animations:^{
        _seletcedIndex = button.tag - Btn_Tag ;
        for (UIButton * button in self.topViewArray) {
            if (button.tag != _seletcedIndex + Btn_Tag) {
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else {
                button.titleLabel.font = [UIFont systemFontOfSize:20];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }];
    
    NSLog(@"%.1ld",(long)_seletcedIndex);
    
    //  点击之后，改变typeID的值，然后请求数据
    //  @[@"生活", @"美食", @"影视", @"历史", @"段子", @"社会",@"军事"];

    switch (_seletcedIndex) {
        case 0:
            //  生活
            _typeID = @"8";
            break;
        case 1:
            _typeID = @"18";
            break;
        case 2:
            _typeID = @"9";
            break;
        case 3:
            _typeID = @"3";
            break;
        case 4:
            _typeID = @"2";
            break;
        case 5:
            _typeID = @"4";
            break;
        case 6:
            _typeID = @"5";
            break;
    }
    
    [self.videoTableView.mj_header beginRefreshing];
}

#pragma mark - 添加刷新控件
- (void) addMJRefresh {
    
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        [KVNProgress showWithStatus:@"正在加载"];
        [self requestDataWithTypeID:nil andPageSize:@"1"];
    }];
    
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestDataWithTypeID:nil andPageSize:[NSString stringWithFormat:@"%lu",self.videoDataSource.count/20 + 1]];
    }];
}

#pragma mark - 请求数据
- (void)requestDataWithTypeID:(NSString *)typeID
                  andPageSize:(NSString *)pageSize{
    
    NSDictionary * dict = @{@"typeid":_typeID,@"page":pageSize};
    
    [self.requestManager GET:WB_Video parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * arr = responseObject;
        NSDictionary * arr1 = [arr firstObject];
        NSArray * dataArray = arr1[@"item"];
        if ([self.videoTableView.mj_header isRefreshing]) {
        [self.videoDataSource removeAllObjects];
        }
        
        [self.videoDataSource addObjectsFromArray:[NSArray yy_modelArrayWithClass:[JYLifeVideoModel class] json:dataArray]];
        
        //  刷新界面
        [self.videoTableView reloadData];
        
        if ([self.videoTableView.mj_header isRefreshing]) {
//            [KVNProgress showSuccessWithStatus:@"加载完成"];
        }
        
        [self.videoTableView.mj_header endRefreshing];
        [self.videoTableView.mj_footer endRefreshing];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [KVNProgress showErrorWithStatus:@"加载失败，请检查网络或稍后再试"];
    }];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYLifeVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
    cell.model = self.videoDataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

#pragma mark - 代理方法
- (void)playTheVideoWithURL:(NSString *)url andTitle:(NSString *)title{
    JYPlayerViewController * player = [[JYPlayerViewController alloc] init];
    player.url = url;
    player.videotitle = title;
    [self.navigationController pushViewController:player animated:YES];
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
