//
//  SMSTool.m
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "SMSTool.h"
#import <SMS_SDK/SMSSDK.h>
@implementation SMSTool

+ (void)getSMSCodeWithPhone:(NSString *)phone success:(void (^)())success error:(void (^)(NSError *error)) error{
//    success();
//    return;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phone zone:@"86" customIdentifier:nil result:^(NSError *e) {
        if (e) {
            if (error) {
                error(e);
            }
        } else {
            if (success) {
                success();
            }
        }
    }];
}


+ (void)checkSMSCodeWithCode:(NSString *)code phone:(NSString *)phone success:(void (^)())success error:(void (^)(NSError *))error {
//    success();
//    return;
    [SMSSDK commitVerificationCode:code phoneNumber:phone zone:@"86" result:^(NSError *e) {
        if (e) {
            if (error) {
                error(e);
            }
        } else {
            if (success) {
                success();
            }
        }
    }];
}

@end
