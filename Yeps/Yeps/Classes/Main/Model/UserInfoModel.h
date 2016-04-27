//
//  UserInfoModel.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UserBaseInfoModel.h"

@interface UserInfoModel : UserBaseInfoModel
//user_sha1: "用户sha1",
//nick: "昵称",
//photo: "头像url",
//phone: "手机号码",
//email: "邮箱",
//age: "年(22)",
//sex: "性别(男,女)",
//intro: "个人简介",
//birthday: "生日",
//university: "大学",
//tag_list: "标签列表[Python, IOS...](字符串)",
//create_time: "注册时间(2016-02-27 18:25:30)",
//last_active_time: "最后活动时间(2016-02-27 18:25:30)",
//is_follow"我是否关注了他(0:未关注, 1:关注了)"
//active_university: "当前活动学校",
//follow_count : "关注数"
//fans_count : "粉丝数"
//status_count : "状态数"

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *university;
@property (nonatomic, strong) NSMutableArray *tag_list;
@property (nonatomic, strong) NSMutableArray *image_list;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *last_active_time;
@property (nonatomic, copy) NSString *active_university;
@property (nonatomic, assign) NSInteger follow_count;
@property (nonatomic, assign) NSInteger fans_count;
@property (nonatomic, assign) NSInteger status_count;
@property (nonatomic, assign) NSInteger status_image_count;

+ (instancetype)initWithBaseModel:(UserBaseInfoModel *)baseInfo;

@end
