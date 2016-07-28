//
//  JYCalendarViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/4.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYCalendarViewController.h"
#import "FSCalendar.h"
//  笔记
#import "JYCalendarNoteViewController.h"
//  生日
#import "JYCalendarBirthViewController.h"
//  提醒
#import "JYCalendarNotiViewController.h"

#import "JYShowNoteViewController.h"
#import "JYCalendarTableViewCell.h"


//  ======PopView
#import "XTPopView.h"


@interface JYCalendarViewController ()<FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate, selectIndexPathDelegate>

//  日历的对象
@property (nonatomic, strong) FSCalendar * jy_Calendar;
//  农历的数组
@property (nonatomic, strong) NSArray * lunarChars;
//  本地的日历
@property (nonatomic, strong) NSCalendar * lunarCalendar;

//  存入事件的日期数组
@property (nonatomic, strong) NSMutableArray * datesWithEvent;
//  已经选中的日期
@property (nonatomic, strong) NSArray * datesShouldNotBeSelected;

//  =======NavBtn
//  回到今天
@property (nonatomic, strong) UIBarButtonItem * backToday;
//  添加事件
@property (nonatomic, strong) UIBarButtonItem * addEvent;


//  选中天的日程
@property (nonatomic, strong) UITableView * dateForEventsTableView;
@property (nonatomic, strong) NSMutableArray * dateEventsDataSource;


//  PopView
@property (nonatomic, strong) XTPopView * popView;

@end



@implementation JYCalendarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    [self getDateFromDBForDateEventsDataSource];
    [self willShowTheBGImgae:NO];
    
    [self getDateFromDBForDatesWithEvents];
    
    [self getDateFromSelectedDay:_jy_Calendar.selectedDate withCalendar:self.jy_Calendar];
    [_jy_Calendar reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //  设置导航栏文字
    NSDate * now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    formatter.dateFormat = @"MM月dd日";
    NSString * data = [formatter stringFromDate:now];
    
    self.navigationItem.title =data;
    

    [self creatUI];
    
}

#pragma mark - 懒加载
- (NSCalendar *)lunarCalendar {
    if (!_lunarCalendar) {
        _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    return _lunarCalendar;
}
- (NSArray *)lunarChars {
    if (!_lunarChars) {
        _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
    }
    return _lunarChars;
}

- (NSMutableArray *)dateEventsDataSource {
    if (!_dateEventsDataSource) {
        _dateEventsDataSource = [NSMutableArray array];
//        [self getDateFromDBForDateEventsDataSource];
    }
    return _dateEventsDataSource;
}

- (NSArray *)datesWithEvent {
    if (!_datesWithEvent) {
        _datesWithEvent = [NSMutableArray array];
        [self getDateFromDBForDatesWithEvents];
    }
    return _datesWithEvent;
}

#pragma mark - 获取数据库的资源
- (void)getDateFromDBForDateEventsDataSource {
    [_dateEventsDataSource removeAllObjects];
    //  从数据库提取数据
    NSArray * dataArray = [NSArray new];
    if (_jy_Calendar.selectedDate) {
        dataArray = [[JYBasicDataManager new] getDataWithDate:[_jy_Calendar  stringFromDate:[_jy_Calendar selectedDate]]];
    }else {
        dataArray = [[JYBasicDataManager new] getDataWithDate:[_jy_Calendar  stringFromDate:[_jy_Calendar today]]];
    }
    
    [_dateEventsDataSource addObjectsFromArray:dataArray];
    [_dateForEventsTableView reloadData];
}
- (void)getDateFromDBForDatesWithEvents{
    [_datesWithEvent removeAllObjects];

    //  获取全部的时间
    //  获取当天的文件目录
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents"]];
    
    //  获取当前目录下的所有文件
    //  读取某个文件夹下所有的文件夹或者文件
    //  创建文件管理器 -- 提供了一个单例方法 defaultManager
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:(&error)];
    NSMutableArray * fileArray = [NSMutableArray array];
    //  如果NSError有值，就表示出错
    if (!error) {
        //  如果没有问题，就可以遍历，数组中存储的是所有文件的全路径
        for (NSString * str in contentsArray) {
            if ([str rangeOfString:@"-"].length != 0) {
                [fileArray addObject:str];
            }
            NSLog(@"%@",str);
        }
    }
    for (NSString * dateStr in fileArray) {
        [self.datesWithEvent addObject:dateStr];
    }
    [_dateForEventsTableView reloadData];
}


#pragma mark - 创建用户界面
- (void)creatUI {
    //  初始化日历对象
    _jy_Calendar =  [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, Height*1.5/3.0f)];
    [self.view addSubview:_jy_Calendar];
    //  设置相关的属性
    _jy_Calendar.backgroundColor = [UIColor whiteColor];
    _jy_Calendar.delegate = self;
    _jy_Calendar.dataSource = self;
    _jy_Calendar.showsScopeHandle = YES;
    _jy_Calendar.appearance.headerMinimumDissolvedAlpha = 0;
    _jy_Calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase | FSCalendarCaseOptionsWeekdayUsesUpperCase;
    _jy_Calendar.appearance.weekdayTextColor = [UIColor colorWithRed:0 green:191/255.0 blue:1 alpha:1];
    _jy_Calendar.appearance.headerTitleColor = [UIColor darkGrayColor];
    _jy_Calendar.appearance.eventColor = [UIColor colorWithRed:1 green:140/255.0 blue:0 alpha:1];
    _jy_Calendar.appearance.selectionColor = [UIColor colorWithRed:0 green:191/255.0 blue:1 alpha:1];
    _jy_Calendar.appearance.headerDateFormat = @"yyyy年MM月";
    _jy_Calendar.appearance.todayColor = [UIColor colorWithRed:1 green:140/255.0 blue:0 alpha:1];;
    
    _jy_Calendar.appearance.cellShape = FSCalendarCellShapeCircle;
    
    _jy_Calendar.appearance.headerMinimumDissolvedAlpha = 0.0;


    //  创建tableView
//    _dateForEventsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _jy_Calendar.frame.origin.y + _jy_Calendar.frame.size.height, Width, Height - _jy_Calendar.frame.size.height - _jy_Calendar.frame.origin.y - 64)];
    _dateForEventsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _jy_Calendar.frame.origin.y + _jy_Calendar.frame.size.height + 10, Width, Height - _jy_Calendar.frame.size.height - _jy_Calendar.frame.origin.y - 64)];
    
   [self.view addSubview:_dateForEventsTableView];
    
    
    //  设置属性
    _dateForEventsTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _dateForEventsTableView.delegate = self;
    _dateForEventsTableView.dataSource = self;
    _dateForEventsTableView.rowHeight = 90;
    _dateForEventsTableView.separatorStyle = UITableViewCellSelectionStyleNone;

    
    [_dateForEventsTableView registerNib:[UINib nibWithNibName:@"JYCalendarTableViewCell" bundle:nil] forCellReuseIdentifier:@"caCell"];
    //  添加Nav按钮
    [self addButtomItem];
    
    
    [_jy_Calendar selectDate:[_jy_Calendar today]];
    
    [self getDateFromSelectedDay:[_jy_Calendar today] withCalendar:self.jy_Calendar];
}

- (void)addButtomItem {
    _backToday = [[UIBarButtonItem alloc] initWithTitle:@"今" style:UIBarButtonItemStylePlain target:self action:@selector(backToToday)];
    self.navigationItem.leftBarButtonItem = _backToday;
    
    _addEvent = [[UIBarButtonItem alloc] initWithTitle:@"记事" style:UIBarButtonItemStylePlain target:self action:@selector(addEventForDay)];
    self.navigationItem.rightBarButtonItem = _addEvent;
}


#pragma mark - UITbaleView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateEventsDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
//    }
//    JYDateDataModel * model = self.dateEventsDataSource[indexPath.row];
//    
//    NSArray * noteAllName = [model.title componentsSeparatedByString:@"+"];
//    
//    cell.textLabel.text = noteAllName.firstObject;
//    
//    
//    cell.clipsToBounds = YES;
//    cell.layer.cornerRadius = 15;
////    cell.detailTextLabel.attributedText = model.content;
//    NSArray * strArr = [[NSString stringWithFormat:@"%@",model.content] componentsSeparatedByString:@"{"];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[strArr firstObject]];
//
//    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    
    JYCalendarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"caCell" forIndexPath:indexPath];
    
    cell.model = self.dateEventsDataSource[indexPath.row];
    
    cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 5;
    
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  将新增元素及删除元素同时返回，出现多选删除的状态
    return UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//  左滑删除数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //  判断此时为删除的情况model
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JYDateDataModel * model = self.dateEventsDataSource[indexPath.row];
        //  删除数据
        //  创建文件管理器 -- 提供了一个单例方法 defaultManager
        NSFileManager * manager = [NSFileManager defaultManager];
        //  获取当天的文件目录
        NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@+%@+%@.plist",[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate], model.title, model.noteType, model.nowTime]];
        
        NSLog(@"%@",path);
        
        
        //  ==========做网络同步的处理
        //  删除之前，将这个文件，转存到noteDeletCatch文件夹下面
        NSData * tempData = [NSData dataWithContentsOfFile:path];
        
        NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
        //  创建文件夹
        [manager createDirectoryAtPath:pathCatch withIntermediateDirectories:YES attributes:nil error:nil];
        
        //  存入到noteCatch 日期+标题.plist
        /*
          [data writeToFile:[NSString stringWithFormat:@"%@/%@#%@+%@+%@.plist",pathCatch,self.selectedDate,self.titleField.text, self.noteType, nowTime] atomically:NO];
         
         */
        [tempData writeToFile:[NSString stringWithFormat:@"%@/%@#%@+%@+%@.plist",pathCatch,[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate],model.title,model.noteType, model.nowTime] atomically:NO];
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@/%@#%@.plist",pathCatch,[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate],model.title]);
        //  2016-07-21#123+1+20-17副本+plist+plist.plist
        
        
        
        [manager removeItemAtPath:path error:nil];
        
        //  删除之后，还需要重新判断是否路劲下的东西已经全部清空，如果是，就把根目录页清空
        NSString * datePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate]]];
        NSArray * contentsArray = [manager contentsOfDirectoryAtPath:datePath error:nil];
        NSLog(@"%@",contentsArray);
        if ((contentsArray.count == 1 && [[contentsArray firstObject] isEqualToString:@".DS_Store"]) || contentsArray.count == 0) {
            //  此时只剩下 .DS_Store 删除目录
            [manager removeItemAtPath:datePath error:nil];
        }

        
        
        
        
        [self getDateFromSelectedDay:_jy_Calendar.selectedDate withCalendar:self.jy_Calendar];
        [self getDateFromDBForDatesWithEvents];

        [_jy_Calendar reloadData];
        
        [self.dateForEventsTableView reloadData];
        
        
        
        //  删除之后，要把对应的远程账户下的数组元素也要清空，也可以直接删除对应的File，让ObjectID为空
        JYUser * currentUser = [JYUser currentUser];
        NSMutableArray * userNoteArray = [currentUser objectForKey:@"noteArray"];
        
        //  根据名字找Fiel，再根据File来删除noteArray的数据
        NSString * fileName = [NSString stringWithFormat:@"%@#%@+%@+%@",[self.jy_Calendar stringFromDate:self.jy_Calendar.selectedDate], model.title, model.noteType, model.nowTime];

        //  2016-07-21#123+1+20-17副本
        NSLog(@"%@",fileName);
        
        for (AVFile * tempFiel in userNoteArray) {
            //  根据id来生成AVobejct，根据这个obejct来匹配
            NSLog(@"%@",tempFiel.objectId);
            
            AVObject * fileObj = [AVObject objectWithClassName:@"_File" objectId:tempFiel.objectId];
            [fileObj fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                if (!error) {
                    //  找到了
                    //  根据AVobject生成AVfile
                    AVFile * file = [AVFile fileWithAVObject:fileObj];
                    NSLog(@"%@",file.name);

                    
                    if ([file.name isEqualToString:fileName]) {
                        //  找到了相同的file
                        
                        
                        [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                           //   删除
                            if (succeeded) {
                                NSLog(@"删除成功");
                                //  删除成功的话，将NoteDeletaCatch下面的对应的文件也删除
                                //  删除笔记缓存目录
                                NSString * pathCatch = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/NoteDeleteCatch"]];
                                //  获取当前目录下的所有文件NoteDeleteCatch
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
                                        NSLog(@"%@",str);
                                        NSLog(@"%@",file.name);
                                        
                                        if ([fileNameStr isEqualToString:file.name]) {
                                            //  上传成功，并且找到了相同的文件，就删除这个文件
                                            [manager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",pathCatch,str] error:nil];
                                        }
                                    }
                                }

                            }else {
                                NSLog(@"%@",error.localizedDescription);
                            }
                        }];
                        
                        //  同时也要重新匹配数组
                        [userNoteArray removeObject:tempFiel];
                        //  再讲这个数组匹配给当前的用户
                        [currentUser setObject:userNoteArray forKey:@"noteArray"];
                        
                        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                //
                                NSLog(@"保存成");
                            }else {
                                NSLog(@"%@",error.localizedDescription);
                            }
                        }];
                    }
                    
                }
                
            }];
        }
        NSLog(@"%@",userNoteArray);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYDateDataModel * model = self.dateEventsDataSource[indexPath.row];
    
    JYShowNoteViewController * show = [[JYShowNoteViewController alloc] init];
    show.model =model;
    
    show.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:show animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 回到今天的按钮点击事件
- (void)backToToday {
    [_jy_Calendar setCurrentPage:[NSDate date] animated:YES];
    //   让日历显示在今天
    [_jy_Calendar selectDate:[_jy_Calendar today]];
    [self getDateFromSelectedDay:_jy_Calendar.selectedDate withCalendar:self.jy_Calendar];
    
}
#pragma mark - 添加日程的点击事件
- (void)addEventForDay {
    CGPoint point = CGPointMake(self.view.frame.size.width - 25,64);
    
    self.popView = [[XTPopView alloc] initWithOrigin:point My_Width:115 My_Height:40 * 2 Type:XTTypeOfUpRight Color:[UIColor colorWithRed:0.2737 green:0.2737 blue:0.2737 alpha:1.0]];
    self.popView.dataArray = @[@"记事",@"生日"];
    self.popView.images = @[@"发起群聊",@"添加朋友"];
    self.popView.fontSize = 13;
    self.popView.row_height = 40;
    self.popView.titleTextColor = [UIColor whiteColor];
    self.popView.delegate = self;
    
    [self.popView popView];
}

#pragma mark - XTpopView的代理方法
- (void)selectIndexPathRow:(NSInteger)index
{
    
    //  收回菜单
    [self.popView dismiss];
    
    switch (index) {
        case 0:
        {
            //  记事
            //  模态弹出界面，输入文字和事件，保存到数据库
            NSDate  * temp = [_jy_Calendar selectedDate];
            NSString * currentSelectedDate = [_jy_Calendar stringFromDate:temp];
            
            JYCalendarNoteViewController * note = [[JYCalendarNoteViewController alloc] init];
            if (currentSelectedDate.length != 0) {
                note.selectedDate = currentSelectedDate;
            }else {
                note.selectedDate = [_jy_Calendar stringFromDate:_jy_Calendar.today];
            }
            note.hidesBottomBarWhenPushed = YES;
            NSLog(@"%@",currentSelectedDate);
            [self.navigationController pushViewController:note animated:YES];
        }
            break;
        case 1:
        {
            //  记录生日
            NSDate  * temp = [_jy_Calendar selectedDate];
            NSString * currentSelectedDate = [_jy_Calendar stringFromDate:temp];
            
            JYCalendarBirthViewController * BirthDay = [[JYCalendarBirthViewController alloc] init];
            if (currentSelectedDate.length != 0) {
                BirthDay.selectedDate = currentSelectedDate;
            }else {
                BirthDay.selectedDate = [_jy_Calendar stringFromDate:_jy_Calendar.today];
            }
            BirthDay.hidesBottomBarWhenPushed = YES;
            NSLog(@"%@",currentSelectedDate);
            [self.navigationController pushViewController:BirthDay animated:YES];
        }
            break;
//        case 2:
//        {
//            //  提醒
//            NSDate  * temp = [_jy_Calendar selectedDate];
//            NSString * currentSelectedDate = [_jy_Calendar stringFromDate:temp];
//            
//            JYCalendarNoteViewController * note = [[JYCalendarNoteViewController alloc] init];
//            if (currentSelectedDate.length != 0) {
//                note.selectedDate = currentSelectedDate;
//            }else {
//                note.selectedDate = [_jy_Calendar stringFromDate:_jy_Calendar.today];
//            }
//            note.hidesBottomBarWhenPushed = YES;
//            NSLog(@"%@",currentSelectedDate);
//            [self.navigationController pushViewController:note animated:YES];
//        }
//            break;
        default:
            break;
    }
}


#pragma mark - 日历的代理方法
//  改变日历的frame
- (void)calendar:(FSCalendar * __nonnull)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect){calendar.frame.origin, bounds.size};
    _dateForEventsTableView.frame = CGRectMake(0, _jy_Calendar.frame.origin.y + _jy_Calendar.frame.size.height + 10, Width, Height - _jy_Calendar.frame.size.height - _jy_Calendar.frame.origin.y - 64);
    //  让日历显示最上面的日记
    _dateForEventsTableView.contentOffset = CGPointMake(0, 0);
}

//  打开农历显示
- (NSString *)calendar:(FSCalendar * __nonnull)calendar subtitleForDate:(NSDate * __nonnull)date {
    if (1) {
        NSInteger day = [self.lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
        return self.lunarChars[day-1];
    }
    return nil;
}
//  自定义今天的显示方式
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    return [calendar isDateInToday:date] ? @"今天" : nil;
}
//  选中日期的处理事件
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    //  此时的date就是选中的天数
    [self getDateFromSelectedDay:date withCalendar:calendar];
    
}

#pragma mark - 获取选中天数中，保存的事件
- (void)getDateFromSelectedDay:(NSDate *)selectDate
                  withCalendar:(FSCalendar *)calendar{
//    //  获取数据库中保存的当天的数据
//    NSArray * dataArray = [[JYBasicDataManager new] getDataWithDate:[calendar stringFromDate:selectDate]];
//    //  将数据源清空，存入新的数据
//    [self.dateEventsDataSource removeAllObjects];
//    [self.dateEventsDataSource addObjectsFromArray:dataArray];
    
    [self.dateEventsDataSource removeAllObjects];
    
    //  获取当天的文件目录
    NSString * path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",[calendar stringFromDate:selectDate]]];
    
    //  获取当前目录下的所有文件
    //  读取某个文件夹下所有的文件夹或者文件
    //  创建文件管理器 -- 提供了一个单例方法 defaultManager
    NSFileManager * manager = [NSFileManager defaultManager];
    NSError * error = nil;
    NSArray * contentsArray = [manager contentsOfDirectoryAtPath:path error:(&error)];

    //  contenetsArray里面存的是当前日期下面的所有文件名称
    for (NSString * tempPath in contentsArray) {
        if ([tempPath isEqualToString:@".DS_Store"]) {
            //
        }else if(tempPath.length != 0){
            
            NSString * filePath = [NSString stringWithFormat:@"%@/%@",path, tempPath];
            
            NSLog(@"%@",filePath);
            
            //  读取归档文件 123+1+20-17.plist
            NSMutableData *readData = [NSMutableData dataWithContentsOfFile:filePath];
            //  创建解归档
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:readData];
            //  decodeObjectForKey key就是名字
            NSAttributedString * str = [unarchiver decodeObjectForKey:@"note"];
            
            //  tempPath tempPath
            
            NSArray * fileNameArray = [tempPath componentsSeparatedByString:@".plist"];
            NSString * fileNameAll = [fileNameArray firstObject];
            
            NSArray * fileNameAllArray = [fileNameAll componentsSeparatedByString:@"+"];
            
            //  只能保存内容，标题通过此时的文件名来读取
            JYDateDataModel * model = [JYDateDataModel new];
            model.content = str;
            model.date = [calendar stringFromDate:selectDate];
            model.title = [fileNameAllArray firstObject];
            model.noteType = [fileNameAllArray objectAtIndex:1];
            model.nowTime = [fileNameAllArray lastObject];
            
            NSLog(@"%@",model);
//            
//            NSArray * titleArray = [tempPath componentsSeparatedByString:@"."];
//            NSString * noteAllName = [titleArray firstObject];
//            NSArray * noteAllArray = [noteAllName componentsSeparatedByString:@"+"];
//            
//            NSLog(@"%@",noteAllArray);
//            
//            model.title = [titleArray firstObject];
//            model.noteType = [titleArray objectAtIndex:1];
//            model.nowTime = [titleArray lastObject];
            
            [self.dateEventsDataSource addObject:model];
        }
    }
    
    
    //  刷新界面
    [self.dateForEventsTableView reloadData];
    
    if (self.dateEventsDataSource.count == 0) {
        //  当天没有数据
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.image = [UIImage imageNamed:@"no_Note_2"];
    
        self.dateForEventsTableView.backgroundView = imageView;
    }else {
        self.dateForEventsTableView.backgroundView = nil;
    }
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    //   显示事件的圆点
    return [self.datesWithEvent containsObject:[calendar stringFromDate:date format:@"yyyy-MM-dd"]];
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
