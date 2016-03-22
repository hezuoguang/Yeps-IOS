//
//  WLEmotionTextAttachment.h
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmotionModel;
@interface EmotionTextAttachment : NSTextAttachment

@property (nonatomic, strong) EmotionModel *emotion;

@end
