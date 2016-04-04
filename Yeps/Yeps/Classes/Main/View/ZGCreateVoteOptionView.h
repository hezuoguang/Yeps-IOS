//
//  ZGCreateVoteOptionView.h
//  Yeps
//
//  Created by weimi on 16/4/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGCreateVoteOptionView;
@interface ZGCreateVoteOptionView : UIView

@property (nonatomic, strong) void(^deleteButtonDidClick)(ZGCreateVoteOptionView *);

- (void)setDeleteButtonEnable:(BOOL)enable;
- (BOOL)isFirstResponse;
- (NSString *)option;
@end
