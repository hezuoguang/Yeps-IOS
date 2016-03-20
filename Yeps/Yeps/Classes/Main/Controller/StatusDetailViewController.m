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

@interface StatusDetailViewController()<ZGTableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) StatusFrameModel *detailStatusF;
@property (nonatomic, strong) NSMutableArray *commetFs;
@property (nonatomic, weak) ZGStatusView *statusView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat maxOffsetY;

@end

@implementation StatusDetailViewController


- (void)setStatusF:(StatusFrameModel *)statusF {
    _statusF = statusF;
    self.detailStatusF = statusF;
}

- (NSMutableArray *)commetFs {
    if (_commetFs == nil) {
        _commetFs = [NSMutableArray array];
        UserBaseInfoModel *user = [UserTool getCurrentUserInfo];
        for (NSInteger i = 0; i < 10; i++) {
            CommentModel *model = [[CommentModel alloc] init];
            model.create_user = user;
            model.create_time = @"2014-11-22 23:23:22";
            model.content = @"h";
            if (i % 3 == 0) {
                model.is_me = YES;
            } else {
                model.is_me = NO;
            }
            if (i % 4 == 0) {
                model.content = @"自定义UINavigationController 在viewDidLoad方法中将其背景色设置为白色即可";
            }
            if (i % 5 == 0) {
                model.content = @"该纪录片将向你展示一个壮观、不受重视但却充斥人类周遭的迷你宇宙，一个怪异、凶猛但出奇美丽的无脊椎昆虫世界！奇特的蝉、发出萤光的蠕虫、吐丝技巧复杂的蜘蛛，以及专吃蝙蝠的蜈蚣…这些生物或许渺小，但牠们的生活机制却惊人的庞";
            }
            CommentFrameModel *modelF = [[CommentFrameModel alloc] init];
            modelF.comment = model;
            [_commetFs addObject:modelF];
        }
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
    self.scrollView.contentSize = CGSizeMake(0, maxScrollViewY);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView == scrollView) {
        
        if (fabs(scrollView.contentOffset.y - self.maxOffsetY) < 2) {
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
//    [YepsSDK getNewStatus:since_id type:type success:^(id data) {
//        [tableView stopRefresh];
//        NSArray *statuses = data[@"status_list"];
//        if (statuses.count == 0) {
//            return;
//        }
//        NSArray *statusModelList = [StatusModel mj_objectArrayWithKeyValuesArray:statuses];
//        NSMutableArray *statusFrameList = [NSMutableArray array];
//        for (StatusModel *status in statusModelList) {
//            StatusFrameModel *frameModel = [[StatusFrameModel alloc] init];
//            frameModel.status = status;
//            [statusFrameList addObject:frameModel];
//        }
//        [models insertObjects:statusFrameList atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, statusFrameList.count)]];
//        [tableView reloadData];
//        
//        
//    } error:^(id data) {
//        [tableView stopRefresh];
//        [SVProgressHUD showErrorWithStatus:data[@"info"]];
//        
//    } failure:^(NSError *error) {
//        [tableView stopRefresh];
//        [SVProgressHUD showErrorWithStatus:@"网络故障"];
//        
//    }];
    [self.tableView stopRefresh];
}


@end
