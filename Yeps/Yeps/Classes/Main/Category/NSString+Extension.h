//
//  NSString+Extension.h
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 根据当前时间算出时间的显示(刚刚, 今天XX:XX, 昨天XX:XX, X月X日, X年X月X日)*/
- (NSString *)timeStringWithCurrentTime;

/** 得到字符串的各个字符的拼音首字母,忽略空格*/
- (NSString *)stringToPinYin;

+ (instancetype)jsonStringWithObj:(id)obj;

- (NSString *)md5String;

@end
