//
//  CommentFrameModel.h
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentModel;
@interface CommentFrameModel : NSObject

@property (nonatomic, strong) CommentModel *comment;

/**
 *  头像
 */
@property (nonatomic, assign) CGRect photoViewF;
/**
 *  昵称
 */
@property (nonatomic, assign) CGRect nickLabelF;
/**
 *  创建时间
 */
@property (nonatomic, assign) CGRect timeLabelF;
/**
 *  内容
 */
@property (nonatomic, assign) CGRect contentTextViewF;

@property (nonatomic, assign) CGFloat height;
@end
