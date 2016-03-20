//
//  ZGTagCollectionViewCell.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGTagCollectionViewCell.h"

@interface ZGTagCollectionViewCell()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation ZGTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [[UILabel alloc] init];
        label.contentMode = UIViewContentModeCenter;
        label.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentLabel = label;
        [self.contentView addSubview:label];
        [self setCellStyle:ZGTagCollectionViewCellStyleDefault];
    }
    return self;
}

- (void)setCellStyle:(ZGTagCollectionViewCellStyle)style {
    if (style == ZGTagCollectionViewCellStyleDefault) {
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor popColor];
    } else {
        self.contentLabel.textColor = [UIColor popFontColor];
        self.contentView.backgroundColor = [UIColor popHighlightColor];
    }
}

- (void)setTagName:(NSString *)tagName {
    _tagName = tagName;
    self.contentLabel.text = tagName;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.frame = self.contentView.bounds;
}

@end
