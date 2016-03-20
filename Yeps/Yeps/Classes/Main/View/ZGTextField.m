//
//  ZGTextField.m
//  Yeps
//
//  Created by weimi on 16/3/3.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGTextField.h"


@implementation ZGTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:18.0];
        self.textColor = [UIColor popFontColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.tintColor = [UIColor popColor];
        self.borderStyle = UITextBorderStyleNone;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [[UIColor popBorderColor] setStroke];
    CGContextSetLineWidth(context, 1 / [UIScreen mainScreen].scale);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.frame));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGContextStrokePath(context);
    
}

@end
