//
//  ZGFollowButton.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGFollowButton.h"
#import "UserInfoModel.h"

@implementation ZGFollowButton


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setUserInfo:(UserBaseInfoModel *)userInfo {
    _userInfo = userInfo;
    self.selected = userInfo.is_follow;
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted {
//    if (highlighted) {
//        self.backgroundColor = [UIColor popColor];
//    } else {
//        self.backgroundColor = [UIColor popFontColor];
//    }
}

- (void)setup {
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self setTitleColor:[UIColor popNavFontColor] forState:UIControlStateNormal];
    self.backgroundColor = [UIColor popFontColor];
    [self setBackgroundImage:[UIColor imageWithColor:[UIColor popBorderColor] size:CGSizeMake(5, 5)] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIColor imageWithColor:[UIColor popColor] size:CGSizeMake(5, 5)] forState:UIControlStateNormal];

    [self setTitle:@"加关注" forState:UIControlStateNormal];
    [self setTitle:@"已关注" forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"add_user"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"comfirm_user"] forState:UIControlStateSelected];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    [self addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateSubviews];
}

- (void)followBtnClick {
    self.userInteractionEnabled = NO;
    if (self.selected) {
        [YepsSDK removeFollow:self.userInfo.user_sha1 success:^(id data) {
            self.selected = !self.selected;
            self.userInteractionEnabled = YES;
            self.userInfo.is_follow = NO;
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
            self.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeGradient];
            self.userInteractionEnabled = YES;
        }];
    } else {
        [YepsSDK follow:self.userInfo.user_sha1 success:^(id data) {
            self.selected = !self.selected;
            self.userInteractionEnabled = YES;
            self.userInfo.is_follow = YES;
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
            self.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeGradient];
            self.userInteractionEnabled = YES;
        }];
    }
}

- (void)updateSubviews {
    CGFloat maxW = self.frame.size.width;
    CGFloat totalW = self.titleLabel.frame.size.width + self.imageView.frame.size.width + 5;
    CGFloat X = (maxW - totalW) * 0.5;
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = X;
    self.titleLabel.frame = titleFrame;
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = CGRectGetMaxX(self.titleLabel.frame) + 5;
    self.imageView.frame = imageFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubviews];
}

@end
