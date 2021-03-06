//
//  UIColor+Extension.m
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (instancetype)popNavFontColor {
    return [UIColor whiteColor];
}

+ (instancetype)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}

+ (instancetype)popBackImageColor {
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    return [UIColor colorWithPatternImage:[self popNavBackImage]];
}

+ (instancetype)popTabBarColor {
    return [self colorWithR:236 g:240 b:241 alpha:0.96];
}

+ (instancetype)popNavBackColor {
//    return [self colorWithR:236 g:240 b:241 alpha:0.98];
//    return [self colorWithR:142 g:68 b:173 alpha:0.96];
    return [UIColor colorWithPatternImage:[self popNavBackImage]];
}

+ (UIImage *)popNavBackImage {
    return [UIImage imageNamed:@"navBackImage"];
}

+ (instancetype)popShadowColor {
    //    return [self colorWithR:236 g:240 b:241 alpha:0.98];
    return [self colorWithR:142 g:68 b:173 alpha:0.96];
}

+ (instancetype)popBackGroundColor {
    return [UIColor colorWithR:225 g:232 b:235 alpha:1.0];
//    return [self popColor];
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"switchBack"]];
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

+ (instancetype)popFontDisableColor {
    return [self colorWithR:189 g:195 b:199 alpha:1.0];
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

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
