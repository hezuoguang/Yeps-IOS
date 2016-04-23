//
//  ZGProfileSettingItemCell.h
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGProfileSettingItemModel, ZGProfileSettingItemCell;

@protocol ZGProfileSettingItemCellDelegate <NSObject>

@optional
- (void)profileSettingItemCellDidClick:(ZGProfileSettingItemCell *)cell;

@end

@interface ZGProfileSettingItemCell : UIButton

@property (nonatomic, strong) ZGProfileSettingItemModel *model;
@property (nonatomic, weak) id<ZGProfileSettingItemCellDelegate> delegate;

@end
