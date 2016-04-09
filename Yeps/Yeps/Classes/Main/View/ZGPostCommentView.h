//
//  ZGPostCommentView.h
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGPostCommentView : UIView

@property (nonatomic, copy) NSString *status_sha1;
@property (nonatomic, copy) NSString *comment_sha1;
@property (nonatomic, strong) void(^commentSuccessBlock)(id data);

+ (instancetype)shareInstance;

- (void)show;

@end
