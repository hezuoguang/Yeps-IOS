//
//  ZGShareButton.h
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kZGShareButtonMargin 22
#define kZGShareButtonW (([UIScreen mainScreen].bounds.size.width - 4 * kZGShareButtonMargin) / 3.0)
#define kZGShareButtonH 75

typedef enum {
    ZGShareButtonTypeQQZone = 0,
    ZGShareButtonTypeQQ,
    ZGShareButtonTypeWeChat,
    ZGShareButtonTypeWeChatTimeline,
    ZGShareButtonTypeWeiBo
}ZGShareButtonType;

@interface ZGShareButton : UIButton

@property (nonatomic, assign) ZGShareButtonType type;

@end
