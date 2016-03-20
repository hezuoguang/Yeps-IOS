//
//  StatusFrameModel.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "StatusFrameModel.h"
#import "StatusModel.h"
#import "UserBaseInfoModel.h"
#import "ZGStatusImageListView.h"
#import "VoteModel.h"
#import "ZGVoteView.h"

@interface StatusFrameModel()



@end

@implementation StatusFrameModel

- (void)setStatus:(StatusModel *)status {
    _status = status;
    [self setFrames];
}

- (void)setStyle:(StatusCellFrameStyle)style {
    if (_style == style) {
        return;
    }
    _style = style;
    [self setFrames];
}

- (void)setFrames {
    if(self.status == nil) return;
    StatusModel *status = self.status;
    UserBaseInfoModel *user = status.create_user;
    
//    //大图
//    self.bannerImageViewF = CGRectMake(0, 0, kBannerImageViewW, kBannerImageViewH);
    
    //头像
    CGFloat photoViewX = kCellPadding;
    CGFloat photoViewY = kCellPadding;
    self.photoViewF = CGRectMake(photoViewX, photoViewY, kPhotoViewWH, kPhotoViewWH);
    
    //昵称
    CGFloat nickLabelX = CGRectGetMaxX(self.photoViewF) + kCellPadding;
    CGFloat nickLabelY = kCellPadding;
    NSDictionary *nickAttr = @{
        NSFontAttributeName : kNickLabelFont
    };
    CGSize nickLabelSize = [user.nick boundingRectWithSize:CGSizeMake(kMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:nickAttr context:nil].size;
    self.nickLabelF = (CGRect){{nickLabelX, nickLabelY}, nickLabelSize};
    
    //类型
    NSString *typeStr = kTypeStrs[status.type];
    CGSize typeLabelSize = [typeStr boundingRectWithSize:CGSizeMake(kMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kTypeLabelFont} context:nil].size;
    CGFloat typeLabelX = kMaxW - typeLabelSize.width - kCellPadding;
    CGFloat typeLabelY = CGRectGetMinY(self.nickLabelF);
    self.typeLabelF = (CGRect){{typeLabelX, typeLabelY}, typeLabelSize};
    
    //标题
    CGFloat titleLabelX = 2 * kCellPadding;
    CGFloat titleLabelMaxW = kMaxW - 2 * titleLabelX;
    CGFloat titleLabelY = CGRectGetMaxY(self.photoViewF) + kCellPadding;
    CGSize titleLabelSize = [status.attrTitle boundingRectWithSize:CGSizeMake(titleLabelMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    CGFloat titleLabelH = status.attrTitle.size.width / titleLabelMaxW * status.attrTitle.size.height;
    self.titleLabelF = (CGRect){{titleLabelX, titleLabelY}, {titleLabelMaxW, titleLabelSize.height}};
    
    NSAttributedString *content = nil;
    
    if (self.style == StatusCellFrameStyleDetail) {
        content = status.attrContent;
    } else {
        content = status.attrSubContent;
    }
    
    //内容
    CGFloat contentTextViewX = kCellPadding;
    CGFloat contentTextViewMaxW = kMaxW - 2 * contentTextViewX;
    CGFloat contentTextViewY = CGRectGetMaxY(self.titleLabelF) + kCellPadding;
    CGSize contentTextViewSize = [content boundingRectWithSize:CGSizeMake(contentTextViewMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentTextViewF = (CGRect){{contentTextViewX, contentTextViewY}, {contentTextViewMaxW, contentTextViewSize.height}};
    
    //imageList
    CGFloat toolBarY = CGRectGetMaxY(self.contentTextViewF) + kCellPadding;
    if (status.image_list.count != 0) {
        CGFloat imageListViewX = kCellPadding;
        CGFloat imageListViewY = CGRectGetMaxY(self.contentTextViewF) + kCellPadding;
        CGSize imageListViewSize = [ZGStatusImageListView sizeWithStatus:status];
        if (status.image_list.count == 1) {
            self.imageListViewF = (CGRect){{0, imageListViewY}, imageListViewSize};
            toolBarY = CGRectGetMaxY(self.imageListViewF) + 1;
        }
        else {
            self.imageListViewF = (CGRect){{imageListViewX, imageListViewY}, imageListViewSize};
            toolBarY = CGRectGetMaxY(self.imageListViewF) + kCellPadding;
        }
    }
    
    if (status.type == 1) {//投票
        CGFloat voteX = kCellPadding;
        CGFloat voteY = toolBarY;
        CGSize voteSize = [ZGVoteView sizeWithStatus:status];
        self.voteViewF = CGRectMake(voteX, voteY, voteSize.width, voteSize.height);
        toolBarY = CGRectGetMaxY(self.voteViewF) + kCellPadding;
        
    }
    
    self.toolBarF = CGRectMake(0, toolBarY, kMaxW, kToolBarH);
    
    self.height = CGRectGetMaxY(self.toolBarF) + kCellMargin;

}

- (CGRect)timeLabelF {
    //时间
    CGFloat timeLabelX = CGRectGetMinX(self.nickLabelF);
    NSDictionary *timeAttr = @{
                               NSFontAttributeName : kTimeLabelFont
                               };
    CGSize timeLabelSize = [self.status.create_time boundingRectWithSize:CGSizeMake(kMaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:timeAttr context:nil].size;
    CGFloat timeLabelY = CGRectGetMaxY(self.photoViewF) - timeLabelSize.height - 4;
    _timeLabelF = (CGRect){{timeLabelX, timeLabelY}, timeLabelSize};
    return _timeLabelF;
}

@end
