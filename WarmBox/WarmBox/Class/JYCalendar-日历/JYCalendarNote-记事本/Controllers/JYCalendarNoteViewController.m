//
//  JYCalendarNoteViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/4.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

//  ============记事本

#import "JYCalendarNoteViewController.h"

@interface JYCalendarNoteViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem * saveBtn;

//  标题栏
@property (nonatomic, strong) UITextField * titleField;
//  内容栏
@property (nonatomic, strong) UITextView * contentField;
//  类型
@property (nonatomic, strong) NSString * noteType;

//  时间栏
//  工具栏
@property (nonatomic, strong) UIToolbar * toolBar;


@end

@implementation JYCalendarNoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self willShowTheBGImgae:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    self.noteType = @"1";
}


#pragma mark - 创建界面
- (void)creatUI {

    self.navigationItem.title = self.selectedDate;
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    [self.view addSubview:_titleField];
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.returnKeyType = UIReturnKeyNext;
    _titleField.placeholder = @"请输入记事标题";

    _contentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 46 + 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44)];
    [self.view addSubview:_contentField];
    _contentField.returnKeyType = UIReturnKeyDefault;
    _contentField.font = [UIFont systemFontOfSize:17.0];
//    _contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    _contentField.placeholder = @"请输入内容";
    _contentField.delegate = self;
    _contentField.showsHorizontalScrollIndicator = YES;
    _contentField.showsVerticalScrollIndicator = YES;
    _contentField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _toolBar.tintColor = [UIColor whiteColor];
    _toolBar.barStyle = UIBarStyleBlack;
    //  添加三个按钮
    UIBarButtonItem * selectImage = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
    UIBarButtonItem * voice = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(voiceBtnClick)];
    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    
    [_toolBar setItems:@[selectImage, voice, share] animated:YES];
    
//    [self.view addSubview:_toolBar];
//    [_toolBar bringSubviewToFront:_contentField];
    
    _contentField.inputAccessoryView = _toolBar;
    
    [self creatSaveBtn];
    [self creatToolBar];
}

#pragma mark - 创建保存按钮
- (void)creatSaveBtn {
    _saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    
    self.navigationItem.rightBarButtonItem = _saveBtn;
}
#pragma mark - 保存按钮
- (void)saveData {
//    if (self.titleField.text == nil || self.contentField.text == nil) {
//        [JYWeatherTools showMessageWithAlertView:@"标题或者内容不能为空！"];
//    }else {
//        BOOL ret = [[JYBasicDataManager new] checkIsInDBWithTitle:self.titleField.text andDate:self.selectedDate];
//        if (ret) {
//            [JYWeatherTools showMessageWithAlertView:@"标题重复，请重新填写"];
//        }else {
////            [[JYBasicDataManager new] insertDateWithDate:self.selectedDate andTitle:self.titleField.text andContent:self.contentField.text];
//            //  在Documents中，以日期和标题命名
    
    //  创建文件管理器 -- 提供了一个单例方法 defaultManager
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = [NSError new];
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.selectedDate]];
    //  创建文件夹
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    //  保存前，判断标题是否为空
    if (self.titleField.text.length == 0) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"标题或内容不能为空"];
        
        return;
    }
    
    //  保存前，先判断标题名称是否已经保存
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:nil];
    int flag = 1;
    for (NSString * tempPath in contentsArray) {
        NSArray * noteAllNameArray = [tempPath componentsSeparatedByString:@"+"];
        NSLog(@"====%@",tempPath);
        if ([noteAllNameArray.firstObject isEqualToString:[NSString stringWithFormat:@"%@",self.titleField.text]]) {
            [JYWeatherTools showMessageWithAlertView:@"标题重复，请重新填写"];
            flag = 0;
            break;
        }else {
            flag = 1;
        }
    }
    if (flag) {
        
        
        NSString * nowTime = [JYWeatherTools getNowDataWithFormate:@"HH-mm"];
        
        
        //  存入格式 标题+类型+记录时间.plist
        NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@+%@+%@.plist",self.selectedDate,self.titleField.text,self.noteType,nowTime]];
        //  借助NSData中转存储
        
        NSLog(@"path = %@",path);
        
        NSMutableData *data = [NSMutableData data];
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:self.contentField.attributedText forKey:@"note"];
        //  完成归档    会将数组的数组 写到NSData中
        [archiver finishEncoding];
        //  NSLog(@"%@",data);
//          将完成归档的二进制数据存储到本地 存储格式是字典 后缀为plist
        [data writeToFile:filepath atomically:NO];
    
        
        
        
        //  ========处理上传的问题，在日记缓存目录里面再新建文件来处理缓存文件
        NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteCatch"]];
        //  创建文件夹
        [manager createDirectoryAtPath:pathCatch withIntermediateDirectories:YES attributes:nil error:&error];
        
        //  存入到noteCatch 日期#标题+类型+时间.plist
        
        [data writeToFile:[NSString stringWithFormat:@"%@/%@#%@+%@+%@.plist",pathCatch,self.selectedDate,self.titleField.text, self.noteType, nowTime] atomically:NO];
        
        
        
        
        //  保存数据到云端
        
        [self saveNoteWithData:data andTime:nowTime];
        
        [JYWeatherTools showMessageWithAlertView:@"添加成功"];
    }
    
}

#pragma mark - 保存数据到云端
- (void)saveNoteWithData:(NSData *)data andTime:(NSString *)time{
    
    //  将这个data保存到云端 - 日期+文件
    //  以数组的方式保存
    NSMutableArray * fileArray = [[NSMutableArray alloc] init];
    //  数组里面保存AVfile数据
    AVFile * tempFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@#%@+%@+%@",self.selectedDate,self.titleField.text,self.noteType,time] data:data];
    NSLog(@"%@",tempFile);
    
    [tempFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //  将文件进行保存
        if (succeeded) {
            [fileArray addObject:tempFile];
            //  获取当前登录的用户
            JYUser * currentUser = [JYUser currentUser];
            if (currentUser) {
//                //  获取当前用户的noteArray
//                NSArray * arr = [currentUser objectForKey:@"noteArray"];
//                if (arr.count != 0) {
//                    //  存在数据
//                    for (AVFile * tempFileX in arr) {
//                        AVObject * obj = [AVObject objectWithClassName:@"_File" objectId:tempFileX.objectId];
//                        
//                        [obj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//                            if (!error) {
//                                AVFile * file = [AVFile fileWithAVObject:obj];
//                                //  找到了File
//                                NSLog(@"%@",file.name);
//                                if ([file.name isEqualToString:tempFile.name]) {
//                                    NSLog(@"%@",file.name);
//                                    NSLog(@"%@",tempFile.name);
//                                    
//                                    //  删除原有的file
//                                    [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                        if (succeeded) {
//                                            //
//                                        }else {
//                                            NSLog(@"删除失败的原有%@",error.localizedDescription);
//                                        }
//                                    }];
//                                }
//                                
//                            }else {
//                                NSLog(@"网络加载%@",error.localizedDescription);
//                            }
//                        }];
//
//                    }
//                }
                
                AVQuery * query = [AVQuery queryWithClassName:@"_File"];
                
                [query whereKey:@"name" equalTo:tempFile.name];
                
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    
                    if (objects.count == 0) {
                        //  没有找到，开始存储
//                        //  如果用户存在，进行保存
//                        [currentUser addObjectsFromArray:fileArray forKey:@"noteArray"];
//                        
//                        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                            if (succeeded) {
//                                //  用户保存以后，应该要进行
//                            }
//                        }];
                        
                        
                    }else {
                        for (AVObject * object in objects) {
                            NSLog(@"%@",object.objectId);
                            if ([tempFile.objectId isEqualToString:object.objectId]) {
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
                    
                    //  没有找到，开始存储
                    //  如果用户存在，进行保存
                    [currentUser addObjectsFromArray:fileArray forKey:@"noteArray"];
                    
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //  笔记缓存目录
                            NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteCatch"]];
                            //  获取当前目录下的所有文件
                            //  读取某个文件夹下所有的文件夹或者文件
                            NSFileManager * manager = [NSFileManager defaultManager];
                            NSError * error = nil;
                            NSArray * contentsArray = [manager contentsOfDirectoryAtPath:pathCatch error:(&error)];
                            //  如果NSError有值，就表示出错
                            if (!error) {
                                //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
                                for (NSString * str in contentsArray) {
                                    NSArray * strArray = [str componentsSeparatedByString:@".plist"];
                                    NSString * fileNameStr = [strArray firstObject];
                                    
                                    NSLog(@"str%@",str);
                                    NSLog(@"%@",fileNameStr);
                                    NSLog(@"temp%@",tempFile.name);
                                    //  2016-07-21#123+1+20-03
                                    if ([fileNameStr isEqualToString:tempFile.name]) {
                                        //  上传成功，并且找到了相同的文件，就删除这个文件
                                        [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
                                        
                                    }
                                }
                            }
                            
                        }else {
                            //  失败了，删除刚刚上传的文件
                            [tempFile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                               //
                                if (succeeded) {
                                    //  删除成功
                                }else {
                                    //  失败
                                }
                            }];
                        }
                    }];
                }];
                
                
            }
        }else {
            NSLog(@"===er%@",error);
        }
    }];
}


#pragma mark - 创建ToolBar
- (void)creatToolBar {
//    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewFrameH - 44, viewFrameW, 44)];
//    _toolBar.tintColor = [UIColor whiteColor];
//    _toolBar.barStyle = UIBarStyleBlack;
//    //  添加三个按钮
//    UIBarButtonItem * selectImage = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
//    UIBarButtonItem * voice = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(voiceBtnClick)];
//    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
//    
//    [_toolBar setItems:@[selectImage, voice, share] animated:YES];
//    
//    [self.view addSubview:_toolBar];
//    [_toolBar bringSubviewToFront:_contentField];
}

#pragma mark - ToolBar的按钮
//  选择图片
- (void)selectImageBtnClick {
    UIImagePickerController * imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//  imagePicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    //  获取图片的大小
    CGSize oldSize = image.size;
    CGSize newSize = CGSizeMake(oldSize.width * 0.3, oldSize.height * 0.3);
//    
    UIImage * newImage = [self thumbnailWithImageWithoutScale:image size:newSize];
//
    [self dismissViewControllerAnimated:YES completion:^{
        self.contentField.attributedText = [JYWeatherTools mixImage:newImage andText:self.contentField.attributedText andTextFontSize:17.0];
        self.contentField.font = [UIFont systemFontOfSize:17.0];
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

//  语言识别
- (void)voiceBtnClick {
    
}
//  分享
- (void)shareBtnClick {
    [_contentField resignFirstResponder];
}

#pragma mark - textField的代理方法
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    //
//    CGRect frame = self.toolBar.frame;
//    frame.origin.y = frame.origin.y - 252;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.toolBar.frame = frame;
//    }];
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    CGRect frame = self.toolBar.frame;
//    frame.origin.y = frame.origin.y + 252;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.toolBar.frame = frame;
//    }];
//}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    CGRect frameToolBar = self.toolBar.frame;
//    frameToolBar.origin.y = frameToolBar.origin.y - 252;
//    
//    CGRect frameConet = self.contentField.frame;
//    frameConet.size.height = frameConet.size.height - 252;
//    
//    [UIView animateWithDuration:0.35 animations:^{
//        self.toolBar.frame = frameToolBar;
//        self.contentField.frame = frameConet;
//    }];
//}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    CGRect frameToolBar = self.toolBar.frame;
//    frameToolBar.origin.y = frameToolBar.origin.y + 252;
//    
//    CGRect frameConet = self.contentField.frame;
//    frameConet.size.height = frameConet.size.height + 252;
//    
//    [UIView animateWithDuration:0.35 animations:^{
//        self.toolBar.frame = frameToolBar;
//        self.contentField.frame = frameConet;
//    }];
//    [self.contentField resignFirstResponder];
//}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    
    //  让视图往上面移动
    [UIView animateWithDuration:0.3 animations:^{
        //  让整体视图往上移动
//        self.toolBar.transform = CGAffineTransformMakeTranslation(0, -keyboardSize.height);
        _contentField.frame =CGRectMake(0, 46 + 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44 - keyboardSize.height);
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
//        self.toolBar.transform = CGAffineTransformIdentity;
        _contentField.frame =CGRectMake(0, 46 + 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44);
        
    }];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat transformY = height;
    if (transformY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = transformY ;
        self.view.frame = frame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.toolBar.frame;
    frame.origin.y = frame.origin.y - 300;
    self.toolBar.frame = frame;
}


//- (void) registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
//}
//
//- (void) keyboardWasShown:(NSNotification *) notif
//{
//    NSDictionary *info = [notif userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    
//    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
//    ///keyboardWasShown = YES;
//}
//- (void) keyboardWasHidden:(NSNotification *) notif
//{
//    NSDictionary *info = [notif userInfo];
//    
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
//    // keyboardWasShown = NO;
//    
//}

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
