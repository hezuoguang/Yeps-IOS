//
//  ZGPickImageView.m
//  Yeps
//
//  Created by weimi on 16/3/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPickImageView.h"

@interface ZGPickImageView()

@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation ZGPickImageView

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"close_icon_h"] forState:UIControlStateHighlighted];
        [self addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(pickImageViewDidClickDeleteBtn:)]) {
        [self.delegate pickImageViewDidClickDeleteBtn:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.deleteBtn.frame = CGRectMake(self.bounds.size.width - 30, 0, 30, 30);
}

@end
