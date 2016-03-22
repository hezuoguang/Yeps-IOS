//
//  EmotionModel.h
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmotionModel : NSObject

/** 表情代表的文字*/
@property (nonatomic, copy) NSString *zh_Hans;
/** 表情对应的图片*/
@property (nonatomic, copy) NSString *image;
/** 表情类型*/
@property (nonatomic, assign) BOOL isGif;

@end
