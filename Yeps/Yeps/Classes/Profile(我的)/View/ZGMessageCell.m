//
//  ZGMessageCell.m
//  Yeps
//
//  Created by weimi on 16/4/28.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGMessageCell.h"
#import "ZGPhotoView.h"
#import "ZGMessageModel.h"
#import "UserBaseInfoModel.h"

@interface ZGMessageCell ()

@property (weak, nonatomic) IBOutlet ZGPhotoView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ZGMessageCell

+ (instancetype)initWithTableView:(UITableView *)tableView {
    static NSString *ZGMessageListCellID = @"ZGMessageListCellID";
    ZGMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ZGMessageListCellID];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZGMessageCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

- (void)setup {
    self.contentLabel.textColor = [UIColor popContentColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    
    self.timeLabel.textColor = [UIColor popContentColor];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    
    self.nickLabel.font = [UIFont systemFontOfSize:17];
    
    self.backgroundColor = [UIColor popCellColor];
    
    self.imageView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZGMessageModel *)model {
    _model = model;
    self.photoView.userBaseInfo = model.other_user;
    self.nickLabel.text = model.other_user.nick;
    self.contentLabel.text = model.content;
    self.timeLabel.text = model.time;
}

@end
