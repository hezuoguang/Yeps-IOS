//
//  ZGOtherProfilePhotoModel.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfilePhotoModel.h"

@implementation ZGOtherProfilePhotoModel

- (NSString *)small_image_url {
    if (_small_image_url == nil) {
        _small_image_url = [NSString stringWithFormat:@"%@%@", self.image_url, kIMAGESMALLURLENDFIX];
    }
    return _small_image_url;
}

@end
