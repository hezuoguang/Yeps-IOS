//
//  NSString+Extension.m
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Extension)

- (NSString *)timeStringWithCurrentTime {
    if ([self isEqualToString:@"刚刚"]) {
        return @"刚刚";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [dateFormatter dateFromString:self];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = dateFormatter.locale;
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comSub = [calendar components:unit fromDate:date toDate:now options:0];
    NSDateComponents *comPre = [calendar components:unit fromDate:date];
    NSDateComponents *comNow = [calendar components:unit fromDate:now];
    if (comPre.year != comNow.year) {//不是同一年
        dateFormatter.dateFormat = @"yyyy年MM月dd日 HH点mm分";
        return [dateFormatter stringFromDate:date];
    } else if(comPre.month == comNow.month) {//同一月
        if (comPre.day == comNow.day) {//同一天
            if (comSub.hour == 0) {//相差不足一小时
                if (comSub.minute <= 1) {
                    return [NSString stringWithFormat:@"刚刚"];
                }
                return [NSString stringWithFormat:@"%ld分钟前",(long)comSub.minute];
            } else if(comSub.hour <= 5) {//相差不足5小时
                return [NSString stringWithFormat:@"%ld小时前",(long)comSub.hour];
            } else {
                dateFormatter.dateFormat = @"HH点mm分";
                return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
            }
        } else if(comSub.day <= 1){//昨天
            dateFormatter.dateFormat = dateFormatter.dateFormat = @"HH点mm分";
            return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
        } else {//本月
            dateFormatter.dateFormat = @"dd日 HH点mm分";
            return [dateFormatter stringFromDate:date];
        }
    } else {//本年
        dateFormatter.dateFormat = @"MM月dd日 HH点mm分";
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)stringToPinYin {
    NSMutableString *str = [NSMutableString stringWithString:self];
    NSMutableString *pinYin = [NSMutableString string];
    //将字符串转为拼音
    if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformMandarinLatin, NO)) {
        if (CFStringTransform((__bridge CFMutableStringRef)str, 0, kCFStringTransformStripDiacritics, NO)) {
            NSUInteger len = str.length;
            //提取首字母
            BOOL flag = YES;
            for (NSUInteger i = 0; i < len; i++) {
                char c = [str characterAtIndex:i];
                if (c == ' ') {
                    flag = YES;
                } else if(flag || c < 'a' || c > 'z') {
                    flag = NO;
                    [pinYin appendFormat:@"%c", c];
                }
            }
        }
        
    }
    return pinYin;
}

+ (instancetype)jsonStringWithObj:(id)obj {
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)md5String {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_LONG len = (CC_LONG)self.length;
    CC_MD5( cStr, len, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (NSString *)trimSpace {
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [[NSString alloc] initWithString:[self stringByTrimmingCharactersInSet:whiteSpace]];
}

@end
