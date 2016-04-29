//
//  ZGOtherProfileView.m
//  Yeps
//
//  Created by weimi on 16/4/24.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileHeaderView.h"
#import "ZGProfileHeaderViewButton.h"
#import "ZGProfileTool.h"
#import <UIImageView+WebCache.h>
#import "UserInfoModel.h"
#import "UserTool.h"
#import "ZGOtherProfileScrollView.h"

@interface ZGOtherProfileHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet ZGOtherProfileScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *photoBtn;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *followBtn;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *fansBtn;

@property (weak, nonatomic) IBOutlet ZGProfileHeaderViewButton *statusBtn;

@end

@implementation ZGOtherProfileHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

+ (instancetype)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZGOtherProfileHeaderView" owner:nil options:nil] firstObject];
}

-  (void)setup {
    self.followBtn.type = ZGProfileHeaderViewButtonTypeFollow;
    self.fansBtn.type = ZGProfileHeaderViewButtonTypeFans;
    self.statusBtn.type = ZGProfileHeaderViewButtonTypeStatus;
    self.photoBtn.type = ZGProfileHeaderViewButtonTypePhoto;
    
    [self.followBtn addTarget:self action:@selector(headerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.fansBtn addTarget:self action:@selector(headerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.statusBtn addTarget:self action:@selector(headerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoBtn addTarget:self action:@selector(headerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.photoBtn.enabled = NO;
    
}

- (void)headerViewBtnClick:(ZGProfileHeaderViewButton *)btn {
    if ([self.delegate respondsToSelector:@selector(OtherProfileHeaderViewHeaderViewButtonDidClick:btn:)]) {
        [self.delegate OtherProfileHeaderViewHeaderViewButtonDidClick:self btn:btn];
    }
}

- (void)miniStyle {
    
//    self.layer.shadowOffset = CGSizeMake(0, 1);
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 1.0;
    
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.scrollView.userInteractionEnabled = NO;
    self.btnView.userInteractionEnabled = NO;
}

- (void)fullStyle {
    self.layer.cornerRadius = 0;
    self.scrollView.userInteractionEnabled = YES;
    self.btnView.userInteractionEnabled = YES;
}

- (void)update {
    self.scrollView.userInfo = self.userInfo;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.userInfo.image_list firstObject]] placeholderImage:[ZGProfileTool profileBackImageWithPhone:self.userInfo.phone]];
    
    [self.photoBtn setCount:self.userInfo.status_image_count];
    [self.followBtn setCount:self.userInfo.follow_count];
    [self.fansBtn setCount:self.userInfo.fans_count];
    [self.statusBtn setCount:self.userInfo.status_count];
    if (self.userInfo == nil) {
        self.scrollView.hidden = YES;
        self.btnView.hidden = YES;
    } else {
        self.scrollView.hidden = NO;
        self.btnView.hidden = NO;
    }
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    [self update];
}


@end
