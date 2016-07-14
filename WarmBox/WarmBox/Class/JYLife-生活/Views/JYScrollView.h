//
//  JYScrollView.h
//  WarmBox
//
//  Created by qianfeng on 16/7/5.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JYScrollViewDelegate <NSObject>

- (void)scrollViewDidClickedAtPage:(NSInteger)page;

@end

@interface JYScrollView : UIView

@property (nonatomic, weak)id<JYScrollViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     imageNum:(int)imageNum;


//  用于展示数据
//  imageArray为网络url的地址数组
- (void) showWithImageArray:(NSArray *)imageArray
                 titleArray:(NSArray *)titleArray;

@end
