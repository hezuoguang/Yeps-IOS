//
//  ZGCreateVoteView.m
//  Yeps
//
//  Created by weimi on 16/4/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGCreateVoteView.h"
#import "ZGCreateVoteOptionView.h"
#import "NSString+Extension.h"

@interface ZGCreateVoteView()

@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, strong) NSMutableArray *options;

@end

@implementation ZGCreateVoteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addOption];
        [self addOption];
    }
    return self;
}

- (CGFloat)inputFieldMinY {
    for (NSInteger i = 0; i < self.options.count; i++) {
        ZGCreateVoteOptionView *option = self.options[i];
        if ([option isFirstResponse]) {
            return CGRectGetMinY(self.frame) + CGRectGetMinY(option.frame);
        }
    }
    return CGRectGetMinY(self.frame);
}

- (NSArray *)voteOptions {
    NSMutableArray *array = [NSMutableArray array];
    for (ZGCreateVoteOptionView *option in self.options) {
        NSString *text = [[option option] trimSpace];
        [array addObject:text];
    }
    return array;
}

- (BOOL)validate {
    for (ZGCreateVoteOptionView *option in self.options) {
        NSString *text = [[option option] trimSpace];
        if (text == nil || text.length == 0) {
            return NO;
        }
    }
    return YES;
}

- (void)addOption {
    ZGCreateVoteOptionView *option = [[ZGCreateVoteOptionView alloc] init];
    __weak typeof(self) weakSelf = self;
    option.deleteButtonDidClick = ^(ZGCreateVoteOptionView *optionView) {
        [weakSelf.options removeObject:optionView];
        [optionView removeFromSuperview];
    };
    [self.options addObject:option];
    [self addSubview:option];
}

- (UIButton *)addButton {
    if (_addButton == nil) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"添加选项" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor popFontColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor popHighlightColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(addOption) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _addButton = button;
    }
    return _addButton;
}

- (NSMutableArray *)options {
    if (_options == nil) {
        _options = [NSMutableArray array];
    }
    return _options;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxW = self.frame.size.width;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = maxW;
    CGFloat H = 44;
    NSInteger count = self.options.count;
    BOOL enable = count > 2;
    NSInteger index = 0;
    for (ZGCreateVoteOptionView *option in self.options) {
        Y = (H + 2) * index + 2;
        option.frame = CGRectMake(X, Y, W, H);
        [option setDeleteButtonEnable:enable];
        index++;
    }
    if (count >= 10) {
        self.addButton.hidden = YES;
       
    } else {
        self.addButton.hidden = NO;
        Y = (H + 2) * index + 2;
        self.addButton.frame = CGRectMake(X, Y, W, H);
    }
    if (self.frame.size.height != Y + 2 + H) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, maxW, Y + 2 + H);
        if (self.frameDidChange) {
            self.frameDidChange();
        }
    }
    
}

@end
