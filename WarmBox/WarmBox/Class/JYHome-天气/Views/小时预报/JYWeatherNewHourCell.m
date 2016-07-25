//
//  JYWeatherNewHourCell.m
//  WarmBox
//
//  Created by JiYi on 16/7/23.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYWeatherNewHourCell.h"

#import "JYWeatherNewHourEverCell.h"

@interface JYWeatherNewHourCell () <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

//  本界面的CollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *hourCollectionView;

//  本界面的数据源
@property (nonatomic, strong) NSMutableArray * dailyDataSource;

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
    
    [self setNeedsDisplay];
    
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




//  系统绘图
- (void)drawRect:(CGRect)rect {
    //    [self.iconImage drawAtPoint:CGPointMake(100, 100)];
    
    //  获取对应的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //  画线
    [self drawLine:contextRef];
}

#pragma mark - 画线
- (void) drawLine:(CGContextRef)contextRef {
    //  设置画线的路径
    //  起点 为中心点的位置
    
    if (self.dailyDataSource.count == 0) {
        return;
    }
    
    //  第一个Cell的值
    JYWeatherHourlyModel* model = self.dailyDataSource[0];
    
    
    NSInteger pointStart = (60 - model.tmp.floatValue) * 2.8f + 7;
    NSInteger pointX = self.hourCollectionView.frame.size.width / self.dailyDataSource.count / 2 - 2;
    CGContextMoveToPoint(contextRef, pointX, pointStart);
    NSLog(@"%.ld %ld",pointX, pointStart);
    
    //  取到下一个店
    //  终点
    
    for (int i = 1; i < self.dailyDataSource.count; i ++) {
        JYWeatherHourlyModel * tempModel = self.dailyDataSource[i];

        
        NSInteger pointNextStart = (60 - tempModel.tmp.floatValue) * 2.8f + 7;
        CGContextAddLineToPoint(contextRef, (pointX * 2 + 2) * i, pointNextStart);
        NSLog(@"%.ld %ld",pointX * 2 * i , pointNextStart);

    }
    
    
    //  相关属性的设置
    //  线宽
    CGContextSetLineWidth(contextRef, 2);
    //  颜色
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    //  风格，头尾的处理
    CGContextSetLineCap(contextRef, kCGLineCapRound);// 头尾圆角
    
    //  画虚线
//    CGFloat lengthS[] = {20, 20, 10};
    
    /*
     参数1：作用域 ，传入画线当前的上下文
     参数2：起点的偏移量，起点从多少开始
     参数3：实现部分与虚线部分的分别长度 20，20，10 ，20，20，10
     参数4：实现和虚线部分的循环次数 (count数必须登录lenths数组的长度)
     
     */

//    CGContextSetLineDash(contextRef, 20, lengthS, 3);
  
    CGContextStrokePath(contextRef);
    
}


@end
