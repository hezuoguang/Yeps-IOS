//
//  ZGPickImageView.h
//  Yeps
//
//  Created by weimi on 16/3/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGPickImageView;

@protocol ZGPickImageViewDelegate <NSObject>
@optional
- (void)pickImageViewDidClickDeleteBtn:(ZGPickImageView *)pickImageView;

@end

@interface ZGPickImageView : UIImageView

@property (nonatomic, weak) id<ZGPickImageViewDelegate> delegate;

@end
