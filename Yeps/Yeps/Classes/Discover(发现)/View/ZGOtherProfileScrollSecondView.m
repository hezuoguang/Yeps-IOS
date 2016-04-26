//
//  ZGOtherProfileSecondView.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileScrollSecondView.h"
#import "ZGOtherProfileLabel.h"
#import "UserInfoModel.h"

@interface ZGOtherProfileScrollSecondView()

@property (weak, nonatomic) IBOutlet ZGOtherProfileLabel *introLabel;

@end

@implementation ZGOtherProfileScrollSecondView

+ (instancetype)initView {
    return [[[NSBundle mainBundle] loadNibNamed:@"ZGOtherProfileScrollSecondView" owner:nil options:nil] firstObject];
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
    [self update];
}

- (void)update {
    if (self.userInfo.intro) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:self.userInfo.intro];
        //创建NSMutableParagraphStyle实例
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineSpacing:15.0];
        [style setAlignment:NSTextAlignmentCenter];
        NSRange range = NSMakeRange(0, attStr.length);
        [attStr addAttribute:NSParagraphStyleAttributeName value:style range:range];
        [attStr addAttribute:NSForegroundColorAttributeName value:self.introLabel.textColor range:range];
        [attStr addAttribute:NSFontAttributeName value:self.introLabel.font range:range];
        self.introLabel.attributedText = attStr;
    }
}

@end
