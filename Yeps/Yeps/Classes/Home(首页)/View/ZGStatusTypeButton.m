//
//  ZGStatusTypeButton.m
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusTypeButton.h"

@implementation ZGStatusTypeButton

+ (instancetype)initWithTitle:(NSString *)title {
    ZGStatusTypeButton *btn = [[ZGStatusTypeButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor popNavFontColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor popColor] forState:UIControlStateSelected];
    btn.contentMode = UIViewContentModeCenter;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

@end
