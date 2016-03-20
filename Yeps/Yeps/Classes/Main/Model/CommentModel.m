//
//  CommentModel.m
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "CommentModel.h"
#import "UserTool.h"
#import "UserInfoModel.h"
#import "NSString+Extension.h"
@implementation CommentModel

- (void)setCreate_user:(UserBaseInfoModel *)create_user {
    _create_user = create_user;
    UserInfoModel *user_info = [UserTool getCurrentUserInfo];
    if ([create_user.user_sha1 isEqualToString:user_info.user_sha1]) {
        self.is_me = YES;
    } else {
        self.is_me = NO;
    }
}

- (NSAttributedString *)attrContent {
    if (_attrContent == nil) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.content];
        //创建NSMutableParagraphStyle实例
//        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//        [style setLineSpacing:1.0];
//        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
//        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor popFontColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:kCommentContentTextViewFont range:range];
        _attrContent = attStr;
    }
    return _attrContent;
}

- (NSString *)create_time {
    return [_create_time timeStringWithCurrentTime];
}

@end
