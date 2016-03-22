//
//  CommentModel.h
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserBaseInfoModel;

#define kCommentMaxW [UIScreen mainScreen].bounds.size.width
#define kCommentMaxH [UIScreen mainScreen].bounds.size.height
#define kCommentCellPadding 10.0
#define kCommentCellMargin 15.0
#define kCommentPhotoViewWH 50
#define kCommentNickLabelFont [UIFont systemFontOfSize:14]
#define kCommentTimeLabelFont [UIFont systemFontOfSize:10.0]
#define kCommentContentTextViewFont [UIFont systemFontOfSize:14]

@interface CommentModel : NSObject

//create_user: {
//user_sha1: "user_sha1",
//nick: "昵称",
//photo: "头像url"
//},
//comment_id: "",
//comment_sha1: "Status_sha1",
//content: "评论内容",
//create_time: "创建时间(2016-02-27 18:21:34)",
//is_sub: "是否为子评论(0:不是 1:是)"
@property (nonatomic, strong) UserBaseInfoModel *create_user;
@property (nonatomic, strong) UserBaseInfoModel *other_user;
@property (nonatomic, assign) NSInteger comment_id;
@property (nonatomic, copy) NSString *comment_sha1;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) BOOL is_sub;
@property (nonatomic, assign) BOOL is_me;

@property (nonatomic, strong) NSAttributedString *attrContent;
@end
