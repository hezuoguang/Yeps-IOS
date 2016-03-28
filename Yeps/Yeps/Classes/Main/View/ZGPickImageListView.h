//
//  ZGPickImageListView.h
//  Yeps
//
//  Created by weimi on 16/3/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGPickImageListView;
@protocol ZGPickImageListViewDelegate <NSObject>

@optional
- (void)pickImageListViewDidClickAddImageButton:(ZGPickImageListView *)pickImageListView;

- (void)pickImageListViewHeightDidChange:(ZGPickImageListView *)pickImageListView;

@end

@interface ZGPickImageListView : UIView

@property (nonatomic, weak) id<ZGPickImageListViewDelegate> delegate;

- (NSArray *)images;
- (void)setImages:(NSArray *)images;
- (void)addImage:(UIImage *)image;
- (NSInteger)imageCount;
- (NSInteger)imageMaxCount;

@end
