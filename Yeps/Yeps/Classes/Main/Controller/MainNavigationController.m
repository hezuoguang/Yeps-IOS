//
//  MainNavigationController.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "MainNavigationController.h"
#import "ZGBarButtonItem.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

+ (void)initialize {
    UIBarButtonItem *barButton = [UIBarButtonItem appearance];
    NSDictionary *attr = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:17],
                           NSForegroundColorAttributeName : [UIColor popNavFontColor]
                           };
    [barButton setTitleTextAttributes:attr forState:UIControlStateNormal];
    
    NSDictionary *attr2 = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:17],
                           NSForegroundColorAttributeName : [UIColor popColor]
                           };
    [barButton setTitleTextAttributes:attr2 forState:UIControlStateHighlighted];
    
    NSDictionary *attr3 = @{
                            NSFontAttributeName : [UIFont systemFontOfSize:17],
                            NSForegroundColorAttributeName : [UIColor popFontDisableColor]
                            };
    [barButton setTitleTextAttributes:attr3 forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self resetTransparent];
}

- (void)setTransparent {
//    [self.navigationBar setBackgroundImage:[UIColor imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationBar.translucent = YES;
    [MainNavigationController setTransparent:self];
}

- (void)resetTransparent {
//    [self.navigationBar setBackgroundImage:[UIColor imageWithColor:[UIColor popNavBackColor] size:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
//    self.navigationBar.shadowImage = [[UIImage alloc] init];
//    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationBar.translucent = YES;
    [MainNavigationController resetTransparent:self];
}

+ (void)setTransparent:(UINavigationController *)nav {
    [nav.navigationBar setBackgroundImage:[UIColor imageWithColor:[UIColor clearColor] size:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [[UIImage alloc] init];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.translucent = YES;
}

+ (void)resetTransparent:(UINavigationController *)nav {
//    [nav.navigationBar setBackgroundImage:[UIColor imageWithColor:[UIColor popNavBackColor] size:CGSizeMake(5, 5)] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBackgroundImage:[UIColor popNavBackImage] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.shadowImage = [[UIImage alloc] init];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [ZGBarButtonItem leftBarButtonItemWithImage:@"nav_back"highlightImage:@"nav_back_h" addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    [super pushViewController:viewController animated:animated];
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)popViewController {
    [self popViewControllerAnimated:YES];
}

@end
