//
//  JYSkinViewController.m
//  WarmBox
//
//  Created by qianfeng on 16/7/9.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//
//  ========皮肤设置界面


#import "JYSkinViewController.h"

#import "JYSkinCell.h"


@interface JYSkinViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//  用户头像
@property (nonatomic, strong) UIButton * userIcon;
//  用户头像的背景 （以每日推荐壁纸来做）
@property (nonatomic, strong) UIImageView * iconBackImage;
//  模糊图层
@property (nonatomic, strong) UIImageView * blueBackImage;
//  每日一句话
@property (nonatomic, strong) UILabel * oneWorldLabel;

@property (nonatomic, strong) UIView * iconView;

//  展示背景皮肤的CollectionView;
@property (nonatomic, strong) UICollectionView * skinCollectionView;
//  数据源
@property (nonatomic, strong) NSMutableArray * skinDataSource;
@property (nonatomic, strong) NSMutableArray * filePathSource;
//  题目数据源
@property (nonatomic, strong) NSMutableArray * titleDataSource;

@end


@implementation JYSkinViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tou"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"tou"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatUserUI];
    
    [self creatUI];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)skinDataSource {
    if (!_skinDataSource) {
        _skinDataSource = [NSMutableArray array];

        //  添加图片
        for (int i = 1; i <= 6; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_skinDataSource addObject:image];
            [_titleDataSource addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d.jpg",i] ofType:nil]];
            
        }
    }
    return _skinDataSource;
}
- (NSMutableArray *)titleDataSource {
    if (!_titleDataSource) {
        _titleDataSource = [NSMutableArray array];
        //  添加图片
        for (int i = 1; i <= 6; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            NSData *dataObj = UIImageJPEGRepresentation(image, 1.0);
            [_titleDataSource addObject:dataObj];
            
        }
    }
    return _titleDataSource;
}
- (NSMutableArray *)filePathSource {
    if (!_filePathSource) {
        _filePathSource = [NSMutableArray array];
        //  添加图片
        for (int i = 1; i <= 6; i++) {
            NSString * path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d.jpg",i] ofType:nil];
            [_filePathSource addObject:path];
        }
    }
    return _filePathSource;
}

#pragma mark - 创建整体视图
- (void)creatUI {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    _skinCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:_skinCollectionView];
    //  约束
    [_skinCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
    }];
    //  设置相关的属性
    _skinCollectionView.delegate  = self;
    _skinCollectionView.dataSource = self;
    _skinCollectionView.backgroundColor = [UIColor clearColor];
    
    //  注册cell
    [_skinCollectionView registerNib:[UINib nibWithNibName:@"JYSkinCell" bundle:nil] forCellWithReuseIdentifier:@"skinCell"];
    
    UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _skinCollectionView.frame.size.height + _skinCollectionView.frame.origin.y, Width, 60)];
    [self.view addSubview:btnView];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_skinCollectionView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    //  创建从相册选择 从相机选择两个按钮
    UIButton * buttonFromPhotos = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addSubview:buttonFromPhotos];
    [buttonFromPhotos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnView.mas_left).offset(0);
        make.top.equalTo(btnView.mas_top).offset(5);
        make.bottom.equalTo(btnView.mas_bottom).offset(-5);
        
    }];
    
    //  返回按钮
    buttonFromPhotos.backgroundColor = [UIColor clearColor];
    [buttonFromPhotos setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFromPhotos addTarget:self action:@selector(backToView) forControlEvents:UIControlEventTouchUpInside];
    [buttonFromPhotos setTitle:@"  返回  " forState:UIControlStateNormal];
    buttonFromPhotos.clipsToBounds = YES;
//    buttonFromPhotos.layer.cornerRadius = 15;
    
    
    //  从相册选择的按钮
    UIButton * buttonFromCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addSubview:buttonFromCamera];
    [buttonFromCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btnView.mas_right).offset(0);
        make.top.equalTo(btnView.mas_top).offset(5);
        make.bottom.equalTo(btnView.mas_bottom).offset(-5);
    }];
    buttonFromCamera.backgroundColor = [UIColor clearColor];
    [buttonFromCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonFromCamera addTarget:self action:@selector(selectorPictureFromPhotos) forControlEvents:UIControlEventTouchUpInside];
    [buttonFromCamera setTitle:@"  相册  " forState:UIControlStateNormal];
    buttonFromCamera.clipsToBounds = YES;
//    buttonFromCamera.layer.cornerRadius = 15;

}
#pragma mark - 返回
- (void)backToView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 从相册选择图片
- (void)selectorPictureFromPhotos {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 从相及选择图片
- (void)selectorPictureFromCamera {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
      [self presentViewController:picker animated:YES completion:nil];
}

/*
 
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
 //  将完成归档的二进制数据存储到本地 存储格式是字典 后缀为plist
 [data writeToFile:filepath atomically:NO];
 
 [JYWeatherTools showMessageWithAlertView:@"添加成功"];
 }
 */

#pragma mark - 获取相册代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    //  判断图片的来源
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //  拿到选中的图片
        UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *dataObj = UIImageJPEGRepresentation(image, 0.1);
        [self dismissViewControllerAnimated:YES completion:^{
            //  选择了图片，就设置当前的背景
            //  存入数据库
            [[NSUserDefaults standardUserDefaults] setObject:dataObj forKey:@"SkinBGImage"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //  发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changBG" object:nil];
            
            /*
             NSString * filepath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/BGIMAGE.plist"]];
             
             [data writeToFile:filepath atomically:NO];
             
             [data writeToFile:filepath atomically:NO];
             */
            
        }];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 创建顶部视图
- (void)creatUserUI {
    //  定义用户界面的顶部视图
    _iconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height/4)];
    [self.view addSubview:_iconView];
    
    //  背景
    _iconBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height/4)];
    _iconBackImage.clipsToBounds = YES;
    _iconBackImage.contentMode = UIViewContentModeScaleAspectFill;
    [_iconView addSubview:_iconBackImage];
    
    _blueBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height/4)];
    _blueBackImage.clipsToBounds = YES;
    _blueBackImage.contentMode = UIViewContentModeScaleAspectFill;
    [_blueBackImage setImageToBlur:[UIImage imageNamed:@"ment"] completionBlock:nil];
    _blueBackImage.alpha = 0.5;
    
    [_iconView addSubview:_iconBackImage];
    
  
    [self.requestManager GET:[NSString stringWithFormat:WB_DayImage,[JYWeatherTools getNowDataWithFormate:@"yyyy-MM-dd"]] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //  解析每日图片的东西
        NSDictionary * tempDick = responseObject[@"data"];
        NSString * url = tempDick[@"largeImg"];
        
        [_iconBackImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"2.jpg"]];
//        [_iconBackImage sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            ;
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
        //  添加一句话
        _oneWorldLabel.text = tempDick[@"s"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
//    
//        
//    //  创建用户头像
//    _userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_userIcon setBackgroundImage:[UIImage imageNamed:@"yunduo.jpg"] forState:UIControlStateNormal];
//    _userIcon.layer.masksToBounds = YES;
//    _userIcon.layer.cornerRadius = (_iconView.frame.size.height - 80)/2;
//    [_iconView addSubview:_userIcon];
//    //  添加约束
//    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_iconView.mas_top).offset(40);
////        make.bottom.equalTo(_iconView.mas_bottom).offset(-40);
//        make.left.equalTo(_iconView.mas_left).offset(5);
//        make.size.mas_equalTo(CGSizeMake(_iconView.frame.size.height - 80, _iconView.frame.size.height - 80));
//    }];
    
    //  一句话
    _oneWorldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 30)];
    _oneWorldLabel.textColor = [UIColor whiteColor];
    _oneWorldLabel.font = [UIFont boldSystemFontOfSize:16.0];
    _oneWorldLabel.text = @"加载中...";
    _oneWorldLabel.numberOfLines = 0;
    
    [_iconView addSubview:_oneWorldLabel];
    [_oneWorldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_userIcon.mas_bottom).offset(2);
        make.bottom.equalTo(_iconView.mas_bottom).offset(-2);
        make.left.equalTo(_iconView.mas_left).offset(5);
        make.right.equalTo(_iconView.mas_right).offset(-2);
    }];
}

#pragma mark - UICollectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.skinDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYSkinCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"skinCell" forIndexPath:indexPath];
    cell.backImageView.image = self.skinDataSource[indexPath.row];
//    cell.titleLabel.text = @"测试";
    cell.clipsToBounds = YES;
//    cell.layer.cornerRadius = 15;
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage * image = self.skinDataSource[indexPath.row];
    
    //  每行显示3个图片
//    CGFloat cellW = (Width - 4 * 10)/3;
    CGFloat cellW = (Width - 10)/3;
    //  保持宽高不变
    CGFloat cellH = image.size.height / image.size.width * cellW;
    
    return CGSizeMake(cellW, cellH);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIImage * image = self.skinDataSource[indexPath.row];
    
    NSData *dataObj = UIImageJPEGRepresentation(image, 0.1);
    //  选择了图片，就设置当前的背景
    //  存入数据库
    [[NSUserDefaults standardUserDefaults] setObject:dataObj forKey:@"SkinBGImage"];
        
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    //  发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changBG" object:nil];
}

#pragma mark - 改变当前的壁纸
- (void)changeBG {
    //  1.获取单例对象
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    //  2.读取数据
    NSData * data = [user objectForKey:@"SkinBGImage"];
    
    _iconBackImage.image  = [UIImage imageWithData:data];
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
