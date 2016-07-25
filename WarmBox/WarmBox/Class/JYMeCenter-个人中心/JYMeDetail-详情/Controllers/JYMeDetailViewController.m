//
//  JYMeDetailViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/20.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYMeDetailViewController.h"

@interface JYMeDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//  编辑按钮
@property (nonatomic, strong) UIBarButtonItem * userEditBtn;
//  用户头像
@property (nonatomic, strong) UIButton * userIcon;
//  个新签名
@property (nonatomic, strong) UILabel * userSign;
//  用户名称
@property (nonatomic, strong) UILabel * userName;

//  用户详情的TalbeView
@property (nonatomic, strong) UITableView * userTabelView;
//  用户详情的dataSource
@property (nonatomic, strong) NSMutableArray * userDataSource;

//  顶部的试图
@property (nonatomic, strong) UIImageView * backImageView;
//  模糊
@property (nonatomic, strong) UIBlurEffect * backImageEffect;
//  毛玻璃
@property (nonatomic, strong) UIVisualEffectView * backImageVisualEffect;


//  整体的View
@property (nonatomic, strong) UIView * totalView;


@property (nonatomic, strong) UIView * tableHeaderView;
//  是否已经登录
@property (nonatomic, assign) BOOL isLogined;
//  是否允许用户编辑
@property (nonatomic, assign) BOOL isAllowEdit;

//  接受每个输入的改变
@property (nonatomic, strong) UITextField * userInputTextField;

@end


@implementation JYMeDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self willShowTheBGImgae:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@""]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self creatTopUI];
    
    [self creatUI];
    
    [self getDataFromCurrentUser];
}


#pragma mark - 懒加载
- (NSMutableArray *)userDataSource {
    if (!_userDataSource) {
        _userDataSource = [NSMutableArray array];
    }
    return _userDataSource;
}

#pragma mark - 从当前用户获取数据
- (void)getDataFromCurrentUser {
    
    [self.userDataSource removeAllObjects];
    
    
    [SVProgressHUD showWithStatus:@"正在获取中...."];
    JYUser * currentUser = [JYUser currentUser];

    [currentUser fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        JYUser * nowUser = (JYUser *)object;
        //  获取到最新的数据，根据这个数据来进行填充内容
        
        AVFile * file = [AVFile fileWithURL:nowUser.headUrl];
        __weak typeof(self) weakSelf = self;
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                // self.headImageView.image = [UIImage imageWithData:data];
                
                NSMutableData *readData = [NSMutableData dataWithData:data];
                //  创建解归档
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
                //  decodeObjectForKey key就是名字
                UIImage * userImage = [unarchiver decodeObjectForKey:@"userIcon"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.userIcon setBackgroundImage:userImage forState:UIControlStateNormal];
//                    [weakSelf.backImageView setImageToBlur:userImage completionBlock:^{
//                        
//                    }];
                    weakSelf.backImageView.image = userImage;
                    
                });
            }
        }];
        
        //  设置名称
        self.navigationItem.title  = nowUser.username;
        
        _userName.text = nowUser.username;
        [self.userDataSource addObject:nowUser.username];

        
        if (nowUser.email.length == 0) {
            //
            [self.userDataSource addObject:@"未绑定"];
        }else {
            [self.userDataSource addObject:nowUser.email];
        }
        
        if (nowUser.mobilePhoneNumber.length == 0) {
            //
            [self.userDataSource addObject:@"未绑定"];
        }else {
            [self.userDataSource addObject:nowUser.mobilePhoneNumber];
        }
        
        NSArray * noteArray = [nowUser objectForKey:@"noteArray"];
        [self.userDataSource addObject:[NSString stringWithFormat:@"%ld",noteArray.count]];
        [self.userDataSource addObject:@"1"];
        
        
        [self.userTabelView reloadData];

        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        
        _isLogined = YES;
    }];
}



#pragma mark - 创建整体的视图
- (void)creatUI {
    _userTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_userTabelView];
    
    _userTabelView.backgroundColor = [UIColor clearColor];
    
    _userTabelView.delegate = self;
    _userTabelView.dataSource = self;
    
    _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 240)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    self.userTabelView.tableHeaderView = _tableHeaderView;
    
    
    //  设置用户头像及其他
    //  头像
    _userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    _userIcon.backgroundColor = [UIColor clearColor];
    _userIcon.clipsToBounds = YES;
    _userIcon.layer.cornerRadius = 40;
    //  添加头像的点击事件
    [_userIcon addTarget:self action:@selector(userIconClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableHeaderView addSubview:_userIcon];
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).offset(84);
        make.centerX.equalTo(_tableHeaderView);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    //  名称
    _userName = [[UILabel alloc] init];
    _userName.textAlignment = NSTextAlignmentCenter;
    _userName.text = @"用户昵称";
    _userName.textColor = [UIColor whiteColor];
    _userName.font = [UIFont boldSystemFontOfSize:22];
    
//    _userName.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.6];
    _userName.clipsToBounds = YES;
    _userName.layer.cornerRadius = 10;
    //    _userNameLabel.backgroundColor = [UIColor yellowColor];
    [_tableHeaderView addSubview:_userName];
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIcon.mas_bottom).offset(10);
        make.centerX.equalTo(_tableHeaderView);
        make.left.equalTo(_tableHeaderView.mas_left).offset(80);
        make.right.equalTo(_tableHeaderView.mas_right).offset(-80);
    }];
    
    //  用户签名
    
}
#pragma mark - 点击了头像的事件
- (void)userIconClick {
    if (!_isLogined) {
        return;
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请从下面选项选择照片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction * ablumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }];
    
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"从相机选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectImageWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction * canCelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alertController addAction:ablumAction];
    [alertController addAction:cameraAction];
    [alertController addAction:canCelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)selectImageWithType:(UIImagePickerControllerSourceType )type {
    UIImagePickerController * pickController = [[UIImagePickerController alloc] init];
    pickController.allowsEditing = YES;
    //  NSString(Foundation) 底层使用CFStringRef(CoreFoundation)实现
    pickController.mediaTypes = @[(__bridge NSString *)kUTTypeImage];
    pickController.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        //  如果支持
        
        pickController.sourceType = type;
        
        if (type == UIImagePickerControllerSourceTypeCamera) {
            //  前置
            pickController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            pickController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        //        [self.navigationController pushViewController:pickController animated:YES];
        [self presentViewController:pickController animated:YES completion:nil];
        
    }else {
        //
//        [self.hudManager showErrorWithMessage:@"当前相机不可用" duration:1];
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD showErrorWithStatus:@"当前相机不可用"];
    }
}
#pragma mark - UIImagePikercontroller的协议
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
//        [weakSelf.userIcon setBackgroundImage:newImage forState:UIControlStateNormal];
//        [weakSelf.userIcon setTitle:@"" forState:UIControlStateNormal];
        
        [weakSelf uploadHeadImage:newImage];
        
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


#pragma mark - 上传图片
- (void)uploadHeadImage:(UIImage *)image {
    
    
//    [self.hudManager showMessage:@"头像上传中..."];
    [SVProgressHUD showWithStatus:@"头像上传中..."];
    
    JYUser * user = [JYUser currentUser];
    
    NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/userIcon.plist"]];
    
    //  读取归档文件
    NSMutableData *readData = [NSMutableData dataWithContentsOfFile:filepath];

    
    AVFile * headImageFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@userIcon",user.username] data:readData];
    
    [headImageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //  将以前的头像删除，然后更新现在的头像
            AVQuery * query = [AVQuery queryWithClassName:@"_File"];
            
            [query whereKey:@"name" equalTo:headImageFile.name];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    //  没有找到，开始存储
                }else {
                    for (AVObject * object in objects) {
                        NSLog(@"%@",object.objectId);
                        if ([headImageFile.objectId isEqualToString:object.objectId]) {
                            //  如果存入的Id和已有的id相同，则不管
                        }else {
                            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    NSLog(@"成功");
                                }else {
                                    NSLog(@"%@",error.localizedDescription);
                                }
                            }];
                        }
                    }
                }
            }];

            user.headUrl = headImageFile.url;
            
            //  更新数据库
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showSuccessWithStatus:@"头像更新成功"];
                    
                    [self getDataFromCurrentUser];
                }else {
                    [SVProgressHUD setMinimumDismissTimeInterval:1];
                    [SVProgressHUD showErrorWithStatus:@"头像更新失败，请稍后再试"];
                }
            }];
        }else {
        
        }
    }];
}



#pragma mark - 创建顶部视图
- (void)creatTopUI {
    _totalView = [[UIView alloc] initWithFrame:self.view.frame];
    _totalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalView];
    
    NSLog(@"%@",self.WholeBlueBackImage);
    NSLog(@"%@",self.WholeBlueBackImage.image);
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 240)];
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    //  1.获取单例对象
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //  2.读取数据
    NSData * data = [user objectForKey:@"SkinBGImage"];
    //  设置背景图片
    [_backImageView setImage:[UIImage imageNamed:@"1.jpg"]];
//    [_backImageView setImage:[UIImage imageWithData:data]];
    
    
    _backImageView.image = self.WholeBlueBackImage.image;
    _backImageView.clipsToBounds = YES;
    _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView.backgroundColor = [UIColor whiteColor];
    [_totalView addSubview:_backImageView];
    
    
   
    _backImageEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _backImageVisualEffect = [[UIVisualEffectView alloc] initWithEffect:_backImageEffect];
    _backImageVisualEffect.frame = _backImageView.frame;
    _backImageVisualEffect.alpha = 1;
    [_backImageView addSubview:_backImageVisualEffect];
    
    
    //  右上角的编辑按钮
    _userEditBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(userInfoEditClick)];
    
    self.navigationItem.rightBarButtonItem = _userEditBtn;
}

#pragma mark - 编辑按钮点击以后的方法
- (void)userInfoEditClick {
    
    _isAllowEdit = !_isAllowEdit;
    if (_isAllowEdit) {
        self.userEditBtn.title = @"退出编辑";
    }else{
        self.userEditBtn.title = @"编辑";
    }
    
    
    [self.userTabelView reloadData];
}


#pragma mark - UItableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (_isAllowEdit) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    
    if (indexPath.row == 0) {
        //  昵称
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userDataSource[0]];
        cell.textLabel.text = @"昵称";
    }else if (indexPath.row == 1) {
        //  邮箱
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userDataSource[1]];
        cell.textLabel.text = @"邮箱";
    }
    else if (indexPath.row == 2) {
        //  手机号
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userDataSource[2]];
        cell.textLabel.text = @"手机号";
    }
    else if (indexPath.row == 3) {
        //  笔记个数
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userDataSource[3]];
        cell.textLabel.text = @"笔记个数";
    }else if (indexPath.row == 4) {
        //  城市个数
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.userDataSource[4]];
        cell.textLabel.text = @"城市个数";
    }
    
//    cell.textLabel.text = self.userDataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isAllowEdit) {
        //  如果处在正在编辑的状态
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请输入新的" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"%@",textField.text);
                //  转存里面的TextFile
                _userInputTextField = textField;
                
            }];
            UIAlertAction * YesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //  调用保存的方法
                [SVProgressHUD showWithStatus:@"正在保存"];
                [self saveUserEditInfo:indexPath];
            }];
            UIAlertAction * NoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //   保存
            }];
            
            [alertController addAction:YesAction];
            [alertController addAction:NoAction];
            
            [self presentViewController:alertController animated:YesAction completion:nil];

        }else {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"当前选项不能更改！"];
            
        }
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 保存用户的修改数据
- (void)saveUserEditInfo:(NSIndexPath * )indexPath {
    //   保存
    //  确定以后，拿到最终输入的值 然后将这个值保存到当前用户的对应地方
    NSLog(@"%@",_userInputTextField.text);
    __weak typeof(self) weakSelf = self;
    JYUser * currentUser = [JYUser currentUser];
    if (indexPath.row == 0) {
        //  昵称
        
        currentUser.username = _userInputTextField.text;
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //  保存
                [weakSelf getDataFromCurrentUser];
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else {
                NSLog(@"%@",error.localizedDescription);
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存失败请稍后再试"];
            }
        }];
    }
    
    if (indexPath.row == 1) {
        //  邮箱
        //  进行邮箱的正则判断
        //  正则表达式验证邮箱
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        //  谓词：匹配条件
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:_userInputTextField.text]) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"邮箱格式填写有误"];
            return;
        }
        
        //  保存
        currentUser.email = _userInputTextField.text;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //  保存
                [weakSelf getDataFromCurrentUser];
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else {
                NSLog(@"%@",error.localizedDescription);
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存失败请稍后再试"];
            }
        }];
    }
    
    if (indexPath.row == 2) {
        //  手机
        //  进行手机号正则判断
        if (![JYWeatherTools isMobileNumber:_userInputTextField.text]) {
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:@"手机号码格式填写有误"];
            return;
        }
        
        currentUser.mobilePhoneNumber = _userInputTextField.text;
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                //  保存
                [weakSelf getDataFromCurrentUser];
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else {
                NSLog(@"%@",error.localizedDescription);
                [SVProgressHUD setMinimumDismissTimeInterval:1];
                [SVProgressHUD showSuccessWithStatus:@"保存失败请稍后再试"];
            }
        }];
    }
    
    
}



#pragma mark - KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"text"]) {
        NSString * str = [change objectForKey:NSKeyValueChangeNewKey];
        
        NSLog(@"%@",str);
    }
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.userTabelView.contentOffset.y < 0) {
        CGRect frame = self.backImageView.frame;
        frame.size.height = 240 - scrollView.contentOffset.y;
        self.backImageView.frame = frame;
        self.backImageVisualEffect.frame = frame;
        self.userTabelView.frame = CGRectMake(0, 0, Width, Height);
    }else if(self.userTabelView.contentOffset.y >0 && self.userTabelView.contentOffset.y < 140){
        CGRect frame = self.backImageView.frame;
        frame.size.height = 240 - scrollView.contentOffset.y;
        self.backImageView.frame = frame;
        self.backImageVisualEffect.frame = frame;
    }
    
    CGFloat height = 140;
    CGFloat position = MAX(-scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    
    _backImageVisualEffect.alpha = 1 - percent;
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
