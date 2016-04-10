//
//  ZGPostCommentView.m
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPostCommentView.h"
#import "ZGEditTextView.h"
#import <pop/POP.h>

#define kLeftRightPadding 10
#define kMarginY (kLeftRightPadding + 64)

@interface ZGPostCommentView()<UITextViewDelegate>

@property (nonatomic, weak) UIView *commentView;
@property (nonatomic, weak) ZGEditTextView *textView;
@property (nonatomic, assign) BOOL canClose;
@property (nonatomic, assign) CGFloat showY;
@property (nonatomic, weak) UIButton *sendBtn;

@end

@implementation ZGPostCommentView

+ (instancetype)shareInstance {
    static ZGPostCommentView *_shareCommentView = nil;
    if (_shareCommentView == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareCommentView = [[ZGPostCommentView alloc] init];
        });
    }
    return _shareCommentView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap0];
        
        UIView *commentView = [[UIView alloc] init];
        commentView.backgroundColor = [UIColor whiteColor];
        commentView.layer.shadowColor = [UIColor popBorderColor].CGColor;
        commentView.layer.shadowOpacity = 0.9;
        commentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.commentView = commentView;
        [self addSubview:commentView];
        CGFloat headW = CGRectGetWidth(self.frame) - 2 * kLeftRightPadding;
        CGFloat headH = 44;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headW, headH)];
        headView.backgroundColor = [UIColor popBackGroundColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
        [headView addGestureRecognizer:tap];
        [commentView addSubview:headView];
        
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, headH)];
        closeBtn.backgroundColor = [UIColor redColor];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:closeBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headW, headH)];
        titleLabel.text = @"添加评论";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [headView addSubview:titleLabel];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(headW - 60, 0, 60, headH)];
        sendBtn.backgroundColor = [UIColor redColor];
        sendBtn.enabled = NO;
        self.sendBtn = sendBtn;
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:sendBtn];
        
        ZGEditTextView *textView = [[ZGEditTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), headW, 45)];
        textView.minHeight = textView.font.lineHeight * 8;
        textView.maxHeight = textView.minHeight;
        self.textView = textView;
        textView.delegate = self;
        textView.placeholder = @"我来说两句";
        [commentView addSubview:textView];
        
        commentView.frame = CGRectMake(kLeftRightPadding, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame) - 2 * kLeftRightPadding, CGRectGetMaxY(textView.frame));
        
        self.showY = kMarginY + self.commentView.frame.size.height * 0.5;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)nothing {
    
}

- (void)keyboardShow:(NSNotification *)noti {
    if (self.textView.isFirstResponder) {
        CGRect frame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat height = self.commentView.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.commentView.frame = CGRectMake(self.commentView.frame.origin.x, CGRectGetMinY(frame) - height - kLeftRightPadding, self.commentView.frame.size.width, height);
        }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self send];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.sendBtn.enabled = textView.text.length > 0;
}

- (void)setStatus_sha1:(NSString *)status_sha1 {
    if (![_status_sha1 isEqualToString:status_sha1]) {
        self.textView.text = @"";
    }
    _status_sha1 = [status_sha1 copy];
}

- (NSString *)comment_sha1 {
    if (_comment_sha1 == nil) {
        return @"";
    }
    return _comment_sha1;
}

- (void)show {
    self.canClose = NO;
    [self.commentView.layer pop_removeAllAnimations];
    POPBasicAnimation *anim0 = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim0.duration = 0.1;
    anim0.toValue = @(0.0);
    [self.commentView.layer pop_addAnimation:anim0 forKey:kPOPLayerRotation];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springSpeed = 13;
    anim.springBounciness = 15;
    anim.fromValue = @(-self.commentView.frame.size.height);
    anim.toValue = @(self.showY);
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            self.canClose = YES;
            [self.textView becomeFirstResponder];
        }
    };
    [self.commentView.layer pop_addAnimation:anim forKey:kPOPLayerPositionY];
}

- (void)send {
    __weak typeof(self) weak = self;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak close];
    });
    [YepsSDK publishComment:weak.textView.text comment_sha1:weak.comment_sha1 status_sha1:weak.status_sha1 success:^(id data) {
        if (weak.commentSuccessBlock) {
            weak.commentSuccessBlock(data);
        }
        [SVProgressHUD dismiss];
        weak.textView.text = @"";
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak show];
        });
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论失败" maskType:SVProgressHUDMaskTypeGradient];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak show];
        });
    }];
}

- (void)close {
    if (!self.canClose) {
        return;
    }
    [self endEditing:YES];
    
    POPSpringAnimation *anim0 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    anim0.toValue = @(M_PI_4);
    anim0.springSpeed = 13;
    anim0.autoreverses = YES;
    anim0.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    };
    [self.commentView.layer pop_addAnimation:anim0 forKey:kPOPLayerRotation];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anim.springSpeed = 18;
    anim.springBounciness = 0;
    anim.toValue = @(CGRectGetMaxY(self.frame) + CGRectGetHeight(self.commentView.frame));
    [self.commentView.layer pop_addAnimation:anim forKey:kPOPLayerPositionY];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
