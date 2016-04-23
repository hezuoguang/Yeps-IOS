//
//  ZGProfileTextField.m
//  Yeps
//
//  Created by weimi on 16/4/22.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileTextField.h"

@implementation ZGProfileTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.font = [UIFont systemFontOfSize:15];
    self.textColor = [UIColor popFontColor];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

@end
