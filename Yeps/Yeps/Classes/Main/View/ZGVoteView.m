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

@interface ZGVoteView()

@property (nonatomic, weak) UIButton *voteBtn;

@end

@implementation ZGVoteView

- (UIButton *)voteBtn {
    if (_voteBtn == nil) {
        UIButton *btn = [[UIButton alloc] init];
        _voteBtn = btn;
        [btn setTitle:@"投票" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        [btn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor popHighlightColor];
        [self addSubview:btn];
    }
    return _voteBtn;
}

- (void)setStatus:(StatusModel *)status {
    _status = status;
    [self setNeedsLayout];
}

- (void)setupVoteUI {
    if (self.status) {
        VoteModel *vote = self.status.vote;
        NSUInteger count = vote.vote_option.count;
        NSUInteger totalCount = vote.vote_count;
        NSUInteger index = 0;
        CGFloat optionViewX = 2;
        CGFloat optionViewY = 0;
        CGFloat optionViewW = self.frame.size.width - 2 * optionViewX;
        CGFloat optionViewH = kVoteOptionH;
        for (ZGVoteOptionView *optionView in self.subviews) {
            if(index < count) {
                optionView.hidden = NO;
                [optionView updateUIWithTitle:vote.vote_option[index] optionCount:[vote.vote_result[index] integerValue] totalCount:totalCount];
                optionViewY = index * optionViewH + index * kVoteOptionMargin;
                optionView.frame = CGRectMake(optionViewX, optionViewY, optionViewW, optionViewH);
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
            index++;
            
        }
        if (self.status.vote.me_is_vote) {
            self.voteBtn.hidden = YES;
        } else {
            self.voteBtn.hidden = NO;
            self.voteBtn.bounds = CGRectMake(0, 0, kVoteBtnW, kVoteBtnH);
            self.voteBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - kVoteBtnH * 0.5);
        }
    }
    
}

+ (CGSize)sizeWithStatus:(StatusModel *)status {
    NSUInteger voteItemCount = status.vote.vote_option.count;
    CGFloat voteH = voteItemCount * kVoteOptionH + (voteItemCount - 1) * kVoteOptionMargin;
    if (status.vote.me_is_vote == NO) {
        voteH += kVoteOptionMargin + kVoteBtnH;
    }
    return CGSizeMake(kMaxW, voteH);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupVoteUI];
}

@end
