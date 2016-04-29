//
//  ZGMessageModel.h
//  Yeps
//
//  Created by weimi on 16/4/28.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ZGMessageModelTypeComment = 0,
    ZGMessageModelTypeHookUp,
    ZGMessageModelTypeFollow,
    ZGMessageModelTypeShare
}ZGMessageModelType;
#define kZGMessageListCellHeight 70
@class UserBaseInfoModel;
@interface ZGMessageModel : NSObject
//
//other_user: {
//user_sha1: "user_sha1",
//nick: "昵称",
//photo: "头像url"
//},
//message_id: "",
//message_sha1: "",
//content: "消息内容",
//type: "0 评论...",
//obj_sha1: ""
@property (nonatomic, strong) UserBaseInfoModel *other_user;
@property (nonatomic, assign) NSInteger message_id;
@property (nonatomic, copy) NSString *message_sha1;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) ZGMessageModelType type;
@property (nonatomic, copy) NSString *obj_sha1;
@property (nonatomic, copy) NSString *time;

@end
