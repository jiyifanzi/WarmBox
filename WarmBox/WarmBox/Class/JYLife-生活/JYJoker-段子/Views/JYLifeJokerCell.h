//
//  JYLifeJokerCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLifeJokerModel.h"



@interface JYLifeJokerCell : UITableViewCell

@property (nonatomic, strong) JYLifeJokerModel * model;

@property (nonatomic, weak) id delegate;

@end
