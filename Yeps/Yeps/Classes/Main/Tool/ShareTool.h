//
//  ShareTool.h
//  Yeps
//
//  Created by weimi on 16/4/9.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareTool : NSObject

+ (void)shareToWeiBo:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel;

+ (void)shareToWeChat:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel;

+ (void)shareToWeChatTimeline:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel;

+ (void)shareToQQ:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel;

+ (void)shareToQzone:(NSString *)text title:(NSString *)title image:(id)image url:(NSString *)url success:(void(^)())success error:(void(^)())error cancel:(void(^)())cancel;
@end
