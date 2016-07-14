//
//  JYGuideViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/13.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYGuideViewController.h"

#import "JYMainViewController.h"

@interface JYGuideViewController ()<UIScrollViewDelegate>

//  滑动的banner
@property (nonatomic, strong) UIScrollView * scrollView;
//  最后的按钮
@property (nonatomic, strong) UIButton * button;

@end

@implementation JYGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
}

#pragma mark - 创建界面
- (void)creatUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(Width * 4, Height);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    NSArray * imageArray = @[@"b1", @"b2", @"b3", @"b4"];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView * image = [[UIImageView alloc] init];
        image.frame = CGRectMake(Width * i, 0, Width, Height);
        image.image = [UIImage imageNamed:imageArray[i]];
        [_scrollView addSubview:image];
    }
    
    //  创建按钮
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-110);
        make.left.equalTo(self.view).offset(Width/2 - 100);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [_button addTarget:self action:@selector(changeMainVC) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitle:@"开启暖心之旅" forState:UIControlStateNormal];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    _button.hidden = YES;
}

#pragma mark - 展示主界面
- (void)changeMainVC {
    JYMainViewController * main = [[JYMainViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:main];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x / Width == 3) {
        _button.hidden = NO;
    }else {
        _button.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
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
