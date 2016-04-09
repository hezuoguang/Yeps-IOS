//
//  ZGShareView.h
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGShareView : UIView

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, strong) id shareImage;
@property (nonatomic, strong) void(^shareSuccessBlock)();

+ (instancetype)shareInstance;

- (void)show;

@end
