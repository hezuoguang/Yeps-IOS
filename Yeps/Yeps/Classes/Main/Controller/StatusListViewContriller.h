//
//  StatusListViewContriller.h
//  Yeps
//
//  Created by weimi on 16/4/26.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel;
@interface StatusListViewContriller : UIViewController

//@property (nonatomic, copy) NSString *user_sha1;
@property (nonatomic, strong) UserInfoModel *userInfo;

@end
