//
//  JYMeViewController.h
//  WarmBox
//
//  Created by qianfeng on 16/6/30.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"

@protocol JYMeViewDelegate <NSObject>

- (void)pushToSearchController;

@end

@interface JYMeViewController : JYBaseViewController

@property (nonatomic, strong) id<JYMeViewDelegate> delegate;

@end
