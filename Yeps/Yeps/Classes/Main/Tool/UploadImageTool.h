//
//  UploadImageTool.h
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadImageTool : NSObject

@property (nonatomic, copy) void (^successBlock)(NSString *);
@property (nonatomic, copy)  void (^failureBlock)();

+ (instancetype)sharedInstance;
+ (void)uploadimage:(UIImage *)image success:(void (^)(NSString *url))success failure:(void (^)())failure;
+ (void)uploadimages:(NSArray *)images success:(void (^)(NSArray *urlArray))success failure:(void (^)())failure;
@end
