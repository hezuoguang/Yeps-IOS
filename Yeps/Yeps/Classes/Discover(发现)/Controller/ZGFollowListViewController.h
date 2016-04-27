//
//  ZGFollowListViewController.h
//  Yeps
//
//  Created by weimi on 16/4/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserBaseInfoModel;
@interface ZGFollowListViewController : UIViewController

@property (nonatomic, assign) BOOL followMe;
@property (nonatomic, strong) UserBaseInfoModel *userBaseInfo;

@end
