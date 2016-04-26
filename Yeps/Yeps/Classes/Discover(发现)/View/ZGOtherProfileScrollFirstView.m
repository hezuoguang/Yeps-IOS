//
//  ZGOtherProfileScrollFirstView.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileScrollFirstView.h"
#import "NSString+Extension.h"
#import "UserInfoModel.h"
#import "ZGOtherProfileLabel.h"
#import "ZGFollowButton.h"
#import "UserTool.h"

@interface ZGOtherProfileScrollFirstView()

@property (weak, nonatomic) IBOutlet ZGOtherProfileLabel *activeTimeLabel;

@property (weak, nonatomic) IBOutlet ZGOtherProfileLabel *universityLabel;

@property (weak, nonatomic) IBOutlet ZGOtherProfileLabel *infoLabel;

@property (weak, nonatomic) IBOutlet ZGOtherProfileLabel *nickLabel;

@property (weak, nonatomic) IBOutlet ZGFollowButton *followBtn;
@end

@implementation ZGOtherProfileScrollFirstView

+ (instancetype)initView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZGOtherProfileScrollFirstView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    [self.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)followBtnClick {
    self.followBtn.userInteractionEnabled = NO;
    if (self.followBtn.selected) {
        [YepsSDK removeFollow:self.userInfo.user_sha1 success:^(id data) {
            self.followBtn.selected = !self.followBtn.selected;
            self.followBtn.userInteractionEnabled = YES;
            self.userInfo.is_follow = NO;
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
            self.followBtn.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeGradient];
            self.followBtn.userInteractionEnabled = YES;
        }];
    } else {
        [YepsSDK follow:self.userInfo.user_sha1 success:^(id data) {
            self.followBtn.selected = !self.followBtn.selected;
            self.followBtn.userInteractionEnabled = YES;
            self.userInfo.is_follow = YES;
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
            self.followBtn.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"操作失败" maskType:SVProgressHUDMaskTypeGradient];
            self.followBtn.userInteractionEnabled = YES;
        }];
    }
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    [self update];
}

- (void)update {
    self.followBtn.userInfo = self.userInfo;
    self.activeTimeLabel.text = [self.userInfo.last_active_time timeStringWithCurrentTime];
    self.universityLabel.text = self.userInfo.university;
    if(self.userInfo.sex == nil) {
        self.userInfo.sex = @"未知";
    }
    self.infoLabel.text = [NSString stringWithFormat:@"%@, %zd岁", self.userInfo.sex, self.userInfo.age];
    self.nickLabel.text = self.userInfo.nick;
    if ([self.userInfo.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
        self.followBtn.hidden = YES;
    } else {
        self.followBtn.hidden = NO;
    }
}

@end
