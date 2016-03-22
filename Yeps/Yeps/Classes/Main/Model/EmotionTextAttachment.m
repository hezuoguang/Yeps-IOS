//
//  WLEmotionTextAttachment.m
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "EmotionTextAttachment.h"
#import "EmotionModel.h"
@implementation EmotionTextAttachment

- (void)setEmotion:(EmotionModel *)emotion {
    _emotion = emotion;
    self.image = [UIImage imageNamed:emotion.image];
}

@end
