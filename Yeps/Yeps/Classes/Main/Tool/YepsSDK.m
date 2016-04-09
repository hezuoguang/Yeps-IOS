//
//  BSSDK.m
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "YepsSDK.h"
#import "HttpTool.h"
#import "NSString+Extension.h"
#import <FMDB.h>
#import "UserTool.h"
#import "UploadImageTool.h"
#define HOST  @"http://192.168.0.101:8000/yeps/api/"
#define DBPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Yeps.sqlite"]

static FMDatabase *_db;
@implementation YepsSDK

+ (FMDatabase *)db {
    if (_db == nil) {
        _db = [[FMDatabase alloc] initWithPath:DBPath];
        NSString *sql1 = @"CREATE TABLE IF NOT EXISTS university(`university` TEXT NOT NULL,PRIMARY KEY(university));";
        //pk --- user_sha1 + status_id
        NSString *sql2 = @"CREATE TABLE IF NOT EXISTS status(`pk` TEXT NOT NULL, `status_id` INTEGER NOT NULL, `type` INTEGER NOT NULL,`status` TEXT NOT NULL,`user_sha1` TEXT NOT NULL,`university` TEXT NOT NULL, is_follow INTEGER NOT NULL,PRIMARY KEY(pk));";
        NSString *sql3 = @"CREATE TABLE IF NOT EXISTS comment(`comment_id` INTEGER NOT NULL,`comment` TEXT NOT NULL,`status_sha1` TEXT NOT NULL,PRIMARY KEY(comment_id));";
        [_db open];
        [_db executeUpdate:sql1];
        [_db executeUpdate:sql2];
        [_db executeUpdate:sql3];
    }
    return _db;
}

+ (void)updateStatusCount:(NSDictionary *)statusCountDict status_id:(NSInteger)status_id{
    NSInteger likeCount = [statusCountDict[@"like_count"] integerValue];
    NSInteger shareCount = [statusCountDict[@"share_count"] integerValue];
    NSInteger commentConut = [statusCountDict[@"comment_conut"] integerValue];
    BOOL me_is_like = [statusCountDict[@"me_is_like"] boolValue];
    NSString *sql = [NSString stringWithFormat:@"select status from status where status_id = %ld",(long)status_id];
    FMResultSet *results = [[self db] executeQuery:sql];
    if (results.next) {
        NSData *data = [results dataForColumnIndex:0];
        NSMutableDictionary *status = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        status[@"like_count"] = @(likeCount);
        status[@"share_count"] = @(shareCount);
        status[@"comment_conut"] = @(commentConut);
        status[@"me_is_like"] = @(me_is_like);
        NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
        [[self db] executeUpdate:@"update status set status = ? where status_id = ?",statusData, @(status_id)];
    }
}

//获取系统标签
+ (void)tagList:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"system_user_tag_list";
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//搜索学校
+ (void)searchUniversity:(NSString *)key success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    NSString *sql = @"select count(*) from university";
    FMResultSet *result = [[self db] executeQuery:sql];
    NSInteger count = 0;
    if (result.next) {
        count = [result intForColumnIndex:0];
    }
    if (count == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"system_university_list";
        [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
            if ([data[@"ret"] isEqualToString:@"0001"]) {
                NSArray *array = data[@"data"][@"university_list"];
                //开始事物
                [[self db] beginTransaction];
                BOOL isRollBack = NO;
                @try {
                    for (NSString *university in array) {
                        [[self db] executeUpdate:@"insert into university (university) values(?)", university];
                    }
                }
                @catch (NSException *exception){
                    isRollBack = YES;
                    [[self db] rollback];
                }
                @finally {
                    if (!isRollBack) {
                        [[self db] commit];
                        [self searchUniversity:key success:success error:error failure:failure];
                    }
                    [SVProgressHUD dismiss];
                }
                
            } else {
                [SVProgressHUD dismiss];
                if (error) {
                    error(data);
                }
                
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (failure) {
                failure(error);
            }
        }];
    } else {
        sql = [NSString stringWithFormat:@"select * from university where university like '%%%@%%' order by university asc", key];
        FMResultSet *resultList = [[self db] executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while (resultList.next) {
            [array addObject:[resultList stringForColumnIndex:0]];
        }
        if (success) {
            success(array);
        }
    }
}

//获取七牛token
+ (void)qiniuTokenWithFileName:(NSString *)fileName success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"qiniu_token";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"pic_name"] = fileName;
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
            
        }
    } failure:failure];
}

//检查手机号是否被注册
+ (void)checkPhoneExist:(NSString *)phone success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"check_phone";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"phone"] = phone;
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
            
        }
    } failure:failure];
}

//注册
+ (void)registerWithPhone:(NSString *)phone nick:(NSString *)nick pwd:(NSString *)pwd photo:(NSString *)photo sex:(NSUInteger)sex tagList:(NSArray *)tagList university:(NSString *)university success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"register";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"phone"] = phone;
    data[@"nick"] = nick;
    data[@"pwd"] = [pwd md5String];
    data[@"photo"] = photo;
    data[@"sex"] = @(sex);
    data[@"tag_list"] = tagList;
    data[@"university"] = university;
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            [UserTool saveCurrentUserInfo:data[@"data"]];
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//获取热门学校列表
+ (void)activeUniversityList:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"active_university_list";
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
            
        }
    } failure:failure];
}

//登录
+ (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"login";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"phone"] = phone;
    data[@"pwd"] = [pwd md5String];
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            [UserTool saveCurrentUserInfo:data[@"data"]];
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//切换学校
+ (void)switchActiveUniversity:(NSString *)university success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"switch_active_university";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"university"] = university;
    data[@"access_token"] = [UserTool getAccessToken];
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            [UserTool saveActiveUniversity:university];
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

// 获取Status 内部调用
+ (void)getStatus:(NSInteger)since_id max_id:(NSInteger)max_id type:(NSInteger)type is_follow:(BOOL)is_follow success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    NSString *access_token = [UserTool getAccessToken];
    NSString *user_sha1 = [UserTool getUserSha1];
    NSString *active_university = [UserTool getActiveUniversity];
    NSMutableArray *statuses = [NSMutableArray array];
    NSString *sql = nil;
    NSLog(@"%ld --- %ld", (long)since_id, (long)type);
    if (is_follow) {
        type = -1;
    }
    if (!is_follow) {
        if (since_id != -1) {
            sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %ld and user_sha1 = '%@' and status_id > %ld order by status_id limit 20",active_university ,is_follow, (long)type, user_sha1, (long)since_id];//小在前
        } else if(max_id != -1) {
            sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %ld and user_sha1 = '%@' and status_id < %ld order by status_id desc limit 20",active_university ,is_follow, (long)type, user_sha1, (long)max_id];//大在前
        } else {
            sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %ld and user_sha1 = '%@' order by status_id desc limit 20",active_university ,is_follow, (long)type, user_sha1];//大在前
        }
    } else {
        if (since_id != -1) {
            sql = [NSString stringWithFormat:@"select status from status where is_follow = %d and type = %ld and user_sha1 = '%@' and status_id > %ld order by status_id limit 20",is_follow, (long)type, user_sha1, (long)since_id];//小在前
        } else if(max_id != -1) {
            sql = [NSString stringWithFormat:@"select status from status where is_follow = %d and type = %ld and user_sha1 = '%@' and status_id < %ld order by status_id desc limit 20",is_follow, (long)type, user_sha1, (long)max_id];//大在前
        } else {
            sql = [NSString stringWithFormat:@"select status from status where is_follow = %d and type = %ld and user_sha1 = '%@' order by status_id desc limit 20",is_follow, (long)type, user_sha1];//大在前
        }
    }
    
    FMResultSet *results = [[self db] executeQuery:sql];
    while (results.next) {
        NSData *data = [results dataForColumnIndex:0];
        NSDictionary *status = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (since_id != -1) {//保证status_id大的在前
            [statuses insertObject:status atIndex:0];
        } else {
            [statuses addObject:status];
        }
    }
    
    if(statuses.count != 0) {
        if (success) {
            success(statuses);
        }
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"status_list";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"since_id"] = @(since_id);
    data[@"max_id"] = @(max_id);
    data[@"type"] = @(type);
    data[@"is_follow"] = @(is_follow);
    data[@"access_token"] = access_token;
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            NSArray *status_list = data[@"data"][@"status_list"];
            //开始事物
            [[self db] beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (NSDictionary *status in status_list) {
                    NSString *pk = [NSString stringWithFormat:@"%@-%@-%d", user_sha1, status[@"status_id"], is_follow];
                    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
                    NSNumber *status_type = status[@"type"];
                    if (is_follow) {
                        status_type = @(-1);
                    }
                    [[self db] executeUpdate:@"insert into status (pk, status_id, type, status, user_sha1, university, is_follow) values(?,?,?,?,?,?,?)", pk, status[@"status_id"],status_type, statusData, user_sha1, status[@"university"], @(is_follow)];
                }
            }
            @catch (NSException *exception){
                isRollBack = YES;
                [[self db] rollback];
            }
            @finally {
                if (!isRollBack) {
                    [[self db] commit];
                }
            }
            if (success) {
                success(data[@"data"][@"status_list"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//获取新的Status
+ (void)getNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    [self getStatus:since_id max_id:-1 type:type is_follow:NO success:success error:error failure:failure];
}

//获取旧的Status
+ (void)getOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    [self getStatus:-1 max_id:max_id type:type is_follow:NO success:success error:error failure:failure];
}

//获取关注的好友新的Status
+ (void)getFollowNewStatus:(NSInteger)since_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    [self getStatus:since_id max_id:-1 type:type is_follow:YES success:success error:error failure:failure];
}

//获取关注的好友旧的Status
+ (void)getFollowOldStatus:(NSInteger)max_id type:(NSInteger)type success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    [self getStatus:-1 max_id:max_id type:type is_follow:YES success:success error:error failure:failure];
}

//获取评论
+ (void)getOldComment:(NSInteger)max_id status_sha1:(NSString *)status_sha1 success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"comment_list";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"max_id"] = @(max_id);
    data[@"status_sha1"] = status_sha1;
    data[@"access_token"] = [UserTool getAccessToken];
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"][@"comment_list"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//发布一条status
+ (void)publishStatus:(NSString *)title content:(NSString *)content image_list:(NSArray *)image_list type:(NSInteger)type vote:(NSDictionary *)vote success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    [UploadImageTool uploadimages:image_list success:^(NSArray *urlArray) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"publish_status";
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        data[@"title"] = title;
        data[@"content"] = content;
        data[@"image_list"] = urlArray;
        data[@"type"] = @(type);
        data[@"access_token"] = [UserTool getAccessToken];
        data[@"vote"] = vote;
        params[@"data"] = [NSString jsonStringWithObj:data];
        [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
            if ([data[@"ret"] isEqualToString:@"0001"]) {
                if (success) {
                    success(data[@"data"]);
                }
            } else {
                if (error) {
                    error(data);
                }
            }
        } failure:failure];
    } failure:^{
        if (failure) {
            failure(nil);
        }
    }];
}

//发布一条评论
+ (void)publishComment:(NSString *)content comment_sha1:(NSString *)comment_sha1 status_sha1:(NSString *)status_sha1 success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"publish_comment";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"content"] = content;
    data[@"access_token"] = [UserTool getAccessToken];
    data[@"status_sha1"] = status_sha1;
    if (comment_sha1.length) {
        data[@"comment_sha1"] = comment_sha1;
    }
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//点赞/取消点赞
+ (void)clickLike:(NSString *)status_sha1 success:(void (^)(id))success error:(void (^)(id))error failure:(void (^)(NSError *))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"click_like";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"status_sha1"] = status_sha1;
    data[@"access_token"] = [UserTool getAccessToken];
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

//分享成功
+ (void)shareSuccess:(NSString *)status_sha1 success:(void (^)(id data))success error:(void (^)(id data))error failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"share_count_add";
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"status_sha1"] = status_sha1;
    data[@"access_token"] = [UserTool getAccessToken];
    params[@"data"] = [NSString jsonStringWithObj:data];
    [HttpTool POST:HOST parameters:params progress:nil success:^(id data) {
        if ([data[@"ret"] isEqualToString:@"0001"]) {
            if (success) {
                success(data[@"data"]);
            }
        } else {
            if (error) {
                error(data);
            }
        }
    } failure:failure];
}

@end
