//
//  ZGYepViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGYepViewController.h"
#import "ZGTableView.h"
#import "StatusModel.h"
#import "StatusFrameModel.h"
#import "ZGStatusCell.h"
#import "StatusDetailViewController.h"
#import <MJExtension.h>

@interface ZGYepViewController ()<ZGTableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZGYepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor popBackGroundColor];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZGTableView *tableView = [ZGTableView initWithDelegate:self dataSource:self extraPadding:0];
    self.tableView = tableView;
    tableView.type = 0;
    tableView.frame = self.view.bounds;
    [tableView beginRefresh];
    [self.view addSubview:tableView];
    
}

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(ZGTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(ZGTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZGStatusCell *cell = [ZGStatusCell statusCellWithTableView:tableView];
    StatusFrameModel *statusF = self.models[indexPath.row];
    cell.statusF = statusF;
    return cell;
    
}

- (CGFloat)tableView:(ZGTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    StatusFrameModel *statusF = self.models[indexPath.row];
    return statusF.height;
}

- (void)tableView:(ZGTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StatusDetailViewController *vc = [[StatusDetailViewController alloc] init];
    StatusFrameModel *statusF = self.models[indexPath.row];
    StatusFrameModel *detailF = [[StatusFrameModel alloc] init];
    detailF.style = StatusCellFrameStyleDetail;
    detailF.status = statusF.status;
    vc.statusF = detailF;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewDidRefresh:(ZGTableView *)tableView {
    StatusFrameModel *modelF = self.models.firstObject;
    StatusModel *model = modelF.status;
    NSInteger since_id = -1;
    NSInteger type = tableView.type;
    if (modelF) {
        since_id = model.status_id;
    }
    [YepsSDK getFollowNewStatus:since_id type:type success:^(id data) {
        [tableView stopRefresh];
        NSArray *statuses = data;
        if (statuses.count == 0) {
            return;
        }
        NSArray *statusModelList = [StatusModel mj_objectArrayWithKeyValuesArray:statuses];
        NSMutableArray *statusFrameList = [NSMutableArray array];
        for (StatusModel *status in statusModelList) {
            StatusFrameModel *frameModel = [[StatusFrameModel alloc] init];
            frameModel.status = status;
            [statusFrameList addObject:frameModel];
        }
        [self.models insertObjects:statusFrameList atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, statusFrameList.count)]];
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
    StatusFrameModel *modelF = self.models.lastObject;
    StatusModel *model = modelF.status;
    NSInteger max_id = -1;
    NSInteger type = tableView.type;
    if (modelF) {
        max_id = model.status_id;
    }
    [YepsSDK getFollowOldStatus:max_id type:type success:^(id data) {
        [tableView stopPullUpRefresh];
        NSArray *statuses = data;
        if (statuses.count == 0) {
            [tableView endRefreshingWithNoMoreData];
            return;
        }
        NSArray *statusModelList = [StatusModel mj_objectArrayWithKeyValuesArray:statuses];
        NSMutableArray *statusFrameList = [NSMutableArray array];
        for (StatusModel *status in statusModelList) {
            StatusFrameModel *frameModel = [[StatusFrameModel alloc] init];
            frameModel.status = status;
            [statusFrameList addObject:frameModel];
        }
        [self.models addObjectsFromArray:statusFrameList];
        [tableView reloadData];
        
        
    } error:^(id data) {
        [tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:data[@"info"]];
        
    } failure:^(NSError *error) {
        [tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
        
    }];
}

@end
