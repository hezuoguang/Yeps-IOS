//
//  UserTool.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UserTool.h"
#import "UserInfoModel.h"
#import <MJExtension.h>

#define kCurrentUserInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"CurrentUserInfo.plist"]

#define ACCESS_TOKEN_KEY @"ACCESS_TOKEN_KEY"
#define USER_SHA1_KEY @"USER_SHA1_KEY"
#define Active_University_KEY @"Active_University_KEY"

@implementation UserTool

+ (void)saveCurrentUserInfo:(NSDictionary *)infoDict {
    [self saveAccessToken:infoDict[@"access_token"]];
    [self saveUserSha1:infoDict[@"user_sha1"]];
    [self saveActiveUniversity:infoDict[@"active_university"]];
    [infoDict writeToFile:kCurrentUserInfoPath atomically:YES];
}

+ (UserInfoModel *)getCurrentUserInfo {
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:kCurrentUserInfoPath];
    return [UserInfoModel mj_objectWithKeyValues:infoDict];
}

+ (void)saveActiveUniversity:(NSString *)active_university {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:active_university forKey:Active_University_KEY];
    [userDefault synchronize];
}

+ (void)saveAccessToken:(NSString *)access_token {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:access_token forKey:ACCESS_TOKEN_KEY];
    [userDefault synchronize];
}

+ (void)saveUserSha1:(NSString *)user_sha1 {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:user_sha1 forKey:USER_SHA1_KEY];
    [userDefault synchronize];
}

+ (NSString *)getAccessToken {
    return [[NSUserDefaults standardUserDefaults] valueForKey:ACCESS_TOKEN_KEY];
}

+ (NSString *)getUserSha1 {
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_SHA1_KEY];
}

+ (NSString *)getActiveUniversity {
    return [[NSUserDefaults standardUserDefaults] valueForKey:Active_University_KEY];
}

@end
