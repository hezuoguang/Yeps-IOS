//
//  ZGButton.m
//  Yeps
//
//  Created by weimi on 16/3/12.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGCellToolButton.h"

@implementation ZGCellToolButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
        UIEdgeInsets titleEdgeInsets = self.titleEdgeInsets;
        titleEdgeInsets.left += 8;
        self.titleEdgeInsets = titleEdgeInsets;
        UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
        imageEdgeInsets.right += 8;
        self.imageEdgeInsets = imageEdgeInsets;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
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
