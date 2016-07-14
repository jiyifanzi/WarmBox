//
//  JYWebMenuView.h
//  WarmBox
//
//  Created by JiYi on 16/7/13.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JYWebMenuTypeVertical,
    JYWebMenuTypeHorizontal
} JYWebMenuType;

@interface JYWebMenuView : UIView

@property (nonatomic, assign) JYWebMenuType menyType;

+ (instancetype)WebMenu;

@end
