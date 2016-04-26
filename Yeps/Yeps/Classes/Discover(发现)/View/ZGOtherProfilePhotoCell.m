//
//  ZGOtherProfilePhotoCell.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfilePhotoCell.h"
#import "ZGImageView.h"
#import <UIImageView+WebCache.h>
#import "ZGOtherProfilePhotoModel.h"
@interface ZGOtherProfilePhotoCell()

@property (nonatomic, weak) ZGImageView *imageView;

@end

@implementation ZGOtherProfilePhotoCell

- (ZGImageView *)imageView {
    if (_imageView == nil) {
        ZGImageView *imageView = [[ZGImageView alloc] init];
        _imageView = imageView;
        [self.contentView addSubview:imageView];
    }
    return _imageView;
}

- (void)setPhotoModel:(ZGOtherProfilePhotoModel *)photoModel {
    _photoModel = photoModel;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.photoModel.small_image_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
