//
//  ZGOtherProfileView.h
//  Yeps
//
//  Created by weimi on 16/4/24.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
@interface ZGOtherProfileHeaderView : UIView

@property (nonatomic, strong) UserInfoModel *userInfo;

+ (instancetype)headerView;

- (void)miniStyle;
- (void)fullStyle;
- (void)update;
@end
