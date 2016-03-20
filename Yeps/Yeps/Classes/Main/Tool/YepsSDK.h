//
//  BSSDK.h
//  百思不得姐
//
//  Created by weimi on 16/2/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YepsSDK : NSObject

//获取系统标签
+ (void)tagList:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//搜索学校
+ (void)searchUniversity:(NSString *)key success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取七牛token
+ (void)qiniuTokenWithFileName:(NSString *)fileName success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//检查手机号是否被注册
+ (void)checkPhoneExist:(NSString *)phone success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//注册
+ (void)registerWithPhone:(NSString *)phone nick:(NSString *)nick pwd:(NSString *)pwd photo:(NSString *)photo sex:(NSUInteger)sex tagList:(NSArray *)tagList university:(NSString *)university success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取热门学校列表
+ (void)activeUniversityList:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//登录
+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//切换活动学校
+ (void)switchActiveUniversity:(NSString *)university success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取新的Status
+ (void)getNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取旧的Status
+ (void)getOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取关注的好友新的Status
+ (void)getFollowNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取关注的好友旧的Status
+ (void)getFollowOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取评论
+ (void)getOldComment:(NSInteger)max_id status_sha1:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

@end
