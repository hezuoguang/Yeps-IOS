//
//  UploadImageTool.m
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UploadImageTool.h"
#import <QiniuSDK.h>
#import "NSString+Extension.h"
const NSString *qiniuHost = @"http://7xrlo2.com1.z0.glb.clouddn.com";
@implementation UploadImageTool

+ (instancetype)sharedInstance {
    static UploadImageTool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[UploadImageTool alloc] init];
    });
    return _sharedInstance;
}

+ (void)getQiniuToken:(NSString *)fileName success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure; {
    
    [YepsSDK qiniuTokenWithFileName:fileName success:success error:error failure:failure];
}

+ (void)uploadimage:(UIImage *)image success:(void (^)(NSString *url))success failure:(void (^)())failure{
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [[NSString stringWithFormat:@"%lf%d", time, arc4random()] md5String];
    [self getQiniuToken:fileName success:^(id data) {
        NSString *token = data[@"token"];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
        [upManager putData:imageData key:fileName token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if(info.statusCode == 200 && resp) {
                if (success) {
                    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", qiniuHost, resp[@"key"]];
                    success(imageUrl);
                }
            } else {
                if (failure) {
                    failure();
                }
            }
        } option:nil];
    } error:^(id data) {
        if (failure) {
            failure();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)uploadimages:(NSArray *)images success:(void (^)(NSArray *urlArray))success failure:(void (^)())failure {
    UploadImageTool *tool = [UploadImageTool sharedInstance];
    __weak typeof(tool) weakTool = tool;
    if (tool.failureBlock || tool.successBlock) {
        failure();
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    __block NSUInteger index = 0;
    tool.failureBlock = ^() {
        failure();
        return;
    };
    tool.successBlock  = ^(NSString *url) {
        [array addObject:url];
        index++;
        if ([array count] == [images count]) {
            success([array copy]);
            return;
        }
        else {
            [self uploadimage:images[index] success:weakTool.successBlock failure:weakTool.failureBlock];
        }
    };
    [self uploadimage:images[index] success:weakTool.successBlock failure:weakTool.failureBlock];
    
}

@end
