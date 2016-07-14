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

//  时间栏
//  工具栏
@property (nonatomic, strong) UIToolbar * toolBar;


@end

@implementation JYCalendarNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatUI];
}

#pragma mark - 创建界面
- (void)creatUI {

    self.navigationItem.title = self.selectedDate;
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    [self.view addSubview:_titleField];
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.returnKeyType = UIReturnKeyNext;
    _titleField.placeholder = @"请输入记事标题";

    _contentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 46 + 64, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 44 - 44)];
    [self.view addSubview:_contentField];
    _contentField.returnKeyType = UIReturnKeyDefault;
    _contentField.font = [UIFont systemFontOfSize:17.0];
//    _contentField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//    _contentField.placeholder = @"请输入内容";
    _contentField.delegate = self;
    _contentField.showsHorizontalScrollIndicator = YES;
    _contentField.showsVerticalScrollIndicator = YES;
    _contentField.autocapitalizationType  = UITextAutocapitalizationTypeNone;
    
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
    
    //  保存前，先判断标题名称是否已经保存
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:nil];
    int flag = 1;
    for (NSString * tempPath in contentsArray) {
        NSLog(@"====%@",tempPath);
        if ([tempPath isEqualToString:[NSString stringWithFormat:@"%@.plist",self.titleField.text]]) {
            [JYWeatherTools showMessageWithAlertView:@"标题重复，请重新填写"];
            flag = 0;
            break;
        }else {
            flag = 1;
        }
    }
    if (flag) {
        
        NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.plist",self.selectedDate,self.titleField.text]];
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
        
        [JYWeatherTools showMessageWithAlertView:@"添加成功"];
    }
    
}


#pragma mark - 创建ToolBar
- (void)creatToolBar {
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewFrameH - 44, viewFrameW, 44)];
    _toolBar.tintColor = [UIColor whiteColor];
    _toolBar.barStyle = UIBarStyleBlack;
    //  添加三个按钮
    UIBarButtonItem * selectImage = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_photo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(selectImageBtnClick)];
    UIBarButtonItem * voice = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_voice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(voiceBtnClick)];
    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"toolBar_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(shareBtnClick)];
    
    [_toolBar setItems:@[selectImage, voice, share] animated:YES];
    
    [self.view addSubview:_toolBar];
    [_toolBar bringSubviewToFront:_contentField];
}

#pragma mark - ToolBar的按钮
//  选择图片
- (void)selectImageBtnClick {
    UIImagePickerController * imagePicker =[[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//  imagePicker的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    
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

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frameToolBar = self.toolBar.frame;
    frameToolBar.origin.y = frameToolBar.origin.y - 252;
    
    CGRect frameConet = self.contentField.frame;
    frameConet.size.height = frameConet.size.height - 252;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.toolBar.frame = frameToolBar;
        self.contentField.frame = frameConet;
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect frameToolBar = self.toolBar.frame;
    frameToolBar.origin.y = frameToolBar.origin.y + 252;
    
    CGRect frameConet = self.contentField.frame;
    frameConet.size.height = frameConet.size.height + 252;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.toolBar.frame = frameToolBar;
        self.contentField.frame = frameConet;
    }];
    [self.contentField resignFirstResponder];
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

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
