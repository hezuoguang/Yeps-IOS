//
//  StatusModel.h
//  Yeps
//
//  Created by weimi on 16/3/7.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
//16 : 10
#define kMaxW [UIScreen mainScreen].bounds.size.width
#define kMaxH [UIScreen mainScreen].bounds.size.height
#define kCellPadding 10.0
#define kCellMargin 8.0
#define kPhotoViewWH 50
#define kImageViewMargin 2
#define kImageViewPadding 0
#define kImageViewWH2 ((kMaxW - kImageViewMargin - 2 * kImageViewPadding) * 0.5)
#define kImageViewWH3 ((kMaxW - 2 * kImageViewMargin - 2 * kImageViewPadding) / 3.0)
#define kImageViewWH4 ((kMaxW - 3 * kImageViewMargin - 2 * kImageViewPadding) / 4.0)
#define kBannerImageViewW ([UIScreen mainScreen].bounds.size.width - 2 * kImageViewPadding)
#define kBannerImageViewH ([UIScreen mainScreen].bounds.size.width * 10.0 / 16.0)
#define kNickLabelFont [UIFont systemFontOfSize:19]
#define kTimeLabelFont [UIFont systemFontOfSize:13.0]
#define kTypeLabelFont [UIFont systemFontOfSize:14]
#define kTitleLabelFont [UIFont systemFontOfSize:21]
#define kContentTextViewFont [UIFont systemFontOfSize:15]
#define kToolBarH 38
#define kVoteOptionH 25
#define kVoteOptionMargin 10
#define kVoteBtnW 100
#define kVoteBtnH 30
#define ktypeScrollViewH 44
@class UserBaseInfoModel, VoteModel;
@interface StatusModel : NSObject

//create_user: {
//user_sha1: "user_sha1",
//nick: "昵称",
//photo: "头像url"
//},
//status_id: "",
//status_sha1: "Status_sha1",
//title: "标题",
//content: "详细内容",
//image_list: "图片url_list[http://XXX.com/XXX.png,...]",
//type: "1:微评选",
//create_time: "创建时间(2016-02-27 18:21:34)",
//like_count: "点赞数",
//share_count: "分享数",
//comment_conut: "评论数",
//university: "大学",
//vote: {
//vote_sha1: "",
//vote_option: "选项列表[选项1, 选项二]",
//vote_result: "选项对应的票数[1,10]",
//vote_count: "当前总票数",
//me_is_vote: "我是否参与了投票(0:未参与, 1:参与了)",
//me_vote_option: "我投的选项下标",
//end_time: "结束时间",
//is_end: "是否已经结束(0:未结束, 1:已结束)"
//}
//}

@property (nonatomic, strong) UserBaseInfoModel *create_user;
@property (nonatomic, assign) NSUInteger status_id;
@property (nonatomic, copy) NSString *status_sha1;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *image_list;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger share_count;
@property (nonatomic, assign) NSInteger comment_conut;
@property (nonatomic, assign) BOOL me_is_like;
@property (nonatomic, copy) NSString *university;
@property (nonatomic, strong) VoteModel *vote;

@property (nonatomic, strong) NSAttributedString *attrTitle;
/**
 *  完整内容
 */
@property (nonatomic, strong) NSAttributedString *attrContent;
/**
 *  列表中的内容
 */
@property (nonatomic, strong) NSAttributedString *attrSubContent;

@end
