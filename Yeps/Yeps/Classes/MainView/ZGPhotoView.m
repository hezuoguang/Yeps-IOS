//
//  ZGPhotoView.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPhotoView.h"

@implementation ZGPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
//    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
//    self.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor popColor]);
//    self.layer.shadowOffset = CGSizeMake(5, 5);
//    self.layer.shadowRadius = self.frame.size.width * 0.5;
    self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor popColor]);
    self.layer.borderWidth = 2.5;
    
}

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
////    CGContextRef context = UIGraphicsGetCurrentContext();
////    [[UIColor popColor] setStroke];
////    CGContextSetLineWidth(context, 1.5);
////    CGFloat center = self.bounds.size.width * 0.5;
////    CGContextAddArc(context, 0, 0, center - 5, 0, 2 * M_PI, 0);
////    CGContextDrawPath(context, kCGPathEOFill);
////    CGContextStrokePath(context);
//}

@end
