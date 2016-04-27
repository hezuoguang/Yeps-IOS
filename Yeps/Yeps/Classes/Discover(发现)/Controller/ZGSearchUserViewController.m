//
//  ZGSearchUserViewController.m
//  Yeps
//
//  Created by weimi on 16/4/27.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGSearchUserViewController.h"
#import "ZGTableView.h"
#import "UserBaseInfoModel.h"
#import "ZGUserListCell.h"
#import "UserInfoModel.h"
#import "ZGOtherProfileViewController.h"
#import "StatusModel.h"
#import "MainNavigationController.h"

#import <MJExtension/MJExtension.h>

@interface ZGSearchUserViewController ()<UITableViewDataSource, ZGTableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) ZGTableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, copy) NSString *key;

@end

@implementation ZGSearchUserViewController

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    ZGTableView *tableView = [ZGTableView initWithDelegate:self dataSource:self extraPadding:kCellMargin];
    self.tableView = tableView;
    [tableView removeRefresh];
    tableView.frame = self.view.bounds;
    [self.view addSubview:tableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"手机号";
    searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [searchBar setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(20, 8, 0, 8)] forKeyPath:@"_contentInset"];
    searchBar.contentMode = UIViewContentModeBottom;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.backgroundImage = [UIColor imageWithColor:[UIColor popNavBackColor] size:searchBar.bounds.size];
    
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.models.count == 0) {
        [self.searchBar becomeFirstResponder];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    self.searchTableView.hidden = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchUsers:searchBar.text];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    [self searchUsers:searchText];
//}

- (void)searchUsers:(NSString *)key {
    [self.view endEditing:YES];
    [self.models removeAllObjects];
    [self.tableView reloadData];
    self.key = [key copy];
    [self.tableView resetNoMoreData];
    [self.tableView beginPullUpRefresh];
}

- (void)tableViewDidPullUpRefresh:(ZGTableView *)tableView {
    if(self.models.count == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    NSInteger max_id = -1;
    if (self.models.lastObject) {
        UserBaseInfoModel *model = self.models.lastObject;
        max_id = model.search_id;
    }
    NSInteger count = 30;
    [YepsSDK searchUsers:self.key max_id:max_id count:count success:^(id data) {
        [SVProgressHUD dismiss];
        [self.tableView stopPullUpRefresh];
        NSArray *array = data[@"user_list"];
        if (array.count < count) {
            [self.tableView endRefreshingWithNoMoreData];
        }
        if (array.count) {
            NSArray *models = [UserBaseInfoModel mj_objectArrayWithKeyValuesArray:array];
            [self.models addObjectsFromArray:models];
            [self.tableView reloadData];
        } else {
            if (self.models.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"未匹配到结果" maskType:SVProgressHUDMaskTypeGradient];
            }
        }
        
    } error:^(id data) {
        [self.tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [self.tableView stopPullUpRefresh];
        [SVProgressHUD showErrorWithStatus:@"搜索失败" maskType:SVProgressHUDMaskTypeGradient];
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
    MainNavigationController *nav = [[MainNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
