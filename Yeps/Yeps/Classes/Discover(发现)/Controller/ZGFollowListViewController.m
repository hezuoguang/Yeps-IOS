//
//  ZGFollowListViewController.m
//  Yeps
//
//  Created by weimi on 16/4/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGFollowListViewController.h"
#import "ZGTableView.h"
#import "UserBaseInfoModel.h"
#import "ZGUserListCell.h"
#import "UserInfoModel.h"
#import "ZGOtherProfileViewController.h"
#import "StatusModel.h"

#import <MJExtension/MJExtension.h>
@interface ZGFollowListViewController ()<UITableViewDataSource, ZGTableViewDelegate>

@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZGFollowListViewController

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZGTableView *tableView = [ZGTableView initWithDelegate:self dataSource:self extraPadding:kCellMargin];
    self.tableView = tableView;
    [tableView removeRefresh];
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.models.count == 0) {
        [self.tableView resetNoMoreData];
        [self.tableView beginPullUpRefresh];
    }
}

- (void)tableViewDidPullUpRefresh:(ZGTableView *)tableView {
    NSInteger max_id = -1;
    if (self.models.lastObject) {
        UserBaseInfoModel *model = self.models.lastObject;
        max_id = model.search_id;
    }
    NSInteger count = 30;
    [YepsSDK aboutFollowUserList:self.userBaseInfo.user_sha1 max_id:max_id count:count followMe:self.followMe success:^(id data) {
        [self.tableView stopPullUpRefresh];
        NSArray *array = data[@"user_list"];
        if (array.count < count) {
            [self.tableView endRefreshingWithNoMoreData];
        }
        if (array.count) {
            NSArray *models = [UserBaseInfoModel mj_objectArrayWithKeyValuesArray:array];
            [self.models addObjectsFromArray:models];
            [self.tableView reloadData];
        }
    } error:^(id data) {
        [self.tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [self.tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:@"获取数据失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZGUserListCell *cell = [ZGUserListCell initWithTableView:tableView];
    cell.userBaseInfo = self.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KZGUserListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZGOtherProfileViewController *vc = [[ZGOtherProfileViewController alloc] init];
    vc.userInfo = [UserInfoModel initWithBaseModel:self.models[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
