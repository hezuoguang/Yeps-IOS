//
//  ZGUserListCell.m
//  Yeps
//
//  Created by weimi on 16/4/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGUserListCell.h"
#import "ZGPhotoView.h"
#import "ZGFollowButton.h"
#import "ZGLabel.h"
#include "UserBaseInfoModel.h"
#import "UserTool.h"

@interface ZGUserListCell()

@property (weak, nonatomic) IBOutlet ZGPhotoView *photoView;

@property (weak, nonatomic) IBOutlet ZGLabel *nickLabel;

@property (weak, nonatomic) IBOutlet ZGLabel *introLabel;

@property (weak, nonatomic) IBOutlet ZGFollowButton *followBtn;
@end

@implementation ZGUserListCell

+ (instancetype)initWithTableView:(UITableView *)tableView {
    static NSString *ZGUserListCellID = @"ZGUserListCellID";
    ZGUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:ZGUserListCellID];
    if(cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZGUserListCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
    
}

- (void)setup {
    self.introLabel.textColor = [UIColor popContentColor];
    self.introLabel.font = [UIFont systemFontOfSize:13];
    
    self.nickLabel.font = [UIFont systemFontOfSize:17];
    
    self.backgroundColor = [UIColor popCellColor];
    
    self.imageView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserBaseInfo:(UserBaseInfoModel *)userBaseInfo {
    if (_userBaseInfo == nil) {
        [self setup];
    }
    _userBaseInfo = userBaseInfo;
    self.photoView.userBaseInfo = userBaseInfo;
    self.nickLabel.text = userBaseInfo.nick;
    self.introLabel.text = userBaseInfo.intro;
    self.followBtn.userInfo = userBaseInfo;
    
    if ([userBaseInfo.user_sha1 isEqualToString:[UserTool getUserSha1]]) {
        self.followBtn.hidden = YES;
    } else {
        self.followBtn.hidden = NO;
    }
}

@end
