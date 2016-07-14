//
//  JYWebViewController.h
//  WarmBox
//
//  Created by qianfeng on 16/7/6.
//  Copyright (c) 2016年 JiYi. All rights reserved.
//

#import "JYBaseViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

//  定义一个协议
@protocol myProtocol <JSExport>
- (void)imageTouch;
@end

@interface JYWebViewController : JYBaseViewController

@property (nonatomic, strong) NSString * url;

@property (nonatomic, strong) NSString * url3G;

@end
