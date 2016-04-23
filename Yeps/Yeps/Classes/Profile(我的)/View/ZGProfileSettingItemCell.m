//
//  ZGProfileSettingItemCell.m
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileSettingItemCell.h"
#import "ZGProfileSettingItemModel.h"

@interface ZGProfileSettingItemCell()

@property (nonatomic, weak) UILabel *infoLabel;

@end

@implementation ZGProfileSettingItemCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.backgroundColor = [UIColor popCellColor];
        [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UILabel *)infoLabel {
    if (_infoLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        _infoLabel = label;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor popFontGrayColor];
        [self addSubview:label];
    }
    return _infoLabel;
}

- (void)click {
    if ([self.delegate respondsToSelector:@selector(profileSettingItemCellDidClick:)]) {
        [self.delegate profileSettingItemCellDidClick:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (!highlighted) {
        self.backgroundColor = [UIColor popCellColor];
    } else {
        self.backgroundColor = [UIColor popBorderColor];
    }
}


- (void)setModel:(ZGProfileSettingItemModel *)model {
    _model = model;
    
    [self setTitle:model.title forState:UIControlStateNormal];
    
    if (model.type == ZGProfileSettingItemTypeClearCache || model.type == ZGProfileSettingItemTypeLogout) {
        [self setImage:nil forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"settingRight"] forState:UIControlStateNormal];
    }
    
    if (model.type == ZGProfileSettingItemTypeLogout) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    if (model.type == ZGProfileSettingItemTypeClearCache) {
        self.infoLabel.text = [NSString stringWithFormat:@"%.2lfM", [YepsSDK cacheSize]];
        self.infoLabel.hidden = NO;
    } else {
        self.infoLabel.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxW = self.frame.size.width;
    
    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.origin.x = 10;
    titleFrame.size.width = maxW - titleFrame.origin.x * 2;
    self.titleLabel.frame = titleFrame;
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = maxW  - imageFrame.size.width - 10;
    self.imageView.frame = imageFrame;
    
    self.infoLabel.frame = titleFrame;
}

@end
