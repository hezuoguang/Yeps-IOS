//
//  ZGMessageCell.h
//  Yeps
//
//  Created by weimi on 16/4/28.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGMessageModel;
@interface ZGMessageCell : UITableViewCell

@property (nonatomic, strong) ZGMessageModel *model;

+ (instancetype)initWithTableView:(UITableView *)tableView;

@end
