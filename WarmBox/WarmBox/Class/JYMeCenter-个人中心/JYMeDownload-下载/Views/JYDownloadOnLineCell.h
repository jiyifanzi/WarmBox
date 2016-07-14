//
//  JYDownloadOnLineCell.h
//  WarmBox
//
//  Created by qianfeng on 16/7/11.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYDownloadOnLineDelegate <NSObject>

- (void)removeOnlineandGetDataDBWithModel:(JYDownloadModel *)model;

@end


@interface JYDownloadOnLineCell : UITableViewCell

@property (nonatomic, copy) NSString * url;

@property (weak, nonatomic) IBOutlet UILabel *fileName;

@property (nonatomic, strong) JYDownloadModel * model;

@property (nonatomic, weak)id<JYDownloadOnLineDelegate>delegate;

@end
