//
//  ShareConfig.h
//  constellation
//
//  Created by 徐方豪 on 16/7/4.
//  Copyright © 2016年 JACK_row. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface ShareConfig : NSObject

+(void)shareConfig;


+(instancetype)CNshareHander;


//  图片的分享
- (void)shareToPlatformWithContent:(NSString*)content
                             Image:(UIImage*)image
                    ViewController:(UIViewController*)controller;

//  纯文本分享
- (void)shareToPlatformWithTitle:(NSString *)title
                      andContent:(NSString *)content
                  ViewController:(UIViewController*)controller;
//  图片文字分享
- (void)shareToPlatformWithTitle:(NSString *)title
                      andContent:(NSString *)content
                        andImage:(UIImage *)image
                  ViewController:(UIViewController*)controller;
//  图片文字URL分享
- (void)shareToPlatformWithContent:(NSString*)content
                             Image:(UIImage*)image
                               url:(NSString*)url
                    ViewController:(UIViewController*)controller;


@end
