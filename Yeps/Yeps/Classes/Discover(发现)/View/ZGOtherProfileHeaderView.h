//
//  ZGOtherProfileView.h
//  Yeps
//
//  Created by weimi on 16/4/24.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel, ZGOtherProfileHeaderView, ZGProfileHeaderViewButton;

@protocol ZGOtherProfileHeaderViewDelegate <NSObject>

@optional

- (void)OtherProfileHeaderViewHeaderViewButtonDidClick:(ZGOtherProfileHeaderView *)headerView btn:(ZGProfileHeaderViewButton *)btn;

@end

@interface ZGOtherProfileHeaderView : UIView

@property (nonatomic, weak) id<ZGOtherProfileHeaderViewDelegate> delegate;
@property (nonatomic, strong) UserInfoModel *userInfo;

+ (instancetype)headerView;

- (void)miniStyle;
- (void)fullStyle;
- (void)update;
@end
