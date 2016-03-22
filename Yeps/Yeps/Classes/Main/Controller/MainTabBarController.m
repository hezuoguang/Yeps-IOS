//
//  MainTabBarController.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "MainTabBarController.h"
#import "ZGTabBar.h"
#import "MainNavigationController.h"
#import "ZGHomeViewController.h"
#import "ZGYepViewController.h"
#import "ZGDiscoverViewController.h"
#import "ZGProfileViewController.h"
#import "SwitchStatusTypeViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

+ (void)initialize {
    [super initialize];
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor popFontColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor popColor];
    selectAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [tabBarItem setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZGTabBar *tabBar = [[ZGTabBar alloc] init];
    tabBar.publishButtonDidClick = ^(){
        SwitchStatusTypeViewController *typeVC = [[SwitchStatusTypeViewController alloc] init];
        [self presentViewController:typeVC animated:NO completion:nil];
    };
    [self setValue:tabBar forKey:@"tabBar"];
    
    ZGHomeViewController *homeVC = [[ZGHomeViewController alloc] init];
    [self addChildVC:homeVC title:@"首页" image:@"Y" selectImage:@"Y_s"];
    
    ZGYepViewController *yepVC = [[ZGYepViewController alloc] init];
    [self addChildVC:yepVC title:@"圈子" image:@"P" selectImage:@"P_s"];
    
    ZGDiscoverViewController *discoverVC = [[ZGDiscoverViewController alloc] init];
    [self addChildVC:discoverVC title:@"发现" image:@"E" selectImage:@"E_s"];
    
    ZGProfileViewController *profileVC = [[ZGProfileViewController alloc] init];
    [self addChildVC:profileVC title:@"我" image:@"S" selectImage:@"S_s"];
    
    
}

- (void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    vc.tabBarItem.title = title;
    [vc.tabBarItem setImage: [UIImage imageNamed:image]];
    [vc.tabBarItem setSelectedImage:[UIImage imageNamed:selectImage]];
    MainNavigationController *nav = [[MainNavigationController alloc] init];
    [nav pushViewController:vc animated:NO];
    [self addChildViewController: nav];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
