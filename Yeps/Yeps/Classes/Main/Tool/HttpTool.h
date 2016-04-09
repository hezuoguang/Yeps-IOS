//
//  HttpTool.h
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpTool : NSObject

+ (void)POST:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *postProgress))progress
     success:(void (^)(id data))success
     failure:(void (^)(NSError *error))failure;

+ (void)GET:(NSString *)url parameters:(id)parameters progress:(void (^)(NSProgress *getProgress))progress
     success:(void (^)(id data))success
     failure:(void (^)(NSError *error))failure;
@end
