//
//  JYWeatherNewHourCell.m
//  WarmBox
//
//  Created by JiYi on 16/7/23.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherNewHourCell.h"

#import "JYWeatherNewHourEverCell.h"

#import "WeatherHourDrawView.h"

@interface JYWeatherNewHourCell () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

//  本界面的CollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *hourCollectionView;

//  本界面的数据源
@property (nonatomic, strong) NSMutableArray * dailyDataSource;

@property (nonatomic, strong) UIScrollView * drawScrollView;

@end

@implementation JYWeatherNewHourCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - 懒加载
- (NSMutableArray *)dailyDataSource {
    if (!_dailyDataSource) {
        _dailyDataSource = [NSMutableArray array];
    }
    return _dailyDataSource;
}

#pragma mark - 创建界面
- (void)creatUI {

    //  注册cell
    [_hourCollectionView registerNib:[UINib nibWithNibName:@"JYWeatherNewHourEverCell" bundle:nil] forCellWithReuseIdentifier:@"everDayCell"];
    _hourCollectionView.delegate = self;
    _hourCollectionView.dataSource = self;
}

- (void)setModelArray:(NSArray *)modelArray {
    
    [self creatUI];
    
    
    [self.dailyDataSource removeAllObjects];
    [self.dailyDataSource addObjectsFromArray:modelArray];
    
    //  重吊方法，画线
//    [self setNeedsDisplay];
    //  创建一个和内容视图相同大小的ScrolView
    [_drawScrollView removeFromSuperview];
    if (modelArray.count == 0) {
        
    }else {
        JYWeatherHourlyModel * model = modelArray.firstObject;
        
        NSInteger pointStart = (60 - model.tmp.floatValue) * 2.8f + 8;
        NSInteger pointX = self.frame.size.width / self.dailyDataSource.count / 2 - 2;
        
        _drawScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_hourCollectionView.frame.origin.x, _hourCollectionView.frame.origin.y, 0, 0)];
        _drawScrollView.contentSize = CGSizeMake((self.frame.size.width - 20) / 4 * modelArray.count, self.frame.size.height - 10);
        WeatherHourDrawView * drawView = [[WeatherHourDrawView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width - 20) / 4 * modelArray.count, self.frame.size.height - 10)];
        drawView.dataSource = self.dailyDataSource;
        drawView.backgroundColor = [UIColor clearColor];
        _drawScrollView.backgroundColor = [UIColor clearColor];
        _drawScrollView.delegate = self;
        _drawScrollView.tag = 100;
        [_drawScrollView addSubview:drawView];
        
        [UIView animateWithDuration:0.4 animations:^{
            _drawScrollView.frame = _hourCollectionView.frame;
        }];

    }
    
    
    [self.contentView addSubview:_drawScrollView];

    [self.contentView sendSubviewToBack:_drawScrollView];
    
    [self.hourCollectionView reloadData];
}



#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dailyDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    JYWeatherNewHourEverCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"everDayCell" forIndexPath:indexPath];
    JYWeatherHourlyModel* model = self.dailyDataSource[indexPath.row];
    model.row = indexPath.row;
    cell.model = model;
    //  根据cell的店来画线
    return cell;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSLog(@"%.1f %.1f",(self.frame.size.width - 20) / 4,  self.frame.size.height - 10);
    
    return CGSizeMake((self.frame.size.width - 20) / 4, self.frame.size.height - 10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}


//  UIScrollView的代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        //
        _hourCollectionView.contentOffset = scrollView.contentOffset;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
