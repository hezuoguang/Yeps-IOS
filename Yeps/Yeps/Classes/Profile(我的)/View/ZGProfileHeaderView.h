//
//  ZGProfileHeaderView.h
//  Yeps
//
//  Created by weimi on 16/4/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoModel, ZGProfileHeaderView, ZGProfileHeaderViewButton;

@protocol ZGProfileHeaderViewDelegate <NSObject>

@optional

- (void)profileHeaderViewHeaderViewButtonDidClick:(ZGProfileHeaderView *)headerView btn:(ZGProfileHeaderViewButton *)btn;

@end

@interface ZGProfileHeaderView : UIView

@property (nonatomic, strong) UserInfoModel *userInfo;

@property (nonatomic, weak) id<ZGProfileHeaderViewDelegate> delegate;

+ (instancetype)profileHeaderView;

- (void)setNickLabelStatus:(BOOL)hide;

- (BOOL)nickLabelStatus;

/** 更新*/
- (void)update;

@end
