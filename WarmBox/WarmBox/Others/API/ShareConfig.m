//
//  ShareConfig.m
//  constellation
//
//  Created by 徐方豪 on 16/7/4.
//  Copyright © 2016年 JACK_row. All rights reserved.
//

#import "ShareConfig.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

@interface ShareConfig ()<UMSocialUIDelegate>

@end


@implementation ShareConfig

+(instancetype)CNshareHander{
    static dispatch_once_t once;
    static ShareConfig* __single__;
    dispatch_once(&once, ^{
        __single__ = [[ShareConfig alloc] init];
    });
    return __single__;
}

+(void)shareConfig{
    [UMSocialData setAppKey:UMkey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WXkey appSecret:WXsecret url:WXRedict];
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:WXRedict];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaKey secret:SinaSecret RedirectURL:SinaRedict];
}
#pragma mark - 纯文本
- (void)shareToPlatformWithTitle:(NSString *)title andContent:(NSString *)content ViewController:(UIViewController *)controller {
    //  设置样式
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeText;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeText;
    //  QQ
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qzoneData.urlResource.resourceType = UMSocialQQMessageTypeDefault;
    
    //  微博
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    [UMSocialData defaultData].extConfig.sinaData.shareText = content;
    
    NSArray* arr = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
    
    [UMSocialConfig hiddenNotInstallPlatforms:nil];
    [UMSocialSnsService presentSnsIconSheetView:controller appKey:UMkey shareText:content shareImage:nil shareToSnsNames:arr delegate:self];
}
#pragma mark - 纯图片
- (void)shareToPlatformWithContent:(NSString*)content Image:(UIImage*)image ViewController:(UIViewController*)controller{
//    [UMSocialData defaultData].extConfig.title = content;

    /**
     *  设置分享的样式
     */
    //微信
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;

    
    //qq
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.qzoneData.urlResource.resourceType = UMSocialUrlResourceTypeImage;
    
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [content stringByAppendingString:url];
    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType =UMSocialUrlResourceTypeWeb;
    
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    
    NSArray* arr = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
    
    
    [UMSocialConfig hiddenNotInstallPlatforms:nil];
    [UMSocialSnsService presentSnsIconSheetView:controller appKey:UMkey shareText:content shareImage:image shareToSnsNames:arr delegate:self];
}

#pragma mark - url
- (void)shareToPlatformWithContent:(NSString *)content Image:(UIImage *)image url:(NSString *)url ViewController:(UIViewController *)controller {
    //  设置样式
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
    //  QQ
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.qzoneData.urlResource.resourceType = UMSocialQQMessageTypeDefault;
    
    //  微博
    //    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
    //  微博
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeVideo url:url];
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.resourceType =UMSocialUrlResourceTypeWeb;
//    [UMSocialData defaultData].extConfig.sinaData.shareText = content;
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;

    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:url];
    
    //  QQ
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.title = [NSString stringWithFormat:@"%@%@",content, url];
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = content;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    NSArray* arr = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
    
    
    
    [UMSocialConfig hiddenNotInstallPlatforms:nil];
    [UMSocialSnsService presentSnsIconSheetView:controller appKey:UMkey shareText:content shareImage:nil shareToSnsNames:arr delegate:self];
}


-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    switch (response.responseCode) {
        case UMSResponseCodeSuccess:
        {
            [ShareConfig shareWithContent:@"分享成功" AndTitle:@"分享结果"];
        }
            break;
        case UMSResponseCodeCancel:
        {
            [ShareConfig shareWithContent:@"取消分享" AndTitle:@"分享结果"];
        }
            break;
        case UMSResponseCodeFaild:{
            [ShareConfig shareWithContent:@"分享失败" AndTitle:@"分享结果"];
        }
            break;
        default:
            [ShareConfig shareWithContent:@"分享失败" AndTitle:@"分享结果"];
            break;
    }
 
}
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
   //想起来再实现
//    if (platformName == UMShareToSina) {
//        
//        socialData.shareText = @"分享到新浪";
//    }
}
+(void)shareWithContent:(NSString*)content AndTitle:(NSString*)title{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
