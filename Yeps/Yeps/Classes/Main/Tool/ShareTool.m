//
//  ShareTool.m
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ShareTool.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"

@implementation ShareTool

+ (void)shareWithType:(SSDKPlatformType)type parameters:(NSMutableDictionary *)parameters success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    [ShareSDK share:type parameters:parameters onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *e) {
        if (e || state == SSDKResponseStateFail) {
            if (error) {
                error();
            }
        }else if (state == SSDKResponseStateSuccess) {
            if (success) {
                success();
            }
        } else if(state == SSDKResponseStateCancel) {
            if (cancel) {
                cancel();
            }
        }
    }];
}

+ (void)shareToWeiBo:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    text = [NSString stringWithFormat:@"%@ -- %@ %@", title, text, url];
    [parameters SSDKSetupShareParamsByText:text images:image url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAuto
     ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [self shareWithType:SSDKPlatformTypeSinaWeibo parameters:parameters success:success error:error cancel:cancel];
}

+ (void)shareToWeChat:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    if (![self canShareToWeChat]) {
        [SVProgressHUD showErrorWithStatus:@"未安装微信或微信版本过低" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKSetupWeChatParamsByText:text title:title url:[NSURL URLWithString:url] thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    [self shareWithType:SSDKPlatformSubTypeWechatSession parameters:parameters success:success error:error cancel:cancel];
}

+ (void)shareToWeChatTimeline:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    if (![self canShareToWeChat]) {
        [SVProgressHUD showErrorWithStatus:@"未安装微信或微信版本过低" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    text = [NSString stringWithFormat:@"%@ -- %@", title, text];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKSetupWeChatParamsByText:text title:text url:[NSURL URLWithString:url] thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    [self shareWithType:SSDKPlatformSubTypeWechatTimeline parameters:parameters success:success error:error cancel:cancel];
}

+ (void)shareToQQ:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    if (![self canShareToQQ]) {
        [SVProgressHUD showErrorWithStatus:@"未安装QQ或QQ版本过低" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:url] thumbImage:image image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    [self shareWithType:SSDKPlatformSubTypeQQFriend parameters:parameters success:success error:error cancel:cancel];
}

+ (void)shareToQzone:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel{
    if (![self canShareToQQ]) {
        [SVProgressHUD showErrorWithStatus:@"未安装QQ或QQ版本过低" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters SSDKSetupQQParamsByText:text title:title url:[NSURL URLWithString:url] thumbImage:image image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    [self shareWithType:SSDKPlatformSubTypeQZone parameters:parameters success:success error:error cancel:cancel];
}

+ (BOOL)canShareToQQ {
    return [QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi];
}

+ (BOOL)canShareToWeChat {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}


@end
