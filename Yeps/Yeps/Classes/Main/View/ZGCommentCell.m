//
//  ZGCommentCell.m
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGCommentCell.h"
#import "ZGLabel.h"
#import "ZGPhotoView.h"
#import "ZGTextView.h"
#import "CommentFrameModel.h"
#import "CommentModel.h"
#import "UserBaseInfoModel.h"
#import <UIImageView+WebCache.h>

@interface ZGCommentCell()

/**
 *  头像
 */
@property (nonatomic, weak) ZGPhotoView *photoView;
/**
 *  昵称
 */
@property (nonatomic, weak) ZGLabel *nickLabel;
/**
 *  创建时间
 */
@property (nonatomic, weak) ZGLabel *timeLabel;
/**
 *  内容
 */
@property (nonatomic, weak) ZGTextView *contentTextView;

@property (nonatomic, weak) UIButton *contentButton;


@end

@implementation ZGCommentCell

+ (instancetype)commentCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CommentCellID";
    ZGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZGCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.contentView.backgroundColor = [UIColor popBackGroundColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (ZGPhotoView *)photoView {
    if (_photoView == nil) {
        ZGPhotoView *photoView = [[ZGPhotoView alloc] init];
        _photoView = photoView;
        [self.contentView addSubview:photoView];
    }
    return _photoView;
}

- (ZGLabel *)nickLabel {
    if (_nickLabel == nil) {
        ZGLabel *nickLabel = [[ZGLabel alloc] init];
        nickLabel.font = kCommentNickLabelFont;
        _nickLabel = nickLabel;
        [self.contentView addSubview:nickLabel];
    }
    return _nickLabel;
}

- (ZGLabel *)timeLabel {
    if (_timeLabel == nil) {
        ZGLabel *timeLabel = [[ZGLabel alloc] init];
        timeLabel.font = kCommentTimeLabelFont;
        timeLabel.numberOfLines = 2;
        timeLabel.textColor = [UIColor popContentColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
    }
    return _timeLabel;
}

- (UIButton *)contentButton {
    if (_contentButton == nil) {
        UIButton *button = [[UIButton alloc] init];
        _contentButton = button;
        [button setBackgroundImage:[UIImage imageNamed:@"Comment_other"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"Comment_me"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        [self.contentView addSubview:button];
    }
    return _contentButton;
}

- (ZGTextView *)contentTextView {
    if (_contentTextView == nil) {
        ZGTextView *contentTextView = [[ZGTextView alloc] init];
        contentTextView.font = kCommentContentTextViewFont;
        contentTextView.backgroundColor = [UIColor clearColor];
        //        contentTextView.textAlignment = NSTextAlignmentCenter;
        contentTextView.textColor = [UIColor popFontColor];
        contentTextView.editable = NO;
        contentTextView.scrollEnabled = NO;
        contentTextView.userInteractionEnabled = NO;
        contentTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        _contentTextView = contentTextView;
        [self.contentButton addSubview:contentTextView];
    }
    return _contentTextView;
}

-(void)setCommentF:(CommentFrameModel *)commentF {
    _commentF = commentF;
    [self setupSubViews];
}

- (void)setupSubViews {
    if (self.commentF == nil) {
        return;
    }
    CommentFrameModel *commentF = self.commentF;
    CommentModel *comment = commentF.comment;
    UserBaseInfoModel *user = comment.create_user;
    
    self.nickLabel.frame = commentF.nickLabelF;
    self.nickLabel.text = user.nick;
    
    self.photoView.frame = commentF.photoViewF;
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.timeLabel.frame = commentF.timeLabelF;
    self.timeLabel.text = comment.create_time;
    
    self.contentButton.frame = commentF.contentTextViewF;
    CGFloat W = commentF.contentTextViewF.size.width - 3 * kCommentCellPadding;
    CGFloat H = commentF.contentTextViewF.size.height - 2 * kCommentCellPadding;
    self.contentButton.selected = comment.is_me;
    if (comment.is_me) {
        self.contentTextView.frame = CGRectMake(kCommentCellPadding, kCommentCellPadding, W, H);
    } else {
        self.contentTextView.frame = CGRectMake(2 * kCommentCellPadding, kCommentCellPadding, W, H);
    }
    self.contentTextView.attributedText = comment.attrContent;
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    if (self.commentF) {
//        CGRect frame = self.commentF.photoViewF;
//        CGContextRef context =  UIGraphicsGetCurrentContext();
//        [[UIColor popHighlightColor] setStroke];
//        CGContextSetLineWidth(context, 1.0);
//        CGContextAddArc(context, CGRectGetMidX(frame), CGRectGetMidY(frame), frame.size.width * 0.5, 0, 2 * M_PI, 0);
//        CGContextDrawPath(context, kCGPathStroke);
//    }
//    
//}

@end
