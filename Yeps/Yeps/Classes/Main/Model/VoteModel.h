//
//  VoteModel.h
//  Yeps
//
//  Created by weimi on 16/3/7.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteModel : NSObject
//vote: {
//vote_sha1: "",
//vote_option: "选项列表[选项1, 选项二]",
//vote_result: "选项对应的票数[1,10]",
//vote_count: "当前总票数",
//me_is_vote: "我是否参与了投票(0:未参与, 1:参与了)",
//me_vote_option: "我投的选项下标",
//end_time: "结束时间",
//is_end: "是否已经结束(0:未结束, 1:已结束)"
//}
@property (nonatomic, copy) NSString *vote_sha1;
@property (nonatomic, strong) NSArray *vote_option;
@property (nonatomic, strong) NSArray *vote_result;
@property (nonatomic, assign) NSUInteger vote_count;
@property (nonatomic, assign) BOOL me_is_vote;
@property (nonatomic, assign) NSUInteger me_vote_option;
@property (nonatomic, copy) NSString *end_time;
@property (nonatomic, assign) BOOL is_end;
@end
