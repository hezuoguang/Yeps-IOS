//
//  ZGCreateVoteView.h
//  Yeps
//
//  Created by weimi on 16/4/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGCreateVoteView : UIView

@property (nonatomic, strong) void(^frameDidChange)();

- (CGFloat)inputFieldMinY;

- (NSArray *)voteOptions;

- (BOOL)validate;

@end
