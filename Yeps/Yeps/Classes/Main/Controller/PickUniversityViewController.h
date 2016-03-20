//
//  PickUniversityViewController.h
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUniversityViewController : UIViewController

@property (nonatomic, strong) void (^didPickUniversityBlock)(NSString *university);

@end
