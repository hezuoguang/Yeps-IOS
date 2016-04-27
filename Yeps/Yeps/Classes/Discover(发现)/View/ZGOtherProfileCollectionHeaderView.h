//
//  ZGOtherProfileCollectionHeaderView.h
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserInfoModel, ZGOtherProfileHeaderView;
@protocol ZGOtherProfileHeaderViewDelegate;
@interface ZGOtherProfileCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, weak) id<ZGOtherProfileHeaderViewDelegate> delegate;


@end
