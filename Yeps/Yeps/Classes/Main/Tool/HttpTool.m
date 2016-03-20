//
//  HttpTool.m
//  百思不得姐
//
//  Created by weimi on 16/2/20.
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

+ (void)GET:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *))progress
     success:(void (^)(id))success
    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr GET:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        @try {
            if (success) {
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
