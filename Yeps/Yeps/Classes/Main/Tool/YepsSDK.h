//
//  BSSDK.h
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YepsSDK : NSObject

+ (CGFloat)cacheSize;
+ (void)clearCache;
+ (void)clearDataBase;

+ (void)updateStatusCount:(NSDictionary *)statusCountDict status_id:(NSInteger)status_id;
+ (void)updateStatusVote:(NSDictionary *)voteDict status_id:(NSInteger)status_id;
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

//退出登录
+ (void)logout;

//切换活动学校
+ (void)switchActiveUniversity:(NSString *)university success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取新的Status
+ (void)getNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取旧的Status
+ (void)getOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取Status详情
+ (void)getStatusDetail:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取Status 评论数 点赞数...
+ (void)getStatusCount:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取关注的好友新的Status
+ (void)getFollowNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取关注的好友旧的Status
+ (void)getFollowOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取某个用户新的Status
+ (void)getUserNewStatus:(NSInteger)since_id user_sha1:(NSString *)user_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取某个用户旧的Status
+ (void)getUserOldStatus:(NSInteger)max_id user_sha1:(NSString *)user_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

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

//参与投票
+ (void)joinVote:(NSInteger)select content:(NSString *)content vote_sha1:(NSString *)vote_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//修改密码
+ (void)updatePassword:(NSString *)oldPwd pwd:(NSString *)pwd success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//修改头像
+ (void)updatePhoto:(UIImage *)image success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//修改个人页面背景图片
+ (void)updateProfileBackImage:(UIImage *)image success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//修改个人资料
+ (void)updateInfo:(NSString *)nick email:(NSString *)email birthday:(NSString *)birthday sex:(NSInteger)sex success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//更新用户标签
+ (void)updateTagList:(NSArray *)tag_list success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//更新个性签名
+ (void)updateIntro:(NSString *)intro success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取自己的信息
+ (void)getUserInfo:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取其他用户的信息
+ (void)getOtherUserInfo:(NSString *)user_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取用户所有 status 图片
+ (void)getUserStatusImages:(NSString *)user_sha1 max_id:(NSInteger)max_id success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//关注
+ (void)follow:(NSString *)user_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//取消关注
+ (void)removeFollow:(NSString *)user_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取系统推荐列表
+ (void)recommendUserList:(NSInteger)max_id count:(NSInteger)count success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//匹配操作
+ (void)matchOption:(NSString *)user_sha1 is_match:(NSInteger)is_match success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//搜索用户
+ (void)searchUsers:(NSString *)key max_id:(NSInteger)max_id count:(NSInteger)count success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取关注/粉丝列表
+ (void)aboutFollowUserList:(NSString *)user_sha1 max_id:(NSInteger)max_id count:(NSInteger)count followMe:(BOOL)followMe success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

//获取消息列表
+ (void)getMessageList:(NSInteger)max_id count:(NSInteger)count success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure;

@end
