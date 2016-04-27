//
//  UserInfoModel.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (instancetype)initWithBaseModel:(UserBaseInfoModel *)baseInfo {
    UserInfoModel *userInfo = [[UserInfoModel alloc] init];
    userInfo.nick = baseInfo.nick;
    userInfo.user_sha1 = baseInfo.user_sha1;
    userInfo.photo = baseInfo.photo;
    userInfo.recommend_id = baseInfo.recommend_id;
    userInfo.is_follow = baseInfo.is_follow;
    return userInfo;
}

@end
