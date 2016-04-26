//
//  ZGOtherProfileScrollFirstView.h
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
@interface ZGOtherProfileScrollFirstView : UIView

+ (instancetype)initView;

@property (nonatomic, strong) UserInfoModel *userInfo;

@end
