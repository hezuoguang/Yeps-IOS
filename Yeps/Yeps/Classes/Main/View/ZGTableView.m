//
//  ZGTableView.m
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGTableView.h"
#import "StatusModel.h"
#import <MJRefresh.h>
@implementation ZGTableView
@dynamic delegate;

+ (instancetype)initWithDelegate:(id<ZGTableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource extraPadding:(CGFloat)padding;{
    ZGTableView *tableView = [[ZGTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(64-kCellMargin + padding, 0, 5, 0);
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:tableView refreshingAction:@selector(refresh)];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)tableView.mj_header;
    header.lastUpdatedTimeLabel.hidden = YES;
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:tableView refreshingAction:@selector(pullRefresh)];
    tableView.mj_header.ignoredScrollViewContentInsetTop = -kCellMargin + padding;
    tableView.mj_footer.automaticallyHidden = YES;
    tableView.mj_header.automaticallyChangeAlpha = YES;
    tableView.mj_footer.automaticallyChangeAlpha = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    return tableView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
    }
    return self;
}

- (void)refresh {
    if ([self.delegate respondsToSelector:@selector(tableViewDidRefresh:)]) {
        [self.delegate tableViewDidRefresh:self];
    }
}

- (void)pullRefresh {
    if ([self.delegate respondsToSelector:@selector(tableViewDidPullUpRefresh:)]) {
        [self.delegate tableViewDidPullUpRefresh:self];
    }
}

- (void)beginRefresh {
    [self.mj_header beginRefreshing];
}

-(void)stopRefresh {
    [self.mj_header endRefreshing];
}

-(void)stopPullUpRefresh {
    [self.mj_footer endRefreshing];
}

- (void)stopAllRefresh {
    [self.mj_footer endRefreshing];
    [self.mj_header endRefreshing];
}

- (void)removeRefresh {
    self.mj_header = nil;
}

- (void)removePullUpRefresh {
    self.mj_footer = nil;
}

- (void)endRefreshingWithNoMoreData {
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData {
    [self.mj_footer resetNoMoreData];
}

@end
