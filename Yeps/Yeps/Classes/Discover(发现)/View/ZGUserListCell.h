//
//  ZGUserListCell.h
//  Yeps
//
//  Created by weimi on 16/4/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KZGUserListCellHeight 60

@class UserBaseInfoModel;
@interface ZGUserListCell : UITableViewCell

+ (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UserBaseInfoModel *userBaseInfo;

@end
