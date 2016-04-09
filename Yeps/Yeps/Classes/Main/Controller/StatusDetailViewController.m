//
//  StatusDetailViewController.m
//  Yeps
//
//  Created by weimi on 16/3/14.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "ZGTableView.h"
#import "StatusFrameModel.h"
#import "StatusModel.h"
#import "ZGStatusCell.h"
#import "CommentModel.h"
#import "CommentFrameModel.h"
#import "ZGCommentCell.h"
#import "UserTool.h"
#import "UserBaseInfoModel.h"
#import "UserInfoModel.h"
#import "ZGStatusView.h"
#import <MJExtension.h>

@interface StatusDetailViewController()<ZGTableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) StatusFrameModel *detailStatusF;
@property (nonatomic, strong) NSMutableArray *commetFs;
@property (nonatomic, weak) ZGStatusView *statusView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat maxOffsetY;
@property (nonatomic, assign) CGFloat beginRefreshOffsetY;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation StatusDetailViewController


- (void)setStatusF:(StatusFrameModel *)statusF {
    _statusF = statusF;
    self.detailStatusF = statusF;
}

- (NSMutableArray *)commetFs {
    if (_commetFs == nil) {
        _commetFs = [NSMutableArray array];
    }
    return _commetFs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    CGFloat maxH = self.view.bounds.size.height;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    ZGStatusView *statusView = [[ZGStatusView alloc] init];
    self.statusView = statusView;
    statusView.backgroundColor = [UIColor popCellColor];
    statusView.statusF = self.detailStatusF;
    CGRect statusViewF = statusView.frame;
    statusViewF.origin.y = 0.0;
    statusView.frame = statusViewF;
    [self.scrollView addSubview:statusView];
    
    ZGTableView *tableView = [ZGTableView initWithDelegate:self dataSource:self extraPadding:kCellMargin];
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    CGRect frame = tableView.frame;
    frame.origin.y = CGRectGetMaxY(self.statusView.frame);
    frame.size.height -= (kToolBarH + 64);
    tableView.frame = frame;
    tableView.contentOffset = CGPointMake(0, -64);
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    tableView.userInteractionEnabled = NO;
    [tableView removePullUpRefresh];
    [tableView reloadData];
    CGFloat maxScrollViewY = self.statusView.frame.size.height + maxH - 64 - kToolBarH;
    self.maxOffsetY = self.statusView.frame.size.height - kToolBarH - 64;
    self.beginRefreshOffsetY = self.statusView.frame.size.height - maxH;
    self.scrollView.contentSize = CGSizeMake(0, maxScrollViewY);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentSuccess:) name:kUpdateStatusCountNotifi object:nil];
    
    [self scrollViewDidScroll:scrollView];
}

- (void)commentSuccess:(NSNotification *)noti {
    NSInteger status_id = [[noti.userInfo objectForKey:@"status_id"] integerValue];
    if (self.statusF.status.status_id != status_id) {
        return;
    }
    if ([noti.object objectForKey:@"comment"]) {
        CommentModel *model = [CommentModel mj_objectWithKeyValues:[noti.object objectForKey:@"comment"]];
        CommentFrameModel *modelF = [[CommentFrameModel alloc] init];
        modelF.comment = model;
        [self.commetFs addObject:modelF];
        [self.tableView reloadData];
        [self scrollToFooter:YES];
    }
}

/** tableView 滚动到最底部*/
- (void)scrollToFooter:(BOOL)animated{
    if (self.commetFs.count) {
        NSIndexPath *indexPatn = [NSIndexPath indexPathForRow:self.commetFs.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPatn atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        CGFloat fabsY = fabs(scrollView.contentOffset.y - self.maxOffsetY);
        if (scrollView.contentOffset.y > self.beginRefreshOffsetY + 5) {
            if (!self.isFirst) {
                self.isFirst = YES;
                [self.tableView beginRefresh];
            }
        }
        if (fabsY < 2) {
            self.tableView.userInteractionEnabled = YES;
        } else {
            self.tableView.userInteractionEnabled = NO;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commetFs.count;
}


- (UITableViewCell *)tableView:(ZGTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentFrameModel *modelF = self.commetFs[indexPath.row];
    ZGCommentCell *cell = [ZGCommentCell commentCellWithTableView:tableView];
    cell.commentF = modelF;
    return cell;
    
}

- (CGFloat)tableView:(ZGTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentFrameModel *modelF = self.commetFs[indexPath.row];
    return modelF.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableViewDidRefresh:(ZGTableView *)tableView {
    NSString *status_sha1 = self.statusF.status.status_sha1;
    CommentFrameModel *commentF = self.commetFs.firstObject;
    NSInteger max_id = -1;
    if (commentF) {
        CommentModel *comment = commentF.comment;
        max_id = comment.comment_id;
    }
    [YepsSDK getOldComment:max_id status_sha1:status_sha1 success:^(id data) {
        [tableView stopRefresh];
        NSArray *comments = data;
        if (comments.count == 0) {
            return;
        }
        NSArray *commentModelList = [CommentModel mj_objectArrayWithKeyValuesArray:comments];
        NSMutableArray *commentFrameList = [NSMutableArray array];
        for (CommentModel *comment in commentModelList) {
            CommentFrameModel *frameModel = [[CommentFrameModel alloc] init];
            frameModel.comment = comment;
            [commentFrameList addObject:frameModel];
        }
        [self.commetFs insertObjects:commentFrameList atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, commentFrameList.count)]];
        [tableView reloadData];
    } error:^(id data) {
        [tableView stopRefresh];
        [SVProgressHUD showErrorWithStatus:data[@"info"]];
    } failure:^(NSError *error) {
        [tableView stopRefresh];
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
    }];
}

- (void)tableViewDidPullUpRefresh:(ZGTableView *)tableView {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
