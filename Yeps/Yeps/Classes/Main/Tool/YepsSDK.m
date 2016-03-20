//
//  BSSDK.m
//  百思不得姐
//
//  Created by weimi on 16/2/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "YepsSDK.h"
#import "HttpTool.h"
#import "NSString+Extension.h"
#import <FMDB.h>
#import "UserTool.h"
#define HOST  @"http://192.168.0.102:8000/yeps/api/"
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
    NSLog(@"%d --- %d", since_id, type);
    if (is_follow) {
        type = -1;
    }
    if (since_id != -1) {
        sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %d and user_sha1 = '%@' and status_id > %d order by status_id limit 20",active_university ,is_follow, type, user_sha1, since_id];//小在前
    } else if(max_id != -1) {
        sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %d and user_sha1 = '%@' and status_id < %d order by status_id desc limit 20",active_university ,is_follow, type, user_sha1, max_id];//大在前
    } else {
        sql = [NSString stringWithFormat:@"select status from status where university = '%@' and is_follow = %d and type = %d and user_sha1 = '%@' order by status_id desc limit 20",active_university ,is_follow, type, user_sha1];//大在前
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

@end
