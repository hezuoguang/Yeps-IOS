//
//  StatusTableViewCell.h
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusFrameModel;
@interface ZGStatusCell : UITableViewCell

@property (nonatomic, strong) StatusFrameModel *statusF;


+ (instancetype)statusCellWithTableView:(UITableView *)tableView;

@end
