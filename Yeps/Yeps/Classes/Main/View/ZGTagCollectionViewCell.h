//
//  ZGTagCollectionViewCell.h
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZGTagCollectionViewCellStyleDefault,
    ZGTagCollectionViewCellStyleHighlight
}ZGTagCollectionViewCellStyle;

@interface ZGTagCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *tagName;

- (void)setCellStyle:(ZGTagCollectionViewCellStyle) style;

@end
