//
//  ZGStatusImageListView.h
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel;
@interface ZGStatusImageListView : UIView

@property (nonatomic, strong)StatusModel *status;

+ (CGSize)sizeWithStatus:(StatusModel *)status;

@end
