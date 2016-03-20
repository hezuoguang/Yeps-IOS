//
//  UIColor+Extension.h
//  Yeps
//
//  Created by weimi on 16/2/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (instancetype)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b alpha:(CGFloat)alpha;

//背景色
+ (instancetype)popBackGroundColor;

//主颜色
+ (instancetype)popColor;

//主高亮颜色
+ (instancetype)popHighlightColor;

//主字体颜色
+ (instancetype)popFontColor;

+ (instancetype)popFontGrayColor;

+ (instancetype)randomColor;

+ (instancetype)popBorderColor;

+ (instancetype)popContentColor;

+ (instancetype)popImageFontColor;

+ (instancetype)popMaskColor;

+ (instancetype)popCellColor;

@end
