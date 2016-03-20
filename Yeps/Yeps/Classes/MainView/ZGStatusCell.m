//
//  StatusTableViewCell.m
//  Yeps
//
//  Created by weimi on 16/3/8.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGStatusCell.h"
#import "ZGStatusView.h"
#import "StatusFrameModel.h"
#import "StatusModel.h"

@interface ZGStatusCell()

@property (nonatomic, weak) ZGStatusView *statusView;

@end

@implementation ZGStatusCell

+ (instancetype)statusCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"StatusCellID";
    ZGStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ZGStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor popCellColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ZGStatusView *statusView = [[ZGStatusView alloc] init];
        [cell.contentView addSubview:statusView];
        cell.statusView = statusView;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setStatusF:(StatusFrameModel *)statusF {
    _statusF = statusF;
    self.statusView.statusF = statusF;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.statusF) {
        self.contentView.frame = CGRectMake(0, kCellMargin, kMaxW, self.statusF.height - kCellMargin);
    }
}



@end
