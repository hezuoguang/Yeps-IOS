//
//  ZGTabBar.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGTabBar.h"

@interface ZGTabBar()
@property (nonatomic, weak) UIButton *publishBtn;
@end

@implementation ZGTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
        [publishBtn setBackgroundImage:[UIImage imageNamed:@"Add_s"] forState:UIControlStateHighlighted];
        publishBtn.bounds = CGRectMake(0, 0, publishBtn.currentBackgroundImage.size.width, publishBtn.currentBackgroundImage.size.height);
        [publishBtn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishBtn];
        self.publishBtn = publishBtn;
    }
    return self;
    
}

- (void)publishBtnClick{
    NSLog(@"publishBtnClick");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    设置发布按钮frame
    self.publishBtn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    CGFloat btnW = self.frame.size.width / 5.0;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat index = 0;
    for (UIView *btn in self.subviews) {
        if ([btn isKindOfClass:[UIControl class]] && btn != self.publishBtn) {
            btnX = index * btnW;
            btn.frame = CGRectMake(btnX , btnY, btnW, btnH);
            index++;
            if (index == 2) {
                index++;
            }
        }
    }
}

@end
