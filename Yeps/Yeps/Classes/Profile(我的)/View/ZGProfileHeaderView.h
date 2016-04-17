//
//  ZGProfileHeaderView.h
//  Yeps
//
//  Created by weimi on 16/4/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;

//@protocol  <NSObject>
//
//<#methods#>
//
//@end

@interface ZGProfileHeaderView : UIView

@property (nonatomic, strong) UserInfoModel *userInfo;

+ (instancetype)profileHeaderView;

- (void)setNickLabelStatus:(BOOL)hide;

- (BOOL)nickLabelStatus;

@end
