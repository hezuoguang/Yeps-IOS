//
//  ZGVoteView.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGVoteView.h"
#import "StatusModel.h"
#import "VoteModel.h"
#import "ZGVoteOptionView.h"
#import "StatusFrameModel.h"

#import <MJExtension/MJExtension.h>

@interface ZGVoteView()

@property (nonatomic, weak) UIButton *voteBtn;

@end

@implementation ZGVoteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVoteNoti:) name:kUpdateStatusVoteNotifi object:nil];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)nothing {
    
}

- (UIButton *)voteBtn {
    if (_voteBtn == nil) {
        UIButton *btn = [[UIButton alloc] init];
        _voteBtn = btn;
        [btn setTitle:@"投票" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitleColor:[UIColor popNavFontColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor popFontColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIColor imageWithColor:[UIColor popNavBackColor] size:CGSizeMake(12, 12)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIColor imageWithColor:[UIColor popColor] size:CGSizeMake(12, 12)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(voteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.enabled = NO;
        [self addSubview:btn];
    }
    return _voteBtn;
}

- (void)updateVoteNoti:(NSNotification *)noti {
    NSDictionary *voteDict = noti.object;
    if (![voteDict objectForKey:@"vote_sha1"]) {
        return;
    }
    if ([self.status.vote.vote_sha1 isEqualToString:[voteDict objectForKey:@"vote_sha1"]]) {
        VoteModel *vote = [VoteModel mj_objectWithKeyValues:voteDict];
        StatusModel *model = self.status;
        model.vote = vote;
        self.status = model;
    }
}

- (void)setStatus:(StatusModel *)status {
    _status = status;
    if (status.vote.me_is_vote || status.vote.is_end) {
        self.userInteractionEnabled = NO;
    } else {
        self.userInteractionEnabled = YES;
    }
    [self setNeedsLayout];
}

- (void)optionViewClick:(ZGVoteOptionView *)optionView {
    self.voteBtn.enabled = !optionView.selected;
    if (optionView.selected) {
        optionView.selected = NO;
        return;
    }
    NSInteger count = self.status.vote.vote_option.count;
    NSInteger index = 0;
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[ZGVoteOptionView class]]) {
            continue;
        }
        if (index == count) {
            break;
        }
        ZGVoteOptionView *optionViewTmp = (ZGVoteOptionView *)view;
        optionViewTmp.selected = NO;
        index++;
    }
    optionView.selected = YES;
}

- (void)voteBtnClick {
    NSInteger select = -1;
    NSInteger count = self.status.vote.vote_option.count;
    NSInteger index = 0;
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[ZGVoteOptionView class]]) {
            continue;
        }
        if (index == count) {
            break;
        }
        ZGVoteOptionView *optionViewTmp = (ZGVoteOptionView *)view;
        if (optionViewTmp.selected) {
            select = index;
        }
        index++;
    }
    self.voteBtn.enabled = NO;
    if (select == -1) {
        return;
    }
    [YepsSDK joinVote:select content:nil vote_sha1:self.status.vote.vote_sha1 success:^(id data) {
        [self postUpdateVoteNotifi:[data objectForKey:@"vote"]];
    } error:^(id data) {
        //已投票 / 投票已结束
        if ([[data objectForKey:@"ret"] isEqualToString:@"1001"] || [[data objectForKey:@"ret"] isEqualToString:@"1002"]) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
            [self postUpdateVoteNotifi:data[@"data"][@"vote"]];
            return;
        }
        self.voteBtn.enabled = YES;
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        self.voteBtn.enabled = YES;
    }];
}

- (void)postUpdateVoteNotifi:(NSDictionary *)voteDict {
    [YepsSDK updateStatusVote:voteDict status_id:self.status.status_id];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateStatusVoteNotifi object:voteDict];
}

- (BOOL)selectWithIndex:(NSInteger)index {
    if (self.status.vote.me_is_vote && index == self.status.vote.me_vote_option) {
        return YES;
    }
    return NO;
}

- (void)setupVoteUI {
    if (self.status) {
        VoteModel *vote = self.status.vote;
        NSUInteger count = vote.vote_option.count;
        if(self.status.isDetail == NO) {
            count = 2;
        }
        NSUInteger totalCount = vote.vote_count;
        NSUInteger index = 0;
        CGFloat optionViewX = 2;
        CGFloat optionViewY = 0;
        CGFloat optionViewW = self.frame.size.width - 2 * optionViewX;
        CGFloat optionViewH = kVoteOptionH;
        for (UIView *view in self.subviews) {
            if (![view isKindOfClass:[ZGVoteOptionView class]]) {
                continue;
            }
            ZGVoteOptionView *optionView = (ZGVoteOptionView *)view;
            if(index < count) {
                optionView.hidden = NO;
                [optionView updateUIWithTitle:vote.vote_option[index] optionCount:[vote.vote_result[index] integerValue] totalCount:totalCount];
                optionViewY = index * optionViewH + index * kVoteOptionMargin;
                optionView.frame = CGRectMake(optionViewX, optionViewY, optionViewW, optionViewH);
                optionView.selected = [self selectWithIndex:index];
            } else {
                optionView.hidden = YES;
            }
            index++;
        }
        while (index < count) {
            ZGVoteOptionView *optionView = [[ZGVoteOptionView alloc] init];
            [self addSubview:optionView];
            [optionView updateUIWithTitle:vote.vote_option[index] optionCount:[vote.vote_result[index] integerValue] totalCount:totalCount];
            optionViewY = index * optionViewH + index * kVoteOptionMargin;
            optionView.frame = CGRectMake(optionViewX, optionViewY, optionViewW, optionViewH);
            optionView.selected = [self selectWithIndex:index];
            [optionView addTarget:self action:@selector(optionViewClick:) forControlEvents:UIControlEventTouchUpInside];
            index++;
            
        }
        
        self.voteBtn.bounds = CGRectMake(0, 0, kVoteBtnW, kVoteBtnH);
        self.voteBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - kVoteBtnH * 0.5);
        
        if (self.status.isDetail == NO) {//列表页面
            
            if (vote.vote_option.count == 2) {
                self.voteBtn.hidden = YES;
            } else {
                [self.voteBtn setTitle:@"查看详情" forState:UIControlStateNormal];
                self.voteBtn.hidden = NO;
                self.voteBtn.enabled = YES;
                
            }
            self.userInteractionEnabled = NO;
        } else {
            if (vote.me_is_vote || vote.is_end) {
                self.voteBtn.hidden = NO;
                if(vote.me_is_vote) {
                    [self.voteBtn setTitle:@"已投票" forState:UIControlStateNormal];
                } else {
                    [self.voteBtn setTitle:@"已结束" forState:UIControlStateNormal];
                }
                self.userInteractionEnabled = NO;
                
            } else {
                self.voteBtn.hidden = NO;
                [self.voteBtn setTitle:@"投票" forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            }
        }
    }
    
}

+ (CGSize)sizeWithStatus:(StatusModel *)status style:(NSInteger)style{
    if (style != StatusCellFrameStyleDetail) {//列表状态
        NSInteger voteItemCount = 2;
        CGFloat voteH = voteItemCount * kVoteOptionH + (voteItemCount - 1) * kVoteOptionMargin;
        if (status.vote.vote_option.count > voteItemCount) {
            voteH = voteH + kVoteOptionMargin + kVoteBtnH;
        }
        return CGSizeMake(kMaxW, voteH);
    }
    NSUInteger voteItemCount = status.vote.vote_option.count;
    if (voteItemCount == 0) {
        return CGSizeMake(kMaxW, 0);
    }
    CGFloat voteH = voteItemCount * kVoteOptionH + (voteItemCount - 1) * kVoteOptionMargin;
//    if (status.vote.me_is_vote == NO && status.vote.is_end == NO) {
        voteH += kVoteOptionMargin + kVoteBtnH;
//    }
    return CGSizeMake(kMaxW, voteH);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupVoteUI];
}

@end
