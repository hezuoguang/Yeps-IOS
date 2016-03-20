//
//  PickTagsViewController.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickTagsViewController : UIViewController

@property (nonatomic, strong) void (^didSelectTagsBlock)(NSArray *tagList);

- (instancetype)initWithSelectTags:(NSArray *)tags;

@end
