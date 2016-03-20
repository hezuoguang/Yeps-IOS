//
//  CommentFrameModel.m
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "CommentFrameModel.h"
#import "CommentModel.h"
#import "UserBaseInfoModel.h"
@implementation CommentFrameModel

- (void)setComment:(CommentModel *)comment {
    _comment = comment;
    [self setFrames];
}

- (void)setFrames{
    if (self.comment == nil) {
        return;
    }
    CommentModel *comment = self.comment;
    UserBaseInfoModel *user = comment.create_user;
    
    //头像
    CGFloat photoViewX = kCommentCellPadding;
    if (comment.is_me) {
        photoViewX = kCommentMaxW - kCommentCellPadding - kCommentPhotoViewWH;
    }
    CGFloat photoViewY = kCommentCellPadding;
    self.photoViewF = CGRectMake(photoViewX, photoViewY, kCommentPhotoViewWH, kCommentPhotoViewWH);
    
    //昵称
    CGFloat nickLabelX = CGRectGetMaxX(self.photoViewF) + kCommentCellPadding;
    CGFloat nickLabelY = kCommentCellPadding;
    NSDictionary *nickAttr = @{
                               NSFontAttributeName : kCommentNickLabelFont
                               };
    CGSize nickLabelSize = [user.nick boundingRectWithSize:CGSizeMake(kCommentMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nickAttr context:nil].size;
    if (comment.is_me) {
        nickLabelX = CGRectGetMinX(self.photoViewF) - nickLabelSize.width - kCommentCellPadding;
    }
    self.nickLabelF = (CGRect){{nickLabelX, nickLabelY}, nickLabelSize};
    
    
    //内容
    CGFloat contentTextViewX = CGRectGetMinX(self.nickLabelF);
    CGFloat contentTextViewMaxW = kCommentMaxW - 3 * kCommentPhotoViewWH;
    CGFloat contentTextViewY = CGRectGetMaxY(self.nickLabelF);
    CGSize contentTextViewSize = [comment.attrContent boundingRectWithSize:CGSizeMake(contentTextViewMaxW - 3 * kCommentCellPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat contentTextViewW = contentTextViewSize.width + 3 * kCommentCellPadding;
    if (comment.is_me) {
        contentTextViewX = CGRectGetMaxX(self.nickLabelF) - contentTextViewW;
    }
    self.contentTextViewF = (CGRect){{contentTextViewX, contentTextViewY}, {contentTextViewW, contentTextViewSize.height + 2 * kCommentCellPadding}};
    
    self.height = MAX(CGRectGetMaxY(self.timeLabelF), CGRectGetMaxY(self.contentTextViewF)) + kCommentCellMargin;
    
}

- (CGRect)timeLabelF {
    //时间
    CGFloat timeLabelX = CGRectGetMinX(self.photoViewF) - kCommentCellPadding;
    NSDictionary *timeAttr = @{
                               NSFontAttributeName : kCommentTimeLabelFont
                               };
    CGSize timeLabelSize = [self.comment.create_time boundingRectWithSize:CGSizeMake(kCommentPhotoViewWH + 2 * kCommentCellPadding, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeAttr context:nil].size;
    CGFloat timeLabelY = CGRectGetMaxY(self.photoViewF) + 5;
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, {kCommentPhotoViewWH + 2 * kCommentCellPadding, timeLabelSize.height}};
    return _timeLabelF;
}

@end
