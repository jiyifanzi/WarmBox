//
//  JYPlayerView.h
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPlayerView : UIView

@property (nonatomic, strong) NSString * url;

- (instancetype)initWithFrame:(CGRect)frame
                       andURL:(NSString *)url;

@end
