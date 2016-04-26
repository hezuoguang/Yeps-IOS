//
//  ZGOtherProfileCollectionHeaderView.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileCollectionHeaderView.h"
#import "ZGOtherProfileHeaderView.h"
#import "UserInfoModel.h"

@interface ZGOtherProfileCollectionHeaderView()

@property (weak, nonatomic) ZGOtherProfileHeaderView *headerView;


@end

@implementation ZGOtherProfileCollectionHeaderView

- (ZGOtherProfileHeaderView *)headerView {
    if (_headerView == nil) {
        ZGOtherProfileHeaderView *headerView = [ZGOtherProfileHeaderView headerView];
        [self addSubview:headerView];
        _headerView = headerView;
    }
    return _headerView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    self.headerView.userInfo = userInfo;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerView.frame = self.bounds;
}

@end
