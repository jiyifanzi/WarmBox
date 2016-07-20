//
//  JYUser.h
//  WarmBox
//
//  Created by JiYi on 16/7/19.
//  Copyright © 2016年 JiYi. All rights reserved.
//

#import "AVUser.h"

@interface JYUser : AVUser <AVSubclassing>

//  增加用户头像
@property (retain) NSString * headUrl;

//  增加用户笔记本的属性
@property (retain) NSString * noteArrayUrl;

@end
