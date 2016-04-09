//
//  ZGShareButton.m
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGShareButton.h"

@implementation ZGShareButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor popColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}

- (void)setType:(ZGShareButtonType)type {
    _type = type;
    NSArray *icons = @[@"share_qzone", @"share_qq", @"share_wechat", @"share_wechat_timeline", @"share_weibo"];
    NSArray *title = @[@"QQ空间", @"QQ好友", @"微信好友", @"朋友圈", @"微博"];
    [self setTitle:title[type] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:icons[type]] forState:UIControlStateNormal];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxW = self.frame.size.width;
    CGFloat imageWH = 45;
    CGFloat labelH = 30;
    self.imageView.frame = CGRectMake((maxW - imageWH) * 0.5, 0, imageWH, imageWH);
    self.imageView.layer.cornerRadius = imageWH * 0.5;
    self.imageView.clipsToBounds = YES;
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), maxW, labelH);
    
}
@end
