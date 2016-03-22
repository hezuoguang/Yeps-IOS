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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
