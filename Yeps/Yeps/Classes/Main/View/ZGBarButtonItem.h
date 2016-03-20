//
//  ZGBarButtonItem.h
//  Yeps
//
//  Created by weimi on 16/3/19.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGBarButtonItem : UIBarButtonItem

+ (instancetype)leftBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events;
+ (instancetype)rightBarButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage addTarget:(id)target action:(SEL)selector forControlEvents:(UIControlEvents)events;

@end
