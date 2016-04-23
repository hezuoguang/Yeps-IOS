//
//  HttpTool.m
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>
@implementation HttpTool


+ (void)POST:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *))progress
     success:(void (^)(id))success
     failure:(void (^)(NSError *))failure{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        @try {
            if (success) {
                if ([responseObject[@"ret"] isEqualToString:@"1114"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kACCESSTOKENERRORNOTIFI object:nil];
                } else {
                    success(responseObject);
                }
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @try {
            if (failure) {
                failure(error);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
}

+ (void)GET:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *))progress
     success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        @try {
            if ([responseObject[@"ret"] isEqualToString:@"1114"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kACCESSTOKENERRORNOTIFI object:nil];
            } else {
                success(responseObject);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @try {
            if (failure) {
                failure(error);
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    
}

@end
