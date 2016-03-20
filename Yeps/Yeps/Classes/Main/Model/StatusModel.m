//
//  StatusModel.m
//  Yeps
//
//  Created by weimi on 16/3/7.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "StatusModel.h"
#import "NSString+Extension.h"

@implementation StatusModel

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:_title];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setLineSpacing:5.0];
    [style setAlignment:NSTextAlignmentCenter];
    NSRange range = NSMakeRange(0, attStr.length);
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    [attStr addAttribute:NSFontAttributeName value:kTitleLabelFont range:range];
    self.attrTitle = attStr;
}

- (void)setContent:(NSString *)content {
    _content = [content copy];
}

- (NSAttributedString *)attrContent {
    if (_attrContent == nil) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.content];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:5.0];
//        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor popContentColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:kContentTextViewFont range:range];
        _attrContent = attStr;
    }
    return _attrContent;
}

- (NSAttributedString *)attrSubContent {
    if (_attrSubContent == nil) {
        NSString *content = self.content;
        if (self.content.length > 60) {
            content = [NSString stringWithFormat:@"%@...", [self.content substringToIndex:60]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:5.0];
        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor popContentColor] range:range];
        [attStr addAttribute:NSFontAttributeName value:kContentTextViewFont range:range];
        _attrSubContent = attStr;
    }
    return _attrSubContent;
}

- (NSString *)create_time {
    return [_create_time timeStringWithCurrentTime];
}

@end
