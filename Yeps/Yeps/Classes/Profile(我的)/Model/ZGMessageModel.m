//
//  ZGMessageModel.m
//  Yeps
//
//  Created by weimi on 16/4/28.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGMessageModel.h"
#import "NSString+Extension.h"

@implementation ZGMessageModel

- (NSString *)time {
    return [_time timeStringWithCurrentTime];
}

@end
