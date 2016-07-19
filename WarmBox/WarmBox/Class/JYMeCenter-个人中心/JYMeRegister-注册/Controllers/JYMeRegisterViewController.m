//
//  JYMeRegisterViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/18.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeRegisterViewController.h"
#import "AppDelegate.h"


@interface JYMeRegisterViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *totalView;

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *userEmail;

@property (weak, nonatomic) IBOutlet UITextField *userPassword;

//  用户头像
@property (weak, nonatomic) IBOutlet UIButton *userIcon;


@property (weak, nonatomic) IBOutlet UITextField *userRePassword;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation JYMeRegisterViewController


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [self creatUI];
}

#pragma mark - 创建视图
- (void)creatUI{
    _userPassword.delegate = self;
    _userName.delegate = self;
    _userEmail.delegate = self;
    _userRePassword.delegate = self;
    
    _cancelBtn.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerBtnClick:(id)sender {
    NSString * userName = _userName.text;
    NSString * userEmail = _userEmail.text;
    NSString * passWord = _userPassword.text;
    NSString * rePassWord = _userRePassword.text;
    
    //  进行判断
    if (_userRePassword.text.length == 0 || _userName.text.length == 0 || _userEmail.text.length == 0 || _userRePassword.text.length == 0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"以上任一内容不能为空"];
        return;
    }
    
    //  邮箱是否合法
    //  正则表达式验证邮箱
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //  谓词：匹配条件
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:userEmail]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"邮箱格式填写有误"];
        return;
    }
    
    //  密码名是否合法
    if (passWord.length < 6 || passWord.length > 12) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"密码格式填写有误"];
        return;
    }
    
    //  密码 和重复填写密码是否相同
    if (![passWord isEqualToString:rePassWord]) {
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    
    //  开始注册
    [SVProgressHUD showWithStatus:@"正在注册"];
    AVUser * registerUser = [AVUser user];
    registerUser.username = userName;
    registerUser.email = userEmail;
    registerUser.password = passWord;
    
    
    __weak typeof(self) weakSelf = self;
    [registerUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            [SVProgressHUD showWithStatus:@"正在注册"];
            
            //  成功
            //  创建新表，用来存储用户的头像
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
            
        }else {
            /*
             如果注册不成功，请检查一下返回的错误对象。最有可能的情况是用户名已经被另一个用户注册，错误代码 202，即 _User 表中的 username 字段已存在相同的值，此时需要提示用户尝试不同的用户名来注册。同样，邮件 email 和手机号码 mobilePhoneNumber 字段也要求在各自的列中不能有重复值出现，否则会出现 203、214 错误。
             */
            NSLog(@"%@",error);
            
            NSString * errorStr = [NSString stringWithFormat:@"%@",error];
            NSRange range202 = [errorStr rangeOfString:@"202"];
            NSRange range203 = [errorStr rangeOfString:@"203"];
            
            if (range202.length != 0) {
                //  说明是重复注册
                [SVProgressHUD setMinimumDismissTimeInterval:2];
                [SVProgressHUD showErrorWithStatus:@"当前账户已经注册"];
            }else if (range203.length != 0){
                [SVProgressHUD setMinimumDismissTimeInterval:2];
                [SVProgressHUD showErrorWithStatus:@"当前邮箱已经注册"];
            }else {
                [SVProgressHUD setMinimumDismissTimeInterval:2];
                [SVProgressHUD showErrorWithStatus:@"注册失败，请检查网络或稍后再试"];
            }
            
            
        }
    }];
}


- (IBAction)cancelBtnClick:(id)sender {
    [_userPassword resignFirstResponder];
    [_userName resignFirstResponder];
    [_userEmail resignFirstResponder];
    [_userRePassword resignFirstResponder];
}

#pragma mark - 选择头像
- (IBAction)userIconClick:(UIButton *)sender {
    AppDelegate * appDele = [UIApplication sharedApplication].delegate;
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择头像来源" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * actionXiangce = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //  打开系统相册
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [appDele.window.rootViewController presentViewController:picker animated:YES completion:nil];
        
    }];
    
    UIAlertAction * actionXiangji = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  打开系统相册
    }];
    
    UIAlertAction * actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:actionXiangce];
    [alertController addAction:actionXiangji];
    [alertController addAction:actionCancel];
    
    
    [appDele.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePiker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    //  获取图片的大小
    CGSize oldSize = image.size;
    CGSize newSize = CGSizeMake(oldSize.width * 0.1, oldSize.height * 0.1);
    //
    UIImage * newImage = [self thumbnailWithImageWithoutScale:image size:newSize];
    //  转换为imageData
//    NSData * imageData = UIImagePNGRepresentation(newImage);
    
    NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/userIcon.plist"]];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:image forKey:@"userIcon"];
    [archiver finishEncoding];
    [data writeToFile:filepath atomically:NO];
    
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        //  获取到新的图片
        [weakSelf.userIcon setBackgroundImage:newImage forState:UIControlStateNormal];
        [weakSelf.userIcon setTitle:@"" forState:UIControlStateNormal];
        
    }];
}



- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
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
        self.totalView.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
        self.totalView.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.3];
        _cancelBtn.hidden = NO;
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
        self.totalView.transform = CGAffineTransformIdentity;
        self.totalView.backgroundColor = [UIColor clearColor];
        _cancelBtn.hidden = YES;
    }];
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
