//
//  ZGPrefileTipLabel.m
//  Yeps
//
//  Created by weimi on 16/4/22.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPrefileTipLabel.h"

@implementation ZGPrefileTipLabel

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
