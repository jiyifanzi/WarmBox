//
//  JYNewsCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//


#import <UIKit/UIKit.h>


#import "JYLifeVideoModel.h"

@interface JYNewsCell : UITableViewCell

@property (nonatomic, strong) JYNewsModel * model;
@property (nonatomic, strong) JYLifeVideoModel * lifeModel;


@end
