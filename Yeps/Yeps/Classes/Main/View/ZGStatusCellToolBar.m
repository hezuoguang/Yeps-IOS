//
//  ZGStatusCellToolBar.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusCellToolBar.h"
#import "ZGCellToolButton.h"
#import "StatusModel.h"
@interface ZGStatusCellToolBar()

@property (nonatomic, weak)ZGCellToolButton *share;
@property (nonatomic, weak)ZGCellToolButton *comment;
@property (nonatomic, weak)ZGCellToolButton *like;

@end

@implementation ZGStatusCellToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        ZGCellToolButton *share = [[ZGCellToolButton alloc] init];
        self.share = share;
        [self addSubview:share];
        [share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        
        ZGCellToolButton *comment = [[ZGCellToolButton alloc] init];
        self.comment = comment;
        [self addSubview:comment];
        [comment setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        [comment setTitle:@"评论" forState:UIControlStateNormal];
        
        ZGCellToolButton *like = [[ZGCellToolButton alloc] init];
        self.like = like;
        [self addSubview:like];
        [like setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [like setImage:[UIImage imageNamed:@"like_h"] forState:UIControlStateSelected];
        [like setTitle:@"点赞" forState:UIControlStateNormal];
    }
    return self;
}

- (void)setStatus:(StatusModel *)status {
    _status = status;
    if (status.share_count <= 0) {
        [self.share setTitle:@"分享" forState:UIControlStateNormal];
    } else {
        [self.share setTitle:[NSString stringWithFormat:@"%ld", (long)status.share_count] forState:UIControlStateNormal];
    }
    
    if (status.comment_conut <= 0) {
        [self.comment setTitle:@"评论" forState:UIControlStateNormal];
    } else {
        [self.comment setTitle:[NSString stringWithFormat:@"%ld", (long)status.comment_conut] forState:UIControlStateNormal];
    }
    
    if (status.like_count <= 0) {
        [self.like setTitle:@"点赞" forState:UIControlStateNormal];
    } else {
        [self.like setTitle:[NSString stringWithFormat:@"%ld", (long)status.like_count] forState:UIControlStateNormal];
    }
    
    if (status.me_is_like) {
        self.like.selected = YES;
    } else {
        self.like.selected = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnW = (self.frame.size.width - 2) / 3.0;
    CGFloat btnH = self.frame.size.height;
    self.share.frame = CGRectMake(0, 0, btnW, btnH);
    self.comment.frame = CGRectMake(btnW + 1, 0, btnW, btnH);
    self.like.frame = CGRectMake(2 * btnW + 2, 0, btnW, btnH);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context =  UIGraphicsGetCurrentContext();
    [[UIColor popBorderColor] setStroke];
    CGContextSetLineWidth(context, 1 / [UIScreen mainScreen].scale);
    CGContextMoveToPoint(context, 10, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width - 20, 0);
    CGContextStrokePath(context);
    
    CGFloat btnW = (self.frame.size.width - 2) / 3.0;
    CGFloat btnH = self.frame.size.height;
    CGContextMoveToPoint(context, btnW + 0.5, 2);
    CGContextAddLineToPoint(context, btnW + 0.5, btnH - 4);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 2 * btnW + 1.5, 2);
    CGContextAddLineToPoint(context, 2 * btnW + 1.5, btnH - 4);
    CGContextStrokePath(context);
}

@end
