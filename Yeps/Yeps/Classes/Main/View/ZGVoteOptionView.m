//
//  ZGVoteOptionView.m
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGVoteOptionView.h"

@interface ZGVoteOptionView()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, assign) CGFloat pe;

@end

@implementation ZGVoteOptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] init];
        self.backgroundColor = [UIColor popBorderColor];
        self.backView = view;
        self.backView.backgroundColor = [UIColor popMaskColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
        [self insertSubview:view atIndex:0];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backView.alpha = 0.8;
        self.backgroundColor = [UIColor popBackGroundColor];
    } else {
        self.backView.alpha = 1.0;
        self.backgroundColor = [UIColor popBorderColor];
    }
}

- (void)updateUIWithTitle:(NSString *)title optionCount:(NSInteger)optionCount totalCount:(NSInteger)totalCount {
    
    [self setTitle:[NSString stringWithFormat:@"%@(%zd/%zd)", title, optionCount, totalCount] forState:UIControlStateNormal];
    if (totalCount <= 0 || optionCount <= 0) {
        self.pe = 0.01;
    } else {
        self.pe = (optionCount * 1.0) / (totalCount * 1.0) + 0.01;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxW = self.frame.size.width;
    CGFloat maxH = self.frame.size.height;
    self.titleLabel.frame = CGRectMake(5, 0, maxW, maxH);
    self.imageView.frame = CGRectMake(maxW - 40, 0, 40, maxH);
    self.backView.frame = CGRectMake(0, 0, (maxW - 40) * self.pe, maxH);
}

@end
