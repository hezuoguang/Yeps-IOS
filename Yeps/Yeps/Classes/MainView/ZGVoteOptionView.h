//
//  ZGVoteOptionView.h
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGVoteOptionView : UIButton

- (void)updateUIWithTitle:(NSString *)title optionCount:(NSInteger)optionCount totalCount:(NSInteger)totalCount;

@end
