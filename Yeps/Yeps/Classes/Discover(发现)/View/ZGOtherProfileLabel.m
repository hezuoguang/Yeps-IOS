//
//  ZGOtherProfileLabel.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileLabel.h"

@implementation ZGOtherProfileLabel

- (void)setup{
    self.font = [UIFont systemFontOfSize:15];
    self.textColor = [UIColor popNavFontColor];
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
