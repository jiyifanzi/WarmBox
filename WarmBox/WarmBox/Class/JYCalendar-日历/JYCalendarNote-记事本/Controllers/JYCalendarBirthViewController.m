//
//  JYCalendarBirthViewController.m
//  WarmBox
//
//  Created by JiYi on 16/7/22.
//  Copyright © 2016年 JiYi. All rights reserved.
//

//  ============生日

#import "JYCalendarBirthViewController.h"

@interface JYCalendarBirthViewController () <UIGestureRecognizerDelegate, UITextViewDelegate>

//  寿星名字
@property (nonatomic, strong) UITextField * name;
//  生日的日期
@property (nonatomic, strong) UILabel * timeForBirth;
//  提醒事件
@property (nonatomic, strong) UITextView * notiThing;

@property (nonatomic, strong) NSString * noteType;

@property (nonatomic, strong) UIBarButtonItem * saveBtn;

@end

@implementation JYCalendarBirthViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [self willShowTheBGImgae:NO];
    
    self.noteType = @"2";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [self creatUI];
}

#pragma mark - 创建界面
- (void)creatUI {
    //  寿星名字
    _name = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    _name.backgroundColor = [UIColor whiteColor];
    _name.returnKeyType = UIReturnKeyNext;
    _name.placeholder = @"寿星的名字";
    [self.view addSubview:_name];
    
    _timeForBirth = [[UILabel alloc] initWithFrame:CGRectMake(0, _name.frame.origin.y + 44 + 2, _name.frame.size.width, 44)];
    _timeForBirth.text = @"点击选择时间";
    _timeForBirth.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.7];
    _timeForBirth.backgroundColor = [UIColor whiteColor];
    _timeForBirth.userInteractionEnabled = YES;
    
    
    
    [self.view addSubview:_timeForBirth];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataSelecter)];
    [_timeForBirth addGestureRecognizer:tapGesture];
    
    _notiThing = [[UITextView alloc] initWithFrame:CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 2, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 2 - 2)];
    _notiThing.backgroundColor = [UIColor whiteColor];
    
    _notiThing.text = @"备注";
    _notiThing.font = [UIFont systemFontOfSize:17.0];
//    _notiThing.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.7];
    _notiThing.delegate = self;
    [self.view addSubview:_notiThing];
    
    
    _saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    
    self.navigationItem.rightBarButtonItem = _saveBtn;
}

#pragma mark - 选择日期的手势事件
- (void)dataSelecter {
//    _timeForBirth.text = nil;
    
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    picker.frame = CGRectMake(0, 40, self.view.frame.size.width - 10, 200);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        _timeForBirth.textColor = [UIColor blackColor];
        NSDate *SelectedDate = picker.date;

        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
        formatter.dateFormat = @"yyyy-MM-dd";
        
        NSString * dateStr = [formatter stringFromDate:SelectedDate];
        
        _timeForBirth.text = dateStr;
        
    }];
    
    [alertController.view addSubview:picker];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 保存按钮
- (void)saveData {

    
    //  创建文件管理器 -- defaultManager
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = [NSError new];
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",self.selectedDate]];
    //  创建文件夹
    [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    
    //  保存前，判断标题是否为空
    if (self.name.text.length == 0 || self.timeForBirth.text.length == 0) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD showErrorWithStatus:@"名字或日期不能为空"];
        
        return;
    }
    
    //  保存前，先判断标题名称是否已经保存
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:nil];
    int flag = 1;
    for (NSString * tempPath in contentsArray) {
        NSArray * noteAllNameArray = [tempPath componentsSeparatedByString:@"+"];
        NSLog(@"====%@",tempPath);
        if ([noteAllNameArray.firstObject isEqualToString:[NSString stringWithFormat:@"%@",self.name.text]]) {
            [JYWeatherTools showMessageWithAlertView:@"名字重复，请重新填写"];
            flag = 0;
            break;
        }else {
            flag = 1;
        }
    }
    if (flag) {
        
        
        NSString * nowTime = [JYWeatherTools getNowDataWithFormate:@"HH-mm"];
        
        
        //  存入格式 标题+类型+记录时间.plist
        NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@+%@+%@.plist",self.selectedDate,self.name.text,self.noteType,nowTime]];
        //  借助NSData中转存储
        
        NSLog(@"path = %@",path);
        
        NSMutableData *data = [NSMutableData data];
        
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:self.notiThing.attributedText forKey:@"note"];
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
        
        [data writeToFile:[NSString stringWithFormat:@"%@/%@#%@+%@+%@.plist",pathCatch,self.selectedDate,self.name.text, self.noteType, nowTime] atomically:NO];
        
        
        
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
    AVFile * tempFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@#%@+%@+%@",self.selectedDate,self.name.text,self.noteType,time] data:data];
    NSLog(@"%@",tempFile);
    
    [tempFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //  将文件进行保存
        if (succeeded) {
            [fileArray addObject:tempFile];
            //  获取当前登录的用户
            JYUser * currentUser = [JYUser currentUser];
            if (currentUser) {

                
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



#pragma mark - UITextView的代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView  {
    textView.text = nil;
}


#pragma mark - 监听事件
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    
    //  让视图往上面移动
    [UIView animateWithDuration:0.3 animations:^{
        //  让整体视图往上移动
        _notiThing.frame =CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 2, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 2 - 2 - keyboardSize.height);
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
        _notiThing.frame =CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 2, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 2 - 2);
        
    }];
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
