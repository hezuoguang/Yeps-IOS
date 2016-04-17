//
//  ZGProfileHeaderViewButton.m
//  Yeps
//
//  Created by weimi on 16/4/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileHeaderViewButton.h"

@interface ZGProfileHeaderViewButton()

@property (nonatomic, weak) UILabel *numberLabel;

@end

@implementation ZGProfileHeaderViewButton

- (void)setup {
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor popColor] forState:UIControlStateHighlighted];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.numberLabel.textColor = [UIColor popColor];
    } else {
        self.numberLabel.textColor = [UIColor whiteColor];
    }
}

- (void)setCount:(NSInteger)count {
    self.numberLabel.text = [NSString stringWithFormat:@"%zd", count];
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"0";
        _numberLabel = label;
        [self addSubview:label];
    }
    return _numberLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat H = frame.size.height;
    self.numberLabel.frame = CGRectMake(0, 0, frame.size.width, H * 0.5);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame), frame.size.width, H * 0.5);
}

@end
