//
//  SMSTool.h
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSTool : NSObject

+ (void)getSMSCodeWithPhone:(NSString *)phone success:(void (^)())success error:(void (^)(NSError *error)) error;

+ (void)checkSMSCodeWithCode:(NSString *)code phone:(NSString *)phone success:(void (^)())success error:(void (^)(NSError *error)) error;

@end
