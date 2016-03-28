//
//  SwitchStatusTypeViewController.h
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGSwitchStatusTypeButton;
@interface SwitchStatusTypeViewController : UIViewController

@property (nonatomic, strong) void(^didSelectStatusButton)(ZGSwitchStatusTypeButton *btn);

@end
