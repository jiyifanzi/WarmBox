//
//  JYLifeVideoCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/7.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLifeVideoModel.h"

@protocol JYLifeVideoCellDelegate <NSObject>

- (void)playTheVideoWithURL:(NSString *)url
                   andTitle:(NSString *)title;

@end

@interface JYLifeVideoCell : UITableViewCell

@property (nonatomic, strong) JYLifeVideoModel * model;
@property (nonatomic, weak)id<JYLifeVideoCellDelegate>delegate;

@end
