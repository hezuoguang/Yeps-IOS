//
//  ZGStatusTypeScrollView.h
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGStatusTypeScrollView : UIScrollView

@property (nonatomic, strong) void (^didSelectType)(NSInteger type);

- (void)setSelectType:(NSInteger)type;

@end
