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

@end

@implementation JYCalendarBirthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    _timeForBirth = [[UILabel alloc] initWithFrame:CGRectMake(0, _name.frame.origin.y + 44 + 5, _name.frame.size.width, 44)];
    _timeForBirth.text = @"点击选择时间";
    _timeForBirth.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.7];
    _timeForBirth.backgroundColor = [UIColor whiteColor];
    _timeForBirth.userInteractionEnabled = YES;
    
    [self.view addSubview:_timeForBirth];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dataSelecter)];
    [_timeForBirth addGestureRecognizer:tapGesture];
    
    _notiThing = [[UITextView alloc] initWithFrame:CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 5, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 5 - 5)];
    _notiThing.backgroundColor = [UIColor whiteColor];
    
    _notiThing.text = @"备注";
    _notiThing.font = [UIFont systemFontOfSize:17.0];
    _notiThing.textColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.7];
    _notiThing.delegate = self;
    [self.view addSubview:_notiThing];
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
        _notiThing.frame =CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 5, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 5 - 5 - keyboardSize.height);
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
        _notiThing.frame =CGRectMake(0, _timeForBirth.frame.origin.y + 44 + 5, _timeForBirth.frame.size.width, self.view.frame.size.height - _timeForBirth.frame.origin.y - 44 - 5 - 5);
        
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
