//
//  BSSDK.h
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YepsSDK : NSObject

+ (void)updateStatusCount:(NSDictionary *)statusCountDict status_id:(NSInteger)status_id;

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

// 发布一条Status
//title: "",
//content: "",
//image_list: "[]",
//type: "类型 0:微交流(讨论) 1:微评选(投票) 2:随手拍 3:一起玩 4:发现 5:二手",
//vote: {
//vote_option: "[]选项列表[选项1, 选项二]",
//end_time: "结束时间(0:6小时后, 1:12小时后, 2:1天后, 3:3天后, 4:7天后)"
//}
+ (void)publishStatus:(NSString *)title content:(NSString *)content image_list:(NSArray *)image_list type:(NSInteger)type vote:(NSDictionary *)vote success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure ;

//发布一条评论
//content: "",
//comment_sha1: "可选,如果回复别人的评论则需要",
//status_sha1: "status_sha1"
+ (void)publishComment:(NSString *)content comment_sha1:(NSString *)comment_sha1 status_sha1:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure ;

//点赞/取消点赞
+ (void)clickLike:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//分享成功
+ (void)shareSuccess:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;
@end
