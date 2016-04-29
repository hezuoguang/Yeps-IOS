//
//  ZGMessageListViewController.m
//  Yeps
//
//  Created by weimi on 16/4/28.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGMessageListViewController.h"
#import "ZGTableView.h"
#import "ZGMessageModel.h"
#import "ZGMessageCell.h"
#import "StatusModel.h"
#import "UserInfoModel.h"
#import "ZGOtherProfileViewController.h"
#import "StatusDetailViewController.h"

#import <MJExtension/MJExtension.h>

@interface ZGMessageListViewController ()<UITableViewDataSource, ZGTableViewDelegate>

@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZGMessageListViewController

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        ZGMessageModel *model = self.models.lastObject;
        max_id = model.message_id;
    }
    NSInteger count = 30;
    [YepsSDK getMessageList:max_id count:count success:^(id data) {
        [self.tableView stopPullUpRefresh];
        NSArray *array = data[@"message_list"];
        if (array.count < count) {
            [self.tableView endRefreshingWithNoMoreData];
        }
        if (array.count) {
            NSArray *models = [ZGMessageModel mj_objectArrayWithKeyValuesArray:array];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZGMessageCell *cell = [ZGMessageCell initWithTableView:tableView];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kZGMessageListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZGMessageModel *model = self.models[indexPath.row];
    if (model.type == ZGMessageModelTypeComment || model.type == ZGMessageModelTypeShare) {
        StatusDetailViewController *vc = [[StatusDetailViewController alloc] init];
        vc.status_sha1 = model.obj_sha1;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (model.type == ZGMessageModelTypeHookUp || model.type == ZGMessageModelTypeFollow){
        ZGOtherProfileViewController *vc = [[ZGOtherProfileViewController alloc] init];
        vc.userInfo = [UserInfoModel initWithBaseModel:model.other_user];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
