//
//  JYMeSearchCityViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/1.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeSearchCityViewController.h"

#import "JYMeCityModel.h"

@interface JYMeSearchCityViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UIAlertViewDelegate>


//  搜索结果的数组
@property (nonatomic, strong) NSMutableArray * searchResult;
//  存有所有城市数据的数组
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation JYMeSearchCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor redColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
#pragma mark - 懒加载
//  从plist文件读取城市的数据
-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSString * filePath = [[NSBundle mainBundle] pathForResource:@"citylist.json" ofType:nil];
        NSData * jsonData = [NSData dataWithContentsOfFile:filePath];
        
        NSError * error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSArray * dataArray = jsonObject[@"city_info"];
        NSArray * modelArray = [NSArray yy_modelArrayWithClass:[JYMeCityModel class] json:dataArray];
        [self.dataSource addObjectsFromArray:modelArray];
    }
    return _dataSource;
}
- (NSMutableArray *)searchResult {
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@",self.dataSource);
    
    [self creatUI];
}

#pragma mark - 创建用户界面
- (void)creatUI {
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    //  添加约束
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    //  设置相关属性
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //  添加搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Width, 44)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
//    _searchBar.showsScopeBar = YES;
//    _searchBar.showsSearchResultsButton = YES;
    _searchBar.placeholder = @"请输入城市名称";
//    _tableView.tableHeaderView = _searchBar;
}

#pragma mark - tableView的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchResult.count != 0) {
        return self.searchResult.count;
    }
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (self.searchResult.count != 0) {
        JYMeCityModel * model = self.searchResult[indexPath.row];
        cell.textLabel.text = model.city;
        cell.detailTextLabel.text = model.prov;
        
    }else {
        JYMeCityModel * model = self.dataSource[indexPath.row];
        cell.textLabel.text = model.city;
        cell.detailTextLabel.text = model.prov;
    }
    
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _searchBar;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchResult.count != 0) {
        return @"搜索结果,点击添加";
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
//  tableView的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchResult.count != 0) {
        //  只有当是搜索界面的时候，才能搜藏
        JYMeCityModel * model = self.searchResult[indexPath.row];
        if ([[JYBasicDataManager new] checkIsInDBWithCityName:model.city]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"城市添加失败！数据已经存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else {
            [[JYBasicDataManager new] insertDataWithCityName:model.city andLocation:@"0"];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"城市添加成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        JYMeCityModel * model = self.dataSource[indexPath.row];
        if ([[JYBasicDataManager new] checkIsInDBWithCityName:model.city]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"城市添加失败！数据已经存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else {
            [[JYBasicDataManager new] insertDataWithCityName:model.city andLocation:@"0"];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"城市添加成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - UIAlertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISearchBar的代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // 收回键盘
    searchBar.text = @"";
    [_searchBar resignFirstResponder];
    [self.searchResult removeAllObjects];
    [_tableView reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //  清空搜索结果
    [self.searchResult removeAllObjects];
    NSString * searchStr = searchBar.text;
    
    
    for (JYMeCityModel * tempModel in self.dataSource) {

        NSRange range1 = [tempModel.city rangeOfString:searchStr];
        NSRange range2 = [tempModel.prov rangeOfString:searchStr];
        if (range1.length != 0 || range2.length != 0) {
            [self.searchResult addObject:tempModel];
        }
        
    }
    
    //  刷新界面
    [_tableView reloadData];
    [searchBar resignFirstResponder];
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
