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
