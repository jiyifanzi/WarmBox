//
//  WeatherHourDrawView.m
//  WarmBox
//
//  Created by JiYi on 16/7/25.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "WeatherHourDrawView.h"

@implementation WeatherHourDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    [self setNeedsDisplay];
}


//  系统绘图
- (void)drawRect:(CGRect)rect {
    //  获取对应的上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //  画线
    [self drawLine:contextRef];
}

#pragma mark - 画线
- (void) drawLine:(CGContextRef)contextRef {
    //  设置画线的路径
    //  起点 为中心点的位置
    
    if (self.dataSource.count == 0) {
        return;
    }
    
    //  第一个Cell的值
    JYWeatherHourlyModel* model = self.dataSource[0];
    
    NSInteger pointStart = (60 - model.tmp.floatValue) * 2.8f + 8;
    
    NSInteger pointX = self.frame.size.width / self.dataSource.count / 2 - 2;
    
    NSLog(@"%.ld %ld",pointX, pointStart);
    
    CGContextMoveToPoint(contextRef, pointX, pointStart);
    

    //  取到下一个店
    //  终点@
    pointX = pointX + 3.f;
    for (int i = 1; i < self.dataSource.count; i ++) {
        
        JYWeatherHourlyModel * tempModel = self.dataSource[i];
        NSInteger pointNextStart = (60 - tempModel.tmp.floatValue) * 2.8f + 8;
        NSLog(@"%.ld %ld",(pointX * 2) * (i + 1) - pointX , pointNextStart);
        
        CGContextAddLineToPoint(contextRef, ((pointX * 2) * (i + 1) - pointX), pointNextStart);
    }
    
    //  相关属性的设置
    //  线宽
    CGContextSetLineWidth(contextRef, 2);
    //  颜色
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    //  风格，头尾的处理
    CGContextSetLineCap(contextRef, kCGLineCapButt);// 头尾圆角
    
    CGContextStrokePath(contextRef);
}


@end
