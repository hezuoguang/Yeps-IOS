//
//  NSObject+Runtime.m
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

+ (void)iVarList {
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSLog(@"%s -- %s", ivar_getName(ivars[i]), ivar_getTypeEncoding(ivars[i]));
    }
}

@end
