//
//  ZGTagListView.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGTagCollectionViewCell.h"


@interface ZGTagListView : UICollectionView

@property (nonatomic, strong) void(^didSelectTag)(NSString *tagName);
@property (nonatomic, assign) ZGTagCollectionViewCellStyle cellStyle;

- (void)setTags:(NSArray *)tags;
- (void)addTags:(NSArray *)tags;
- (void)addTag:(NSString *)tag;
- (void)removeTag:(NSString *)tag;
- (NSArray *)tags;

@end
