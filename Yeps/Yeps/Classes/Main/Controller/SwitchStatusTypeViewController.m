//
//  SwitchStatusTypeViewController.m
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "SwitchStatusTypeViewController.h"
#import "ZGSwitchStatusTypeButton.h"
#import <pop/POP.h>

@interface SwitchStatusTypeViewController()

@property (nonatomic, weak) UIButton *closeBtn;
@property (nonatomic, weak) UILabel *label;

@end

@implementation SwitchStatusTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger count = kTypeStrs.count;
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = kZGSwitchStatusTypeButtonW;
    CGFloat H = kZGSwitchStatusTypeButtonH;
    for (NSInteger i = 0; i < count; i++) {
        ZGSwitchStatusTypeButton *btn = [[ZGSwitchStatusTypeButton alloc] init];
        btn.type = i;
        X = (i % 3) * W + ((i % 3) + 1) * kZGSwitchStatusTypeButtonMargin;
        Y = - 3 * H;
        btn.frame = CGRectMake(X, Y, W, H);
        btn.hidden = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    self.closeBtn = closeBtn;
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    closeBtn.bounds = CGRectMake(0, 0, closeBtn.currentBackgroundImage.size.width, closeBtn.currentBackgroundImage.size.height);
    closeBtn.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - closeBtn.bounds.size.height * 0.5 - 5);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.userInteractionEnabled = NO;
    [self.view addSubview:closeBtn];
    
    CGFloat baseY = self.view.center.y - kZGSwitchStatusTypeButtonH * 0.7;
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Yeps, 一见倾心";
    label.alpha = 1.0;
    label.textColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:21];
    label.frame = CGRectMake(0, baseY - H * 0.5 - 30 * [UIScreen mainScreen].scale / 2, self.view.bounds.size.width, 60);
    self.label = label;
    [self.view addSubview:label];
    
}

- (void)btnClick:(ZGSwitchStatusTypeButton *)btn {
    self.view.userInteractionEnabled = NO;
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    anim.toValue = [NSValue valueWithCGSize:CGSizeMake(1.25, 1.25)];
    anim.duration = 0.15;
    anim.completionBlock = ^(POPAnimation *anim, BOOL flag) {
        if (flag) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    };
    [btn.layer pop_addAnimation:anim forKey:kPOPLayerScaleXY];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showAnima];
}

- (void)showAnima {
    CGFloat H = kZGSwitchStatusTypeButtonH;
    CGFloat maxH = self.view.bounds.size.height;
    CGFloat baseY = self.view.center.y - kZGSwitchStatusTypeButtonH * 0.7;
    CGFloat FY = 0;
    CGFloat TY = 0;
    NSInteger i = 0;
    CGFloat offsetY = H;
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[ZGSwitchStatusTypeButton class]]) {
            if (view == self.closeBtn) {
                POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
                rotationAnimation.beginTime = CACurrentMediaTime() + 0.1;
                rotationAnimation.toValue = @(M_PI_4);
                rotationAnimation.springBounciness = 13.0;
                rotationAnimation.springSpeed = 3;
                [view.layer pop_addAnimation:rotationAnimation forKey:kPOPLayerRotation];
            } else if (view == self.label) {
                POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
                anim.beginTime = CACurrentMediaTime() + 0.25;
                anim.duration = 1.0;
                anim.fromValue = [UIColor clearColor];
                anim.toValue = [UIColor popColor];
                [self.label pop_addAnimation:anim forKey:kPOPViewAlpha];
            }
            continue;
        }
        FY = maxH + offsetY;
        TY = (i / 3) * H + baseY + H * 0.5;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//        anim.velocity = @(1000.0);
        anim.fromValue = @(FY);
        anim.toValue = @(TY);
        anim.springSpeed = 13;
        anim.springBounciness = 8;
        anim.beginTime = CACurrentMediaTime() + i * 1.0 / 20;
        if (i == 5) {
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    self.closeBtn.userInteractionEnabled = YES;
                }
            };
        }
        view.hidden = NO;
        [view.layer pop_addAnimation:anim forKey:kPOPLayerPositionY];
        i++;
    }
}

- (void)dismissAnima {
    CGFloat H = kZGSwitchStatusTypeButtonH;
    CGFloat maxH = self.view.bounds.size.height;
    CGFloat baseY = self.view.center.y - kZGSwitchStatusTypeButtonH * 0.7;
    CGFloat FY = 0;
    CGFloat TY = 0;
    NSInteger i = 0;
    CGFloat offsetY = H;
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[ZGSwitchStatusTypeButton class]]) {
            if (view == self.closeBtn) {
                POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
                rotationAnimation.beginTime = CACurrentMediaTime() + 0.1;
                rotationAnimation.toValue = @(0);
                rotationAnimation.springBounciness = 12.0;
                rotationAnimation.springSpeed = 5;
                [view.layer pop_addAnimation:rotationAnimation forKey:kPOPLayerRotation];
            } else if (view == self.label) {
                POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                anim.beginTime = CACurrentMediaTime() + 0.2;
                anim.toValue = @(0.1);
                [self.label pop_addAnimation:anim forKey:kPOPViewAlpha];
            }
            continue;
        }
        TY = maxH + offsetY;
        FY = (i / 3) * H + baseY + H * 0.5;
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//        anim.velocity = @(2000.0);
        anim.fromValue = @(FY);
        anim.toValue = @(TY);
        anim.springSpeed = 20;
        anim.springBounciness = 1;
        anim.beginTime = CACurrentMediaTime() + (6 - i) * 1.0 / 20;
        if (i == 3) {
            anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
                if (finished) {
                    [self dismissViewControllerAnimated:NO completion:nil];
                }
            };
        }
        view.hidden = NO;
        [view.layer pop_addAnimation:anim forKey:kPOPLayerPositionY];
        i++;
    }
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.toValue = @(0.9);
    [self.view pop_addAnimation:anim forKey:kPOPViewAlpha];
    
}

- (void)closeBtnClick {
    self.closeBtn.userInteractionEnabled = NO;
    [self dismissAnima];
}

@end
