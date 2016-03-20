//
//  StatusTableViewCell.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusTableViewCell.h"
#import "ZGPhotoView.h"
#import "ZGImageView.h"
#import "ZGLabel.h"
#import "ZGTextView.h"

@interface ZGStatusTableViewCell()

/**
 *  头像
 */
@property (nonatomic, weak) ZGPhotoView *photoView;

@property (nonatomic, weak) ZGLabel *nickLabel;

@property (nonatomic, weak) ZGLabel *timeLabel;

@property (nonatomic, weak) ZGLabel *typeLabel;

@property (nonatomic, weak) ZGImageView *bannerImageView;

@property (nonatomic, weak) ZGLabel *titleLabel;

@property (nonatomic, weak) ZGTextView *contentTextView;


@end

@implementation ZGStatusTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
