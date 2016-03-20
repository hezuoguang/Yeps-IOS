//
//  UIColor+Extension.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (instancetype)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

+ (instancetype)popBackGroundColor {
    return [UIColor colorWithR:225 g:232 b:235 alpha:1.0];
}

//主颜色
+ (instancetype)popColor {
    return [UIColor colorWithR:69 g:192 b:249 alpha:1.0];
}

//主高亮颜色
+ (instancetype)popHighlightColor {
    return [UIColor colorWithR:249 g:216 b:97 alpha:1.0];
}

//主字体颜色
+ (instancetype)popFontColor {
    return [UIColor colorWithR:57 g:46 b:18 alpha:1.0];
}

+ (instancetype)popFontGrayColor {
    return [self colorWithR:210 g:210 b:210 alpha:1.0];
}

+ (instancetype)randomColor {
    return [self colorWithR:random()%255 g:random()%255 b:random()%255 alpha:1.0];
}

+ (instancetype)popBorderColor {
    return [self colorWithR:229 g:229 b:229 alpha:1.0];
}

+ (instancetype)popContentColor {
    return [self colorWithR:145 g:145 b:145 alpha:1.0];
}

+ (instancetype)popImageFontColor {
    return [self colorWithR:238 g:232 b:233 alpha:1.0];
}

+ (instancetype)popMaskColor {
    return [UIColor colorWithR:225 g:255 b:255 alpha:0.7];
}

+ (instancetype)popCellColor {
    return [UIColor whiteColor];
}

@end
