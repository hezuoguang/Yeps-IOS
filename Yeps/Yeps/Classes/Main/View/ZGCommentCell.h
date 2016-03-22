//
//  ZGCommentCell.h
//  Yeps
//
//  Created by weimi on 16/3/16.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentFrameModel;
@interface ZGCommentCell : UITableViewCell

@property (nonatomic, strong) CommentFrameModel *commentF;

+ (instancetype)commentCellWithTableView:(UITableView *)tableView;

@end
