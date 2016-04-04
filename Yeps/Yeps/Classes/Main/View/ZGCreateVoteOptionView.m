//
//  ZGCreateVoteOptionView.m
//  Yeps
//
//  Created by weimi on 16/4/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGCreateVoteOptionView.h"

@interface ZGCreateVoteOptionView()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, weak) UITextField *textField;

@end

@implementation ZGCreateVoteOptionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @"请输入选项内容";
        textField.font = [UIFont systemFontOfSize:14];
        textField.delegate = self;
        self.textField = textField;
        [self addSubview:textField];
        
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (str.length >= 18) {
        return NO;
    }
    return YES;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteBtn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor popFontDisableColor] forState:UIControlStateDisabled];
        [deleteBtn setTitleColor:[UIColor popHighlightColor] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn = deleteBtn;
        [self addSubview:_deleteBtn];
    }
    return _deleteBtn;
}

- (NSString *)option {
    return self.textField.text;
}

- (BOOL)isFirstResponse {
    return self.textField.isFirstResponder;
}

- (void)deleteBtnDidClick {
    if (self.deleteButtonDidClick) {
        __weak typeof(self) weakSelf = self;
        self.deleteButtonDidClick(weakSelf);
    }
}

- (void)setDeleteButtonEnable:(BOOL)enable {
    self.deleteBtn.enabled = enable;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxW = self.bounds.size.width;
    CGFloat maxH = self.bounds.size.height;
    CGFloat buttonW = 45;
    self.textField.frame = CGRectMake(10, 0, maxW - buttonW - 10, maxH);
    self.deleteBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame), 0, buttonW, maxH);
    
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor popBackGroundColor] setStroke];
//    CGContextSetLineWidth(context, 1 / [UIScreen mainScreen].scale);
//    CGContextMoveToPoint(context, 0, CGRectGetHeight(self.frame));
//    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//    CGContextStrokePath(context);
//}

@end
