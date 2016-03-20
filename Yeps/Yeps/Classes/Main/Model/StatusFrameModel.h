//
//  StatusFrameModel.h
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    StatusCellFrameStyleList = 0,
    StatusCellFrameStyleDetail
    
}StatusCellFrameStyle;
@class StatusModel;
@interface StatusFrameModel : NSObject
/**
 *  在status前先设置
 */
@property (nonatomic, assign) StatusCellFrameStyle style;

@property (nonatomic, strong) StatusModel *status;
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
 *  类型
 */
@property (nonatomic, assign) CGRect typeLabelF;
/**
 *  大图
 */
//@property (nonatomic, assign) CGRect bannerImageViewF;
/**
 *  标题
 */
@property (nonatomic, assign) CGRect titleLabelF;
/**
 *  内容
 */
@property (nonatomic, assign) CGRect contentTextViewF;
/**
 *  图片列表
 */
@property (nonatomic, assign) CGRect imageListViewF;
/**
 *  投票
 */
@property (nonatomic, assign) CGRect voteViewF;
/**
 *  工具条
 */
@property (nonatomic, assign) CGRect toolBarF;

@property (nonatomic, assign) CGFloat height;

@end
