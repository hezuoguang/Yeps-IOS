//
//  PickUniversityViewController.m
//  Yeps
//
//  Created by weimi on 16/3/5.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "PickUniversityViewController.h"


@interface PickUniversityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *universitys;
@property (nonatomic, strong) NSMutableArray *activeuniversitys;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation PickUniversityViewController

- (NSMutableArray *)universitys {
    if (_universitys == nil) {
        _universitys = [NSMutableArray array];
    }
    return _universitys;
}

- (NSMutableArray *)activeuniversitys {
    if (_activeuniversitys == nil) {
        _activeuniversitys = [NSMutableArray array];
    }
    return _activeuniversitys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    tableView.tableFooterView = [[UIView alloc] init];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [self getActiveUniversityList];
    
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    searchTableView.tableFooterView = [[UIView alloc] init];
    searchTableView.hidden = YES;
    self.searchTableView = searchTableView;
    [self.view addSubview:searchTableView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"搜索学校";
    [searchBar setValue:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(20, 8, 0, 8)] forKeyPath:@"_contentInset"];
    searchBar.contentMode = UIViewContentModeBottom;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.backgroundImage = [UIColor imageWithColor:[UIColor popNavBackColor] size:searchBar.bounds.size];
    
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeBtn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor popFontGrayColor] forState:UIControlStateDisabled];
    closeBtn.bounds = CGRectMake(0, 0, screenW, 44);
    closeBtn.center = CGPointMake(self.view.center.x, screenH - 0.5 * CGRectGetHeight(closeBtn.bounds));
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor whiteColor];
    self.closeBtn = closeBtn;
    [self.view addSubview:closeBtn];
}

- (void)getActiveUniversityList {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK activeUniversityList:^(id data) {
        [SVProgressHUD dismiss];
        self.universitys = data[@"university_list"];
        [self.tableView reloadData];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (void)searchUniversity:(NSString *)key {
    if (key.length == 0) {
        self.activeuniversitys = [NSMutableArray array];
        [self.searchTableView reloadData];
        return;
    }
    [YepsSDK searchUniversity:key success:^(id data) {
        self.activeuniversitys = data;
        [self.searchTableView reloadData];
    } error:^(id data) {
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchTableView.hidden = YES;
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.searchTableView.hidden = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchUniversity:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchUniversity:searchText];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.universitys.count;
    }
    return self.activeuniversitys.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor popCellColor];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16];
    if (tableView == self.tableView) {
        label.text = @"热门学校";
    } else {
        label.text = @"搜索学校";
    }
    label.frame = CGRectMake(15, 0, 100, 30);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellID = @"tableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    NSString *title = nil;
    if(self.tableView == tableView) {
        title = self.universitys[indexPath.row];
    } else {
        title = self.activeuniversitys[indexPath.row];
    }
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didPickUniversityBlock) {
        NSString *title = nil;
        if(self.tableView == tableView) {
            title = self.universitys[indexPath.row];
        } else {
            title = self.activeuniversitys[indexPath.row];
        }
        self.didPickUniversityBlock(title);
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
