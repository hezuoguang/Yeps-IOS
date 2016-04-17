//
//  ZGTableView.h
//  Yeps
//
//  Created by weimi on 16/3/13.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGTableView;

@protocol ZGTableViewDelegate <UITableViewDelegate>
@optional
/**
 *  下拉刷新
 *
 *  @param tableView
 */
- (void)tableViewDidRefresh:(ZGTableView *)tableView;

/**
 *  上拉刷新
 *
 *  @param tableView
 */
- (void)tableViewDidPullUpRefresh:(ZGTableView *)tableView;

@end

@interface ZGTableView : UITableView


@property (nonatomic, weak) id<ZGTableViewDelegate> delegate;
@property (nonatomic, assign) NSInteger type;


+ (instancetype)initWithDelegate:(id<ZGTableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource extraPadding:(CGFloat)padding;

- (void)stopRefresh;

- (void)beginRefresh;

- (void)stopPullUpRefresh;

- (void)stopAllRefresh;

- (void)removeRefresh;

- (void)removePullUpRefresh;

- (void)endRefreshingWithNoMoreData;

- (void)resetNoMoreData;

@end
