//
//  ZGProfileViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileViewController.h"
#import "ZGProfileHeaderView.h"
#import "MainNavigationController.h"
#import "UserTool.h"
#import "UserInfoModel.h"
#import "ZGTableView.h"
#import "StatusModel.h"

@interface ZGProfileViewController ()<UIScrollViewDelegate, ZGTableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) ZGProfileHeaderView *headerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, assign) CGFloat headerH;
@property (nonatomic, weak) UILabel *navTitleLabel;
@property (nonatomic, weak) ZGTableView *tableView;

@end

@implementation ZGProfileViewController

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.frame = self.view.bounds;
        scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height + 1);
        scrollView.delegate = self;
        scrollView.bounces = YES;
        [self.view addSubview:scrollView];
    }
    return _scrollView;
}

- (ZGProfileHeaderView *)headerView {
    if (_headerView == nil) {
        ZGProfileHeaderView *headerView = [ZGProfileHeaderView profileHeaderView];
        _headerView = headerView;
        self.headerH = headerView.frame.size.height;
        headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.headerH);
        [self.tableView addSubview:_headerView];
//        self.tableView.tableHeaderView = headerView;
    }
    return _headerView;
}

- (UserInfoModel *)userInfo {
    if (_userInfo == nil) {
        _userInfo = [UserTool getCurrentUserInfo];
    }
    return _userInfo;
}

- (void)setNavTransparent {
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    [nav setTransparent];
}

- (void)resetNavTransparent {
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    [nav resetTransparent];
}

- (UILabel *)navTitleLabel {
    if (_navTitleLabel == nil) {
        UILabel *navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel = navTitleLabel;
        self.navigationItem.titleView = self.navTitleLabel;
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [UIFont systemFontOfSize:17];
        _navTitleLabel.textColor = [UIColor popNavFontColor];
        _navTitleLabel.bounds = CGRectMake(0, 0, 100, 44);
    }
    return _navTitleLabel;
}

- (void)setupTableView {
    ZGTableView *tableView = [ZGTableView initWithDelegate:self dataSource:self extraPadding:kCellMargin-64];
    _tableView = tableView;
    [tableView removeRefresh];
    [self.view addSubview:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat Y = scrollView.contentOffset.y;
        NSLog(@"---- %lf", Y);
        if (Y >= 110) {
            if (self.navTitleLabel.hidden) {
                self.navTitleLabel.hidden = NO;
                [self.headerView setNickLabelStatus:!self.navTitleLabel.hidden];
                [self resetNavTransparent];
            }
        } else if(!self.navTitleLabel.hidden) {
            self.navTitleLabel.hidden = YES;
            [self.headerView setNickLabelStatus:!self.navTitleLabel.hidden];
            [self setNavTransparent];
            NSLog(@"----");
        }
        if (Y <= -144) {
            Y = -144;
            scrollView.contentOffset = CGPointMake(0, Y);
        } else if(Y >= 0) {
            Y = 0;
        }
        CGRect frame = self.headerView.frame;
        frame.origin.y = Y;
        frame.size.height = self.headerH - Y;
        self.headerView.frame = frame;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    [self setNavTransparent];
    [self setupTableView];
    [self updateUI];
}

- (void)updateUI {
    self.headerView.userInfo = self.userInfo;
    self.navTitleLabel.text = self.userInfo.nick;
    self.navTitleLabel.hidden = !self.headerView.nickLabelStatus;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)tableViewDidPullUpRefresh:(ZGTableView *)tableView {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
