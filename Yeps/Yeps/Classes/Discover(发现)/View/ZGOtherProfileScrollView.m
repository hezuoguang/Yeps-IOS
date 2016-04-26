//
//  ZGOtherProfileScrollView.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileScrollView.h"
#import "ZGOtherProfileScrollFirstView.h"
#import "ZGOtherProfileScrollSecondView.h"

@interface ZGOtherProfileScrollView()

@property (nonatomic, weak) ZGOtherProfileScrollFirstView *firstView;

@property (nonatomic, weak) ZGOtherProfileScrollSecondView *secondView;

@end

@implementation ZGOtherProfileScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (ZGOtherProfileScrollFirstView *)firstView {
    if (_firstView == nil) {
        ZGOtherProfileScrollFirstView *view = [ZGOtherProfileScrollFirstView initView];
        _firstView = view;
        _firstView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 54);
        [self addSubview:view];
    }
    return _firstView;
}

- (ZGOtherProfileScrollSecondView *)secondView {
    if (_secondView == nil) {
        ZGOtherProfileScrollSecondView *view = [ZGOtherProfileScrollSecondView initView];
        _secondView = view;
        _secondView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height - 54);;
        [self addSubview:view];
    }
    return _secondView;
}

- (void)setup {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(2 * self.frame.size.width, 0);
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    self.firstView.userInfo = userInfo;
    self.secondView.userInfo = userInfo;
    [self setNeedsLayout];
}

- (void)updateSubViews {
    CGFloat W = self.bounds.size.width;
    if (W != self.secondView.frame.origin.x) {
        CGFloat H = self.bounds.size.height - 54;
        self.firstView.frame = CGRectMake(0, 0, W, H);
        self.secondView.frame = CGRectMake(W, 0, W, H);
        self.contentSize = CGSizeMake(2 * W, 0);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubViews];
}



@end
