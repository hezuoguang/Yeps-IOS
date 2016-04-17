//
//  ZGProfileHeaderView.m
//  Yeps
//
//  Created by weimi on 16/4/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileHeaderView.h"
#import "ZGPhotoView.h"
#import "ZGProfileHeaderViewButton.h"
#import "UserInfoModel.h"
#import "ZGImageView.h"

#import <UIImageView+WebCache.h>
#import <objc/runtime.h>

@interface ZGProfileHeaderView()

@property (weak, nonatomic) IBOutlet ZGImageView *imageView;

@property (weak, nonatomic) IBOutlet ZGPhotoView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *followBtn;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *fansBtn;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *statusBtn;

@end

@implementation ZGProfileHeaderView

+ (instancetype)profileHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZGProfileHeaderView" owner:nil options:nil] lastObject];
}

- (void)setup {
    self.nickLabel.font = [UIFont systemFontOfSize:17];
    self.introLabel.font = [UIFont systemFontOfSize:16];
}

- (void)setNickLabelStatus:(BOOL)hide {
    self.nickLabel.hidden = hide;
}

- (BOOL)nickLabelStatus {
    return self.nickLabel.hidden;
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    if (!objc_getAssociatedObject(self, _cmd)) {
        [self setup];
        objc_setAssociatedObject(self, _cmd, @"ZGProfileHeaderView", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:userInfo.photo] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.nickLabel.text = userInfo.nick;
    self.introLabel.text = userInfo.intro;
    
    [self.followBtn setCount:userInfo.follow_count];
    [self.fansBtn setCount:userInfo.fans_count];
    [self.statusBtn setCount:userInfo.status_count];

}

@end
