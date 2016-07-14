//
//  JYWeatherDailyCell.m
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherDailyCell.h"

#import "JYWeatherEverDayCell.h"

@interface JYWeatherDailyCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

//  本节目的collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *dailyCollectionView;
//  本界面的数据源
@property (nonatomic, strong) NSMutableArray * dailyDataSource;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation JYWeatherDailyCell

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

- (void)setModelArray:(NSArray *)modelArray {
    
    _modelArray = modelArray;
    
    if (modelArray.count == 0) {
        _bgImageView.alpha = 0;
    }else {
        _bgImageView.alpha = 1;
    }
    
    [self.dailyDataSource removeAllObjects];
    
    //  根据数组来创建界面
    [self.dailyDataSource addObjectsFromArray:modelArray];
    
    [self creatUI];
    
    [self.dailyCollectionView reloadData];
}


#pragma mark - 创建界面
- (void)creatUI {
    
    //  注册cell
    [_dailyCollectionView registerNib:[UINib nibWithNibName:@"JYWeatherEverDayCell" bundle:nil] forCellWithReuseIdentifier:@"everDayCell"];
    _dailyCollectionView.delegate = self;
    _dailyCollectionView.dataSource = self;
}

#pragma mark - collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dailyDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYWeatherEverDayCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"everDayCell" forIndexPath:indexPath];
    cell.model = self.dailyDataSource[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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

//  设置大小

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
