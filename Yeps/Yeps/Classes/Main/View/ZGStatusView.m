//
//  ZGStatusView.m
//  Yeps
//
//  Created by weimi on 16/3/19.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusView.h"
#import "ZGPhotoView.h"
#import "ZGImageView.h"
#import "ZGLabel.h"
#import "ZGTextView.h"
#import "ZGStatusCellToolBar.h"
#import "ZGVoteView.h"
#import "ZGStatusImageListView.h"
#import "StatusFrameModel.h"
#import "StatusModel.h"
#import "UserBaseInfoModel.h"
#import <UIImageView+WebCache.h>
#import "NSString+Extension.h"

@interface ZGStatusView()

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
 *  类型
 */
@property (nonatomic, weak) ZGLabel *typeLabel;
///**
// *  大图
// */
//@property (nonatomic, weak) ZGImageView *bannerImageView;
/**
 *  标题
 */
@property (nonatomic, weak) ZGLabel *titleLabel;
/**
 *  内容
 */
@property (nonatomic, weak) ZGTextView *contentTextView;
/**
 *  图片列表
 */
@property (nonatomic, weak) ZGStatusImageListView *imageListView;
/**
 *  投票
 */
@property (nonatomic, weak) ZGVoteView *voteView;
/**
 *  工具条
 */
@property (nonatomic, weak) ZGStatusCellToolBar *toolBar;
/**
 *  顶部maskView
 */
//@property (nonatomic, weak) UIView *headerMaskView;

@end

@implementation ZGStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (ZGImageView *)bannerImageView {
//    if (_bannerImageView == nil) {
//        ZGImageView *imageView = [[ZGImageView alloc] init];
//        _bannerImageView = imageView;
//        [self addSubview:imageView];
//    }
//    return _bannerImageView;
//}

//- (UIView *)headerMaskView {
//    if (_headerMaskView == nil)  {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor popMaskColor];
//        _headerMaskView = view;
//        [self addSubview:view];
//    }
//    return _headerMaskView;
//}

- (ZGPhotoView *)photoView {
    if (_photoView == nil) {
        ZGPhotoView *photoView = [[ZGPhotoView alloc] init];
        _photoView = photoView;
        [self addSubview:photoView];
    }
    return _photoView;
}

- (ZGLabel *)nickLabel {
    if (_nickLabel == nil) {
        ZGLabel *nickLabel = [[ZGLabel alloc] init];
        nickLabel.font = kNickLabelFont;
        _nickLabel = nickLabel;
        [self addSubview:nickLabel];
    }
    return _nickLabel;
}

- (ZGLabel *)timeLabel {
    if (_timeLabel == nil) {
        ZGLabel *timeLabel = [[ZGLabel alloc] init];
        timeLabel.font = kTimeLabelFont;
        timeLabel.textColor = [UIColor popFontGrayColor];
        _timeLabel = timeLabel;
        [self addSubview:timeLabel];
    }
    return _timeLabel;
}

- (ZGLabel *)typeLabel {
    if (_typeLabel == nil) {
        ZGLabel *typeLabel = [[ZGLabel alloc] init];
        typeLabel.font = kTypeLabelFont;
        typeLabel.textColor = [UIColor popColor];
        _typeLabel = typeLabel;
        [self addSubview:typeLabel];
    }
    return _typeLabel;
}

- (ZGLabel *)titleLabel {
    if (_titleLabel == nil) {
        ZGLabel *titleLabel = [[ZGLabel alloc] init];
        titleLabel.font = kTitleLabelFont;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor popFontColor];
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return _titleLabel;
}

- (ZGTextView *)contentTextView {
    if (_contentTextView == nil) {
        ZGTextView *contentTextView = [[ZGTextView alloc] init];
        contentTextView.font = kContentTextViewFont;
        contentTextView.backgroundColor = [UIColor clearColor];
        //        contentTextView.textAlignment = NSTextAlignmentCenter;
        contentTextView.textColor = [UIColor popContentColor];
        contentTextView.editable = NO;
        contentTextView.scrollEnabled = NO;
        contentTextView.userInteractionEnabled = NO;
        contentTextView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        _contentTextView = contentTextView;
        [self addSubview:contentTextView];
    }
    return _contentTextView;
}

- (ZGStatusImageListView *)imageListView {
    if (_imageListView == nil) {
        ZGStatusImageListView *imageListView = [[ZGStatusImageListView alloc] init];
        _imageListView = imageListView;
        [self addSubview:imageListView];
    }
    return _imageListView;
}

- (ZGVoteView *)voteView {
    if (_voteView == nil) {
        ZGVoteView *voteView = [[ZGVoteView alloc] init];
        _voteView = voteView;
        [self addSubview:voteView];
    }
    return _voteView;
}

- (ZGStatusCellToolBar *)toolBar {
    if (_toolBar == nil) {
        ZGStatusCellToolBar *toolBar = [[ZGStatusCellToolBar alloc] init];
        _toolBar = toolBar;
        [self addSubview:toolBar];
    }
    return _toolBar;
}

- (void)setStatusF:(StatusFrameModel *)statusF {
    _statusF = statusF;
    [self setupSubViews];
}

- (void)setupSubViews {
    
    if (self.statusF == nil) {
        return;
    }
    
    StatusFrameModel *statusF = self.statusF;
    StatusModel *status = statusF.status;
    UserBaseInfoModel *user = status.create_user;
    
    //    if (status.image_list.firstObject) {
    //        self.bannerImageView.frame = statusF.bannerImageViewF;
    //        [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:status.image_list.firstObject]];
    //        self.bannerImageView.hidden = NO;
    //    } else {
    //        self.bannerImageView.hidden = YES;
    //    }
    //
    //    self.headerMaskView.frame = CGRectMake(0, 0, kMaxW, CGRectGetMaxY(statusF.photoViewF) + kCellPadding);
    
    self.nickLabel.frame = statusF.nickLabelF;
    self.nickLabel.text = user.nick;
    
    self.photoView.frame = statusF.photoViewF;
    self.photoView.userBaseInfo = user;
    
    self.timeLabel.frame = statusF.timeLabelF;
    self.timeLabel.text = status.create_time;
    
    self.typeLabel.frame = statusF.typeLabelF;
    self.typeLabel.text = kTypeStrs[status.type];
    
    self.titleLabel.frame = statusF.titleLabelF;
    self.titleLabel.attributedText = status.attrTitle;
    
    self.contentTextView.frame = statusF.contentTextViewF;
    if (statusF.style == StatusCellFrameStyleList) {
        self.contentTextView.attributedText = status.attrSubContent;
        self.contentTextView.userInteractionEnabled = NO;
    } else {
        self.contentTextView.attributedText = status.attrContent;
        self.contentTextView.userInteractionEnabled = YES;
    }
    
    if (status.image_list.count != 0) {
        self.imageListView.hidden = NO;
        self.imageListView.status = status;
        self.imageListView.frame = statusF.imageListViewF;
    } else {
        self.imageListView.hidden = YES;
    }
    
    if (status.type == 1) {
        self.voteView.hidden = NO;
        self.voteView.frame = statusF.voteViewF;
        self.voteView.status = status;
    } else {
        self.voteView.hidden = YES;
    }
    
    self.toolBar.frame = statusF.toolBarF;
    self.toolBar.status = status;
    self.frame = CGRectMake(0, 0, kMaxW, self.statusF.height - kCellMargin);
    [self setNeedsDisplay];
    
}



- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.statusF) {
        CGRect frame = self.statusF.photoViewF;
        CGContextRef context =  UIGraphicsGetCurrentContext();
        [[UIColor popBorderColor] setStroke];
        CGContextSetLineWidth(context, 1.0);
        CGContextAddArc(context, CGRectGetMidX(frame), CGRectGetMidY(frame), frame.size.width * 0.5, 0, 2 * M_PI, 0);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}

@end
