//
//  JYScrollView.m
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYScrollView.h"

@interface JYScrollView () <UIScrollViewDelegate>

//  定时器
@property (nonatomic, strong) NSTimer * timer;
//  本界面的scrollView
@property (nonatomic, strong) UIScrollView * scrolleView;
//  本界面的label
@property (nonatomic, strong) UILabel * label;
//  显示页数的pageControl
@property (nonatomic, strong) UIPageControl * pageControl;

//  记录总页数
@property (nonatomic, assign) int imageNum;
//  图片数组
@property (nonatomic, strong) NSArray * imageArray;
//  标题数组
@property (nonatomic, strong) NSArray * titleArray;

@end

@implementation JYScrollView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame imageNum:(int)imageNum {
    if (self = [super initWithFrame:frame]) {
        _imageNum = imageNum;
        //  创建子视图
        [self initSubViews];
    }
    return self;
}

#pragma mark - 创建子数组
- (void)initSubViews {
    _scrolleView = [[UIScrollView alloc] init];
    _scrolleView.pagingEnabled = YES;
    _scrolleView.bounces = NO;
    _scrolleView.clipsToBounds = YES;
    _scrolleView.scrollsToTop = NO;
    //  设置代理
    _scrolleView.delegate = self;
    _scrolleView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrolleView];
    
    
    
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:0.6];
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _imageNum;
    _pageControl.currentPage = 0;
    _pageControl.hidden = YES;
    [self addSubview:_pageControl];

    for (int i = 0; i < _imageNum + 2; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.tag = 1000 + i;
        [_scrolleView addSubview:imageView];
    }
    
    //  开启定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    
    //  ======
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    ////加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    
    [self addGestureRecognizer:singleTap];
}

#pragma mark - 手势
- (void)singleTap:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidClickedAtPage:)]) {
        [self.delegate scrollViewDidClickedAtPage:self.pageControl.currentPage];
    }
}

#pragma mark - show
- (void)showWithImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray {
    if (titleArray) {
        _label.hidden = NO;
    }
    
    _pageControl.hidden = NO;
    
    _imageArray = imageArray;
    _titleArray = titleArray;
    
    for (int i = 0; i < _imageNum + 2; i ++) {
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:1000 + i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        if (i == 0) {
            //第一张图放最后一张图
            [imageView setImageWithURL:[NSURL URLWithString:imageArray.lastObject] placeholderImage:[UIImage imageNamed:@""]];
        }else if(i == _imageNum + 1 ){
            //最后一张图放第一张图
            [imageView setImageWithURL:[NSURL URLWithString:_imageArray.firstObject] placeholderImage:[UIImage imageNamed:@""]];
            
        }else if (i > 0 && i < _imageNum + 1){
            
            [imageView setImageWithURL:[NSURL URLWithString:imageArray[i - 1]] placeholderImage:[UIImage imageNamed:@""]];
        }
    }
    _scrolleView.contentOffset = CGPointMake(Width , 0);
    _pageControl.currentPage = 0;
    
    //给label赋标题
    _label.text = [NSString stringWithFormat:@"%@", _titleArray[_pageControl.currentPage]];
}


#pragma mark - 重新布局
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setSubViewFrame];
    
}

#pragma mark - 设置subViewFrame

-(void)setSubViewFrame{
    
    //label
    CGFloat labelH = 30;
    _label.frame = CGRectMake(0, self.frame.size.height - labelH, Width, labelH);

    //_scrolleView
    _scrolleView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.frame.size.height);
    //内容物的大小
    
    if (_imageNum == 1) {
        _scrolleView.contentSize = CGSizeMake(Width, 0);
    }else{
        _scrolleView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * (_imageNum + 2), self.frame.size.height);
    }
    
    _scrolleView.contentOffset = CGPointMake(Width * ( _pageControl.currentPage + 1), 0);
    
    
    
    for (int i = 0; i < _imageNum + 2; i ++) {
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:1000 + i];
        
        imageView.frame =CGRectMake(i * [[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, self.frame.size.height);
        
    }
    //pageControl
    _pageControl.frame = CGRectMake(Width/2-40, self.frame.size.height - 30, 80, 30);
}

#pragma mark - 定时器事件

-(void)timeRun{
    [UIView animateWithDuration:0.5 animations:^{
        _scrolleView.contentOffset = CGPointMake(_scrolleView.contentOffset.x + Width, 0) ;
    }];
    
    [self changeContenOffestAndCurrentPage:_scrolleView];
    
    //给label赋标题
    _label.text = [NSString stringWithFormat:@"  %@", _titleArray[_pageControl.currentPage]];
    
}

#pragma mark - scroll代理方法

//在第一张和最后一张改变偏移量， 实现轮播
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //改变偏移量 和 currentpage
    [self changeContenOffestAndCurrentPage:scrollView];
    
    
    _label.text = _label.text = [NSString stringWithFormat:@"  %@",  _titleArray[_pageControl.currentPage]];
    ;
    
    //开启定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
    
}

//在即将开始拖拽时关闭计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer invalidate];
}


#pragma mark - 改变偏移量 和 currentpage
-(void)changeContenOffestAndCurrentPage:(UIScrollView *) scrollView{
    //如果第一张或者最后一张 改变偏移量
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(Width * _imageNum, 0);
    }else if(scrollView.contentOffset.x == Width * (_imageNum + 1)){
        scrollView.contentOffset = CGPointMake(Width, 0);
    }
    
    //设置pagecontrol的页数
    _pageControl.currentPage = _scrolleView.contentOffset.x / Width - 1;
}


@end
