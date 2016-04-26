//
//  UserBaseInfoModel.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UserBaseInfoModel.h"
#import "UserTool.h"

@implementation UserBaseInfoModel

//- (void)setNick:(NSString *)nick {
//    if ([self.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
//        _nick = [[UserTool getUserNick] copy];
//        if(_nick) return;
//    }
//    _nick = [nick copy];
//}
//
//- (void)setPhoto:(NSString *)photo {
//    if ([self.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
//        _photo = [[UserTool getUserPhoto] copy];
//        if(_photo) return;
//    }
//    _photo = [photo copy];
//}
//
//- (void)setUser_sha1:(NSString *)user_sha1 {
//    _user_sha1 = [user_sha1 copy];
//    if ([user_sha1 isEqualToString:[UserTool getUserSha1]]) {
//        _nick = [[UserTool getUserNick] copy];
//        _photo = [[UserTool getUserPhoto] copy];
//    }
//}

- (NSString *)nick {
    if ([self.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
        return [[UserTool getUserNick] copy];
    }
    return _nick;
}

- (NSString *)photo {
    if ([self.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
        return [[UserTool getUserPhoto] copy];
    }
    return _photo;
}

- (NSString *)smallPhoto {
    if (_smallPhoto == nil) {
        _smallPhoto = [NSString stringWithFormat:@"%@%@", self.photo, kIMAGESMALLURLENDFIX];
    }
    return _smallPhoto;
}

@end
