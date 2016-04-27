//
//  ZGProfileHeaderViewButton.h
//  Yeps
//
//  Created by weimi on 16/4/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZGProfileHeaderViewButtonTypeFollow,
    ZGProfileHeaderViewButtonTypeFans,
    ZGProfileHeaderViewButtonTypeStatus,
    ZGProfileHeaderViewButtonTypePhoto
}ZGProfileHeaderViewButtonType;

@interface ZGProfileHeaderViewButton : UIButton

@property (nonatomic, assign) ZGProfileHeaderViewButtonType type;

- (void)setCount:(NSInteger)count;

@end
