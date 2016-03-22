//
//  ZGStatusImageListView.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusImageListView.h"
#import "StatusModel.h"
#import "ZGImageView.h"
#import <UIImageView+WebCache.h>

@interface ZGStatusImageListView()



@end

@implementation ZGStatusImageListView

- (void)setStatus:(StatusModel *)status {
    _status = status;
    [self setNeedsLayout];
}

+ (CGSize)sizeWithStatus:(StatusModel *)status {
    NSInteger count = status.image_list.count;
    if (count == 1) {
        return CGSizeMake(kBannerImageViewW, kBannerImageViewH);
    }
    CGFloat imageWH = kImageViewWH2;
    CGFloat imageListViewW = kMaxW;
    if (count != 4 && count != 2) {
        imageWH = kImageViewWH3;
    }
    if (count <= 3) {
        return CGSizeMake(imageListViewW, imageWH);
    } else if(count == 4) {
        return CGSizeMake(imageListViewW, imageWH * 2 + kImageViewMargin);
    } else {
        NSInteger col = ceil(count / 3.0);
        return CGSizeMake(imageListViewW, col * imageWH + (col - 1) * kImageViewMargin);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.status) {
        NSInteger count = self.status.image_list.count;
        NSInteger index = 0;
        NSInteger num = 3;
        CGFloat imageWH = kImageViewWH2;
        if (count == 4 || count == 2) {
            num = 2;
        } else {
            imageWH = kImageViewWH3;
        }
        for (ZGImageView *imageView in self.subviews) {
            if (index < count) {
                imageView.hidden = NO;
                NSURL *url = [NSURL URLWithString:self.status.image_list[index]];
                [imageView sd_setImageWithURL:url];
                CGFloat x = (index % num) * (imageWH + kImageViewMargin) + kImageViewPadding;
                CGFloat y = (index / num) * (imageWH + kImageViewMargin);
                if (count == 1) {
                    imageView.frame = CGRectMake(0, 0, kBannerImageViewW, kBannerImageViewH);
                }
                else {
                    imageView.frame = CGRectMake(x, y, imageWH, imageWH);
                }
            } else {
                imageView.hidden = YES;
            }
            index++;
        }
        while (index < count) {
            ZGImageView *imageView = [[ZGImageView alloc] init];
            NSURL *url = [NSURL URLWithString:self.status.image_list[index]];
            [imageView sd_setImageWithURL:url];
            CGFloat x = (index % num) * (imageWH + kImageViewMargin) + kImageViewPadding;
            CGFloat y = (index / num) * (imageWH + kImageViewMargin);
            if (count == 1) {
                imageView.frame = CGRectMake(0, 0, kBannerImageViewW, kBannerImageViewH);
            }
            else {
                imageView.frame = CGRectMake(x, y, imageWH, imageWH);
            }
            [self addSubview:imageView];
            index++;
        }
    }
}

@end
