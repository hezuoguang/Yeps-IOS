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
#define USER_NICK_KEY @"USER_NICK_KEY"
#define USER_PHOTO_KEY @"USER_PHOTO_KEY"
#define USER_PROFILE_BACK_KEY @"USER_PROFILE_BACK_KEY"
#define USER_LAST_LANUCH_TIME_KEY @"USER_LAST_LANUCH_TIME_KEY"

@implementation UserTool

+ (void)saveCurrentUserInfo:(NSDictionary *)infoDict {
    if ([infoDict objectForKey:@"access_token"]) {
        [self saveAccessToken:infoDict[@"access_token"]];
        [self saveUserSha1:infoDict[@"user_sha1"]];
    }
    [self saveActiveUniversity:infoDict[@"active_university"]];
    [self saveUserNick:infoDict[@"nick"]];
    [self saveUserPhoto:infoDict[@"photo"]];
    NSArray *images = infoDict[@"image_list"];
    [self saveUserProfileBack:images.firstObject];
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

+ (void)saveUserPhoto:(NSString *)photo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:photo forKey:USER_PHOTO_KEY];
    [userDefault synchronize];
}

+ (void)saveUserProfileBack:(NSString *)photo {
    if (photo == nil) {
        photo = @"";
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:photo forKey:USER_PROFILE_BACK_KEY];
    [userDefault synchronize];
}

+ (void)saveUserNick:(NSString *)nick {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:nick forKey:USER_NICK_KEY];
    [userDefault synchronize];
}

+ (NSString *)getAccessToken {
    NSString *access_token = [[NSUserDefaults standardUserDefaults] valueForKey:ACCESS_TOKEN_KEY];
    return access_token;
}

+ (NSString *)getUserSha1 {
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_SHA1_KEY];
}

+ (NSString *)getActiveUniversity {
    return [[NSUserDefaults standardUserDefaults] valueForKey:Active_University_KEY];
}

+ (NSString *)getUserNick {
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_NICK_KEY];
}

+ (NSString *)getUserPhoto {
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_PHOTO_KEY];
}

+ (NSString *)getUserProfileBack {
    return [[NSUserDefaults standardUserDefaults] valueForKey:USER_PROFILE_BACK_KEY];
}

+ (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_SHA1_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Active_University_KEY];
}

+ (NSInteger)date:(NSDate *)date sub:(NSDate *)subDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:subDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    NSInteger day = dayComponents.day;
    NSLog(@"-------%zd", day);
    if (day < 0) {
        day = -day;
    }
    return day;
}

+ (void)updateLastLanuchTime {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *last = [userDefault valueForKey:USER_LAST_LANUCH_TIME_KEY];
    NSDate *now = [NSDate date];
    if (last) {
        if ([self date:last sub:now] > 3) {
            [YepsSDK clearDataBase];
        }
    }
    [userDefault setValue:now forKey:USER_LAST_LANUCH_TIME_KEY];
    [userDefault synchronize];
}

@end
