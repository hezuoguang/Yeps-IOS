//
//  ZGMaskView.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGMaskView.h"

@implementation ZGMaskView

- (void)setup {
    self.alpha = 0.45;
    self.backgroundColor = [UIColor colorWithR:0 g:0 b:0 alpha:0.45];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

@end
