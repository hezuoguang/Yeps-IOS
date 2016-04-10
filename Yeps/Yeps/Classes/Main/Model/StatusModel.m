//
//  StatusModel.m
//  Yeps
//
//  Created by weimi on 16/3/7.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "StatusModel.h"
#import "NSString+Extension.h"

@implementation StatusModel

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_title];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5.0];
    [style setAlignment:NSTextAlignmentCenter];
    NSRange range = NSMakeRange(0, attStr.length);
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [attStr addAttribute:NSFontAttributeName value:kTitleLabelFont range:range];
    self.attrTitle = attStr;
}

- (void)setContent:(NSString *)content {
    _content = [content copy];
}

- (NSAttributedString *)attrContent {
    if (_attrContent == nil) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.content];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:5.0];
//        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor popContentColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:kContentTextViewFont range:range];
        _attrContent = attStr;
    }
    return _attrContent;
}

- (NSAttributedString *)attrSubContent {
    if (_attrSubContent == nil) {
        NSString *content = self.content;
        if (self.content.length > 60) {
            content = [NSString stringWithFormat:@"%@...", [self.content substringToIndex:60]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:5.0];
        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor popContentColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:kContentTextViewFont range:range];
        _attrSubContent = attStr;
    }
    return _attrSubContent;
}

- (NSString *)create_time {
    return [_create_time timeStringWithCurrentTime];
}

- (NSString *)createTimeStr {
    return _create_time;
}

- (void)updateStatusCount:(NSDictionary *)statusCountDict {
    [YepsSDK updateStatusCount:statusCountDict status_id:self.status_id];
    NSInteger likeCount = [statusCountDict[@"like_count"] integerValue];
    NSInteger shareCount = [statusCountDict[@"share_count"] integerValue];
    NSInteger commentConut = [statusCountDict[@"comment_conut"] integerValue];
    self.me_is_like = [statusCountDict[@"me_is_like"] boolValue];
    self.like_count = likeCount;
    self.share_count = shareCount;
    self.comment_conut = commentConut;
}

+ (StatusModel *)initWithStatusModel:(StatusModel *)status {

    StatusModel *newStatus = [[StatusModel alloc] init];
    
    newStatus.create_user = status.create_user;
    newStatus.status_id = status.status_id;
    newStatus.status_sha1 = status.status_sha1;
    newStatus.title = status.title;
    newStatus.content = status.content;
    newStatus.image_list = status.image_list;
    newStatus.type = status.type;
    newStatus.create_time = status.createTimeStr;
    newStatus.like_count = status.like_count;
    newStatus.share_count = status.share_count;
    newStatus.comment_conut = status.comment_conut;
    newStatus.me_is_like = status.me_is_like;
    newStatus.university = status.university;
    newStatus.vote = status.vote;
    newStatus.isDetail = status.isDetail;
    
    return newStatus;
}

@end
