//
//  JYWebViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYWebViewController.h"

#import "JYWebMenuView.h"

#import <WebKit/WebKit.h>

@interface JYWebViewController ()<UIWebViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) UIWebView * webView;

//  主网页控制器
@property (nonatomic, strong) WKWebView * wk_webView;
//  网页加载进度条
@property (nonatomic, strong) UIProgressView *progressView;
//  记录网页加载的值
@property (nonatomic, assign) NSUInteger loadCount;

@property (nonatomic, strong) UIView * proView;

@property (nonatomic, strong) UIImageView * loadingView;

//  记录当前的URl
@property (nonatomic, strong) NSString * currentURL;

//  保存当前的滑动手势
@property (nonatomic, strong) UIGestureRecognizer * formaterGesture;

//  网页菜单
@property (nonatomic, strong) JYWebMenuView * menuView;
//  下方的tabBar
@property (nonatomic, strong) UIToolbar * tabBar;

@end

@implementation JYWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    
//    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
//    self.navigationItem.leftBarButtonItem = barButton;
    
    [self willShowTheBGImgae:NO];
    
    //  保存现在的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer = self.formaterGesture;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"新闻";
    
    //  初始化WKWebView
    _wk_webView = [[WKWebView alloc] init];
    _wk_webView.navigationDelegate = self;

    [self.view addSubview:_wk_webView];
    [_wk_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    
    //  初始化进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, Width-60, self.view.frame.size.width, 10)];
    //  加载条颜色
    _progressView.tintColor = [UIColor redColor];
    //
    _progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-45);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    //  初始化proView
    _proView = [[UIView alloc] init];
    _proView.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.4];
    _proView.frame = self.view.bounds;
    [self.view addSubview:_proView];
    _proView.hidden = YES;
    
    
    //  添加观察者
    [_wk_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    
    //  只存在url3G的时候
    //  同时存在的时候
    if ([self.url3G isEqualToString:@""]) {
        //  请求数据
        [self.requestManager GET:[NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.url] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary * arr = responseObject[[NSString stringWithFormat:@"%@",self.url]];
            
            [_wk_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:arr[@"shareLink"]]]];
//            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:arr[@"shareLink"]]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"请求失败");
        }];
    }else {
//        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url3G]]];
        [_wk_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url3G]]];
    }
    
    _tabBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:_tabBar];
    //  约束
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 44));
    }];
    //  添加tabBar的按钮
    //  占位
    UIBarButtonItem * space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //  主页
    UIBarButtonItem * home = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"home142"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(homeClick)];
    
    //  刷新
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"refresh35"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(refreshClick)];
    //  后退
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"left109"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    //  前进
    UIBarButtonItem * forward = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"right97"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(forwardClick)];
    //  分享
    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"f045"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareClick)];
    
    
    _tabBar.items = @[space , home, space, refresh, space, back, space, forward, space];
    
}
#pragma mark - 网页的控制按钮
- (void)homeClick {
    [_wk_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url3G]]];
}
- (void)refreshClick {
    [_wk_webView reload];
}
- (void)backClick {
    [_wk_webView goBack];
}
- (void)forwardClick {
    [_wk_webView goForward];
}
- (void)shareClick {
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //  判断当前是否处在根视图控制器
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    }else {
        return YES;
    }
}


#pragma mark - 进度条的观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = self.wk_webView.title;
    } else if ([keyPath isEqualToString:@"URL"]) {
        
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.progress = self.wk_webView.estimatedProgress;
    }
    
    if (object == self.wk_webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

//  设置载入进度
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}


#pragma mark - WKWebView的代理方法
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    [KVNProgress showSuccessWithStatus:@"加载完成"];
    
    _loadingView.hidden = YES;
   
    self.currentURL = [NSString stringWithFormat:@"%@",webView.URL];
    
//    JSContext * con = [self.wk_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    //创建js交互上下文并与webView相关联
////    JSContext * context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    
//    //    声明一段js代码，删除标题
//    NSString * jsStr = @"var title1 = document.getElementsByTagName('h1')[0];title1.remove()";
//    [con evaluateScript:jsStr];
}


// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.loadCount ++;
    _loadingView.hidden = NO;
//    [KVNProgress showWithStatus:@"正在加载..."];
    
}
// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.loadCount --;
}
//失败
- (void)webView:(WKWebView *)webView didFailNavigation: (null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.loadCount --;
    NSLog(@"%@",error);
}

- (void)deleteH5Title:(UIButton *)btn{
    //创建js交互上下文并与webView相关联
    JSContext * context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //    声明一段js代码，删除标题
    NSString * jsStr = @"var title1 = document.getElementsByTagName('h1')[0];title1.remove()";
    [context evaluateScript:jsStr];
}


#pragma mark - WebView的代理方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //  去关高
    NSString * js3 = @"var a = document.getElementsByClassName('post_header');";
    NSString * js4 = @"a.parentNode.removeChild(a)";
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@;%@",js3, js4]];
    
    //__jx_div
    NSString * js5 = @"var b = document.getElementsByTagName('a')[4]";
    NSString * js6 = @"b.parentNode.removeChild(b)";
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@;%@",js5, js6]];
    
    //BAIDU_DUP_fp_wrapper
    NSString * js7 = @"var c = document.getElementById('BAIDU_DUP_fp_wrapper');";
    NSString * js8 = @"c.parentNode.removeChild(c)";
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@;%@",js7, js8]];
    
    JSContext * context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mySelf"] = self;
    
//    NSString * js3 = @"var a = document.getElementsByClassName('icon_suggest iconfont');";
    NSString * jsCode = @"var a = document.getElementsByClassName('icon_suggest iconfont');a.onclick = function(){mySelf.imageTouch()}";
    
    [context evaluateScript:jsCode];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString*path = request.URL.absoluteString;
    NSUInteger loc = [path rangeOfString:@"baidu"].location;
    if(loc != NSNotFound){
        return NO;
    }
    
    NSUInteger loc1 = [path rangeOfString:@"360"].location;
    if(loc1 != NSNotFound){
        return NO;
    }
    //360
    return YES;
}

#pragma mark - 返回按钮的点击事件


- (void)buttonClick {
    
    NSLog(@"%@",self.url3G);
    NSLog(@"%@",self.currentURL);
    
    //BRODKV2100253B0H.html
    //BRODKV2100253B0H
    NSArray * strarr = [self.url3G componentsSeparatedByString:@".html"];
    NSString * tempStr = [strarr firstObject];
    NSArray * strTemp = [tempStr componentsSeparatedByString:@"/"];
    NSString * strGet = [strTemp lastObject];
    
    //  点击前，先判断当前网址和穿过来的网址
    if ([self.currentURL rangeOfString:strGet].length != 0 || self.url3G.length == 0 ||self.currentURL.length == 0) {
        //  如果当前的网址的传过来的网址相同
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [_wk_webView goBack];
    }
}
#pragma mark - 自定义系统的滑动返回手势


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [_wk_webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
