//
//  ZGEditIntroViewController.h
//  Yeps
//
//  Created by weimi on 16/4/24.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGEditIntroViewController : UIViewController

@property (nonatomic, strong) void(^editSuccess)(NSString *into);
@property (nonatomic, copy) NSString *intro;

@end
