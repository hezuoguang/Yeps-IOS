//
//  ZGPhotoView.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPhotoView.h"
#import "ZGOtherProfileViewController.h"
#import "UserInfoModel.h"
#import "UserBaseInfoModel.h"
#import <UIImageView+WebCache.h>
#import "MainTabBarController.h"
@implementation ZGPhotoView


- (void)setup {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self addGestureRecognizer:tap];
}

- (void)setUserBaseInfo:(UserBaseInfoModel *)userBaseInfo {
    _userBaseInfo = userBaseInfo;
    [self sd_setImageWithURL:[NSURL URLWithString:userBaseInfo.smallPhoto] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)click {
    
    ZGOtherProfileViewController *profileVC = [[ZGOtherProfileViewController alloc] init];
    UserInfoModel *userInfo = [UserInfoModel initWithBaseModel:self.userBaseInfo];
    profileVC.userInfo = userInfo;
    
    UIViewController *vc = [self getCurrentVC];
    UINavigationController *nav = nil;
    if ([vc isKindOfClass:[MainTabBarController class]]) {
        MainTabBarController *tab = (MainTabBarController *)vc;
        nav = (UINavigationController *)tab.viewControllers[tab.selectedIndex];
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)vc;
    } else {
        return;
    }
    
    [nav pushViewController:profileVC animated:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
//    self.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor popColor]);
//    self.layer.shadowOffset = CGSizeMake(5, 5);
//    self.layer.shadowRadius = self.frame.size.width * 0.5;
    self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor popColor]);
    self.layer.borderWidth = 2.5;
    
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    [[UIColor popColor] setStroke];
////    CGContextSetLineWidth(context, 1.5);
////    CGFloat center = self.bounds.size.width * 0.5;
////    CGContextAddArc(context, 0, 0, center - 5, 0, 2 * M_PI, 0);
////    CGContextDrawPath(context, kCGPathEOFill);
////    CGContextStrokePath(context);
//}

@end
