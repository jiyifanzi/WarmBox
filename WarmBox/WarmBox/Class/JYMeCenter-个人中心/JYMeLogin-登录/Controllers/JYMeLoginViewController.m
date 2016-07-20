//
//  JYMeLoginViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/18.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeLoginViewController.h"

#import "JYMeRegisterViewController.h"

@interface JYMeLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *hhView;

//  登录
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//  注册
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

//  用户的账号
@property (weak, nonatomic) IBOutlet UITextField *userCount;
//  密码
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

//  第三方登录
@property (weak, nonatomic) IBOutlet UIButton *login_QQ;
@property (weak, nonatomic) IBOutlet UIButton *login_weibo;
@property (weak, nonatomic) IBOutlet UIButton *login_weixin;
@property (weak, nonatomic) IBOutlet UIButton *screctBtn;


@property (nonatomic, assign) NSInteger firstClick;

@end

@implementation JYMeLoginViewController

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
    
    [self willShowTheBGImgae:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self willShowTheBGImgae:NO];
    
    
    [self creatUI];
    
    NSLog(@"%@",self.hhView.subviews);
}

#pragma mark - 创建界面
- (void)creatUI {
    _userCount.transform = CGAffineTransformMakeTranslation(2 * Width, 0);
    _userPassword.transform = CGAffineTransformMakeTranslation(2 * Width, 0);
    
    _login_QQ.transform = CGAffineTransformMakeTranslation(0, 100);
    _login_weibo.transform = CGAffineTransformMakeTranslation(0, 100);
    _login_weixin.transform = CGAffineTransformMakeTranslation(0, 100);
    
    _userCount.delegate = self;
    _userPassword.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - 按钮的点击事件
//  登录按钮的点击事件
- (IBAction)loginBtnClick:(id)sender {
    //  显出登录框
    [UIView animateWithDuration:0.4 animations:^{
        _userPassword.transform = CGAffineTransformIdentity;
        _userCount.transform = CGAffineTransformIdentity;
        _loginBtn.transform = CGAffineTransformMakeTranslation(0, 20);
        _registerBtn.transform = CGAffineTransformMakeTranslation(0, 20);
        [_registerBtn setTitle:@"取消" forState:UIControlStateNormal];
        
        _login_QQ.transform = CGAffineTransformIdentity;
        _login_weibo.transform = CGAffineTransformIdentity;
        _login_weixin.transform = CGAffineTransformIdentity;
    }];
    
    if (_firstClick == 1) {
        //  开始判断接受到的数据
        if (self.userCount.text.length == 0 || self.userPassword.text.length == 0) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"账号或者密码不能为空"];
        }else {
            //  登录
            [SVProgressHUD showWithStatus:@"正在登录"];
            __weak typeof(self) weakSelf = self;
            [AVUser logInWithUsernameInBackground:self.userCount.text password:self.userPassword.text block:^(AVUser *user, NSError *error) {
                if (error) {
                    //
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error.localizedDescription]];
                }else {
                    //  登录成功
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }
    
    
    _firstClick = 1;
}

//  注册按钮的点击事件
- (IBAction)registerBtnClick:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"注册"]) {
        //  注册
        JYMeRegisterViewController * registerVC = [[JYMeRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
        
    }else {
        //  是取消
        [UIView animateWithDuration:0.4 animations:^{
            _userCount.transform = CGAffineTransformMakeTranslation(2 * Width, 0);
            _userPassword.transform = CGAffineTransformMakeTranslation(2 * Width, 0);
            
            _login_QQ.transform = CGAffineTransformMakeTranslation(0, 100);
            _login_weibo.transform = CGAffineTransformMakeTranslation(0, 100);
            _login_weixin.transform = CGAffineTransformMakeTranslation(0, 100);

            _loginBtn.transform = CGAffineTransformIdentity;
            _registerBtn.transform = CGAffineTransformIdentity;
            [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
            
            [_userPassword resignFirstResponder];
            [_userCount resignFirstResponder];
            _userPassword.text = nil;
            _userCount.text = nil;
        }];
    }
}



#pragma mark - 三方登录的按钮点击事件
- (IBAction)login_QQClick:(id)sender {
}
- (IBAction)login_WeiBoClick:(id)sender {
}
- (IBAction)login_WeixinClick:(id)sender {
}


#pragma mark - UITextField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}


- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    
    //  让视图往上面移动
    [UIView animateWithDuration:0.3 animations:^{
        //  让整体视图往上移动
        self.hhView.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
        self.hhView.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.3];
    }];
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    //  让视图恢复
    [UIView animateWithDuration:0.3 animations:^{
        //  让整体视图往下移动
        self.hhView.transform = CGAffineTransformIdentity;
        self.hhView.backgroundColor = [UIColor clearColor];
    }];
    _firstClick = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //  移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidShowNotification];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidHideNotification];
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
