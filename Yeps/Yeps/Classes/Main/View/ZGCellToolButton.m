//
//  ZGButton.m
//  Yeps
//
//  Created by weimi on 16/3/12.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGButton.h"

@implementation ZGButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!highlighted) {
        self.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor popBorderColor];
    }
}

@end
