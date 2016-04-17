//
//  ZGPickImageListView.m
//  Yeps
//
//  Created by weimi on 16/3/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGPickImageListView.h"
#import "ZGPickImageView.h"

#define kPickImageListViewLeftRightPadding 10
#define kPickImageListViewTopBottomPadding 10
#define kPickImageViewMargin 5
#define kPickImageViewLineCount 3
#define kPickImageViewListMaxCount 9

@interface ZGPickImageListView()<ZGPickImageViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, weak) UIButton *addButton;

@end

@implementation ZGPickImageListView

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        self.userInteractionEnabled = YES;
//    }
//    return self;
//}

- (NSMutableArray *)imageViewList {
    if (_imageViewList == nil) {
        _imageViewList = [NSMutableArray array];
    }
    return _imageViewList;
}

- (NSInteger)imageCount {
    return self.imageViewList.count;
}

- (NSInteger)imageMaxCount {
    return kPickImageViewListMaxCount;
}

- (UIButton *)addButton {
    if (_addButton == nil) {
        UIButton *addButton = [[UIButton alloc] init];
        [addButton setBackgroundImage:[UIImage imageNamed:@"pickImageAdd"] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[UIImage imageNamed:@"pickImageAdd_h"] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addButton = addButton;
        [self addSubview:addButton];
    }
    return _addButton;
}

- (void)addButtonClick {
    if ([self.delegate respondsToSelector:@selector(pickImageListViewDidClickAddImageButton:)]) {
        [self.delegate pickImageListViewDidClickAddImageButton:self];
    }
}

- (NSArray *)images {
    NSMutableArray *images = [NSMutableArray array];
    for (ZGPickImageView *imageView in self.imageViewList) {
        [images addObject:imageView.image];
    }
    return images;
}

- (void)setImages:(NSArray *)images {
    self.imageViewList = nil;
    for (UIImage *image in images) {
        ZGPickImageView *imagView = [[ZGPickImageView alloc] init];
        imagView.image = image;
        [self.imageViewList addObject:imagView];
    }
}

- (void)addImage:(UIImage *)image {
    ZGPickImageView *imageView = [[ZGPickImageView alloc] init];
    imageView.delegate = self;
    imageView.image = image;
    [self.imageViewList addObject:imageView];
    [self addSubview:imageView];
}

- (void)pickImageViewDidClickDeleteBtn:(ZGPickImageView *)pickImageView {
    [self.imageViewList removeObject:pickImageView];
    [pickImageView removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxW = self.bounds.size.width;
    CGFloat imageViewWH = (maxW - kPickImageViewMargin * (kPickImageViewLineCount - 1) - kPickImageListViewLeftRightPadding * 2) / kPickImageViewLineCount;
    CGFloat X = 0;
    CGFloat Y = 0;
    NSInteger index = 0;
    for (ZGPickImageView *imageView in self.imageViewList) {
        X = kPickImageListViewLeftRightPadding + (imageViewWH + kPickImageViewMargin) * (index % kPickImageViewLineCount);
        Y = kPickImageListViewTopBottomPadding + (index / kPickImageViewLineCount) * (imageViewWH + kPickImageViewMargin);
        imageView.frame = CGRectMake(X, Y, imageViewWH, imageViewWH);
        index++;
    }
//    CGFloat maxH = Y + kPickImageListViewTopBottomPadding;
    CGFloat maxH = 0;
    X = kPickImageListViewLeftRightPadding + (imageViewWH + kPickImageViewMargin) * (index % kPickImageViewLineCount);
    Y = kPickImageListViewTopBottomPadding + (index / kPickImageViewLineCount) * (imageViewWH + kPickImageViewMargin);
    self.addButton.frame = CGRectMake(X, Y, imageViewWH, imageViewWH);
    maxH = CGRectGetMaxY(self.addButton.frame) + kPickImageListViewTopBottomPadding;
    if (index >= kPickImageViewListMaxCount) {
        self.addButton.hidden = YES;
    } else {
        self.addButton.hidden = NO;
    }
    CGRect frame = self.frame;
    
    if (maxH != frame.size.height) {
        frame.size.height = maxH;
        self.frame = frame;
        if ([self.delegate respondsToSelector:@selector(pickImageListViewHeightDidChange:)]) {
            [self.delegate pickImageListViewHeightDidChange:self];
        }
    }
    
    
}

@end
