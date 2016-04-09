//
//  ZGShareView.m
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGShareView.h"
#import "ZGShareButton.h"
#import "ShareTool.h"

@interface ZGShareView()

@property (nonatomic, weak) UIView *shareView;

@end

@implementation ZGShareView

+ (instancetype)shareInstance {
    static ZGShareView *_shareShareView = nil;
    if(_shareShareView == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareShareView = [[ZGShareView alloc] init];
        });
    }
    return _shareShareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [self addGestureRecognizer:tap];
        
        CGFloat maxW = self.frame.size.width;
        UIView *shareView = [[UIView alloc] init];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
        [shareView addGestureRecognizer:tap1];
        shareView.backgroundColor = [UIColor whiteColor];
        shareView.layer.shadowOffset = CGSizeMake(0, -4);
        shareView.layer.shadowColor = [UIColor popBorderColor].CGColor;
        shareView.layer.shadowOpacity = 0.9;
        self.shareView = shareView;
        CGFloat W = kZGShareButtonW;
        CGFloat H = kZGShareButtonH;
        CGFloat X = 0;
        CGFloat Y = 0;
        for (NSInteger i = 0; i < 5; i++) {
            X = (i % 3) * W + ((i % 3) + 1) * kZGShareButtonMargin;
            Y = (i / 3) * (H + kZGShareButtonMargin) + kZGShareButtonMargin;
            ZGShareButton *btn = [[ZGShareButton alloc] initWithFrame:CGRectMake(X, Y, W, H)];
            btn.type = i;
            [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            [shareView addSubview:btn];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, Y + H, maxW, 44)];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:btn];
        shareView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), maxW, CGRectGetMaxY(btn.frame));
        [self addSubview:shareView];
    }
    return self;
}

- (void)show {
    self.userInteractionEnabled = NO;
    self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, CGRectGetMaxY(self.frame), self.shareView.frame.size.width, self.shareView.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat H = self.shareView.frame.size.height;
        self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, CGRectGetMaxY(self.frame) - H, self.shareView.frame.size.width, H);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)close {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.shareView.frame = CGRectMake(self.shareView.frame.origin.x, CGRectGetMaxY(self.frame), self.shareView.frame.size.width, self.shareView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)share:(ZGShareButton *)btn {
    [self shareWithType:btn.type success:^{
        if (self.shareSuccessBlock) {
            self.shareSuccessBlock();
        }
        [SVProgressHUD showSuccessWithStatus:@"分享成功" maskType:SVProgressHUDMaskTypeGradient];
        [self close];
    } error:^{
        [SVProgressHUD showErrorWithStatus:@"分享失败" maskType:SVProgressHUDMaskTypeGradient];
        [self close];
    } cancel:^{
//        [SVProgressHUD showErrorWithStatus:@"取消分享" maskType:SVProgressHUDMaskTypeGradient];
        [self close];
    }];
}

- (void)shareWithType:(ZGShareButtonType)type success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel {
    
    NSString *title = self.shareTitle;
    NSString *content = self.shareContent;
    NSString *url = self.shareUrl;
    id image = self.shareImage;
    
    if (type == ZGShareButtonTypeQQZone) {
        
        [ShareTool shareToQzone:content title:title image:image url:url success:success error:error cancel:cancel];
        
    } else if(type == ZGShareButtonTypeQQ) {
        
        [ShareTool shareToQQ:content title:title image:image url:url success:success error:error cancel:cancel];
        
    } else if(type == ZGShareButtonTypeWeChat) {
        
        [ShareTool shareToWeChat:content title:title image:image url:url success:success error:error cancel:cancel];
        
    } else if(type == ZGShareButtonTypeWeChatTimeline) {
        
        [ShareTool shareToWeChatTimeline:content title:title image:image url:url success:success error:error cancel:cancel];
        
    } else if(type == ZGShareButtonTypeWeiBo) {
        
        [ShareTool shareToWeiBo:content title:title image:image url:url success:success error:error cancel:cancel];
        
    }
}

- (void)nothing {
    
}

@end
