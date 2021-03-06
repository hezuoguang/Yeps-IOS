//
//  UserBaseInfoModel.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBaseInfoModel : NSObject

@property (nonatomic, copy) NSString *user_sha1;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *smallPhoto;
@property (nonatomic, assign) NSInteger recommend_id;
@property (nonatomic, assign) NSInteger search_id;
@property (nonatomic, assign) NSInteger follow_id;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, assign) BOOL is_follow;

@end
