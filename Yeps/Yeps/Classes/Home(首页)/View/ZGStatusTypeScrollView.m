//
//  ZGStatusTypeScrollView.m
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusTypeScrollView.h"
#import "StatusModel.h"
#import "ZGStatusTypeButton.h"

@interface ZGStatusTypeScrollView()

@property (nonatomic, weak) UIView *tipView;

@end

@implementation ZGStatusTypeScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        NSInteger index = 0;
        for (NSString *title in kTypeStrs) {
            ZGStatusTypeButton *btn = [ZGStatusTypeButton initWithTitle:title];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = index;
            [self addSubview:btn];
            if (index == 0) {
                btn.selected = YES;
            }
            index++;
            [self addSubview:btn];
        }
        UIView *tipView = [[UIView alloc] init];
        tipView.backgroundColor = [UIColor popColor];
        [self addSubview:tipView];
        self.tipView = tipView;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setSelectType:(NSInteger)type {
    NSInteger index = 0;
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[ZGStatusTypeButton class]]) {
            continue;
        }
        if (index == type) {
            ZGStatusTypeButton *button = (ZGStatusTypeButton *)view;
            [self btnClick:button];
        }
        index++;
    }
}

- (void)btnClick:(UIButton *)btn {
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[ZGStatusTypeButton class]]) {
            continue;
        }
        ZGStatusTypeButton *button = (ZGStatusTypeButton *)view;
        if (button.selected && btn == button) {
            return;
        } else {
            button.selected = NO;
        }
    }
    btn.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        if (self.contentOffset.x > CGRectGetMinX(btn.frame)) {
            self.contentOffset = CGPointMake(CGRectGetMinX(btn.frame), 0);
        } else if (CGRectGetMaxX(btn.frame) >= self.frame.size.width) {
            self.contentOffset = CGPointMake(CGRectGetMinX(btn.frame) - self.frame.size.width + btn.frame.size.width, 0);
        }
        self.tipView.center = CGPointMake(btn.center.x, self.tipView.center.y);
    }];
    
    if (self.didSelectType) {
        self.didSelectType(btn.tag);
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat H = self.bounds.size.height;
    CGFloat W = 60;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat padding = 0;
    self.tipView.bounds = CGRectMake(0, 0, W, 1);
    self.tipView.center = CGPointMake(W * 0.5, H);
    self.contentSize = CGSizeMake(2 * padding + kTypeStrs.count * W, 0);
    NSInteger index = 0;
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[ZGStatusTypeButton class]]) {
            continue;
        }
        ZGStatusTypeButton *button = (ZGStatusTypeButton *)view;
        X = index * W + padding;
        button.frame = CGRectMake(X, Y, W, H);
        if (button.selected) {
            self.tipView.center = CGPointMake(button.center.x, self.tipView.center.y);
        }
        index++;
    }
}


@end
