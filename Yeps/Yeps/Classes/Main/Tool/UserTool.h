//
//  UserTool.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfoModel;
@interface UserTool : NSObject

+ (void)saveCurrentUserInfo:(NSDictionary *)infoDict;

+ (UserInfoModel *)getCurrentUserInfo;

+ (void)saveUserSha1:(NSString *)user_sha1;

+ (void)saveUserNick:(NSString *)nick;

+ (void)saveUserPhoto:(NSString *)photo;

+ (void)saveUserProfileBack:(NSString *)photo;

+ (void)saveAccessToken:(NSString *)access_token;

+ (void)saveActiveUniversity:(NSString *)active_university;

+ (NSString *)getUserSha1;

+ (NSString *)getAccessToken;

+ (NSString *)getActiveUniversity;

+ (NSString *)getUserNick;

+ (NSString *)getUserPhoto;

+ (NSString *)getUserProfileBack;

+ (void)logout;

+ (void)updateLastLanuchTime;

@end
