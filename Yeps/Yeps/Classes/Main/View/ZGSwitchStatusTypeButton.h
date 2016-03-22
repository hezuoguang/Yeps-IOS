//
//  ZGSwitchStatusTypeButton.h
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kZGSwitchStatusTypeButtonMargin 22
#define kZGSwitchStatusTypeButtonW (([UIScreen mainScreen].bounds.size.width - 4 * kZGSwitchStatusTypeButtonMargin) / 3)
#define kZGSwitchStatusTypeButtonH 112
@interface ZGSwitchStatusTypeButton : UIButton

@property (nonatomic, assign) NSInteger type;

@end
