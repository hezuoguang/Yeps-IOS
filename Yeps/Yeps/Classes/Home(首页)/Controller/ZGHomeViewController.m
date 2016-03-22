//
//  ZGHomeViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGHomeViewController.h"
#import "ZGStatusCell.h"
#import "StatusModel.h"
#import "StatusFrameModel.h"
#import <MJExtension.h>
#import "ZGTableView.h"
#import "ZGStatusTypeScrollView.h"
#import "StatusDetailViewController.h"
#import "ZGBarButtonItem.h"
#import "PickUniversityViewController.h"

@interface ZGHomeViewController ()<ZGTableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, weak) ZGTableView *tableView1;
@property (nonatomic, weak) ZGTableView *tableView2;
@property (nonatomic, strong) NSMutableArray *tableViewConentOffsets;
@property (nonatomic, strong) NSMutableArray *tableViewNoMoreDataStatus;
@property (nonatomic, strong) NSMutableArray *typeModels;
@property (nonatomic, weak) ZGStatusTypeScrollView *typeScrollView;
@property (nonatomic, assign) NSInteger curType;
@property (nonatomic, assign) CGRect leftFrame;
@property (nonatomic, assign) CGRect rightFrame;
@property (nonatomic, assign) CGRect midFrame;

@end

@implementation ZGHomeViewController

- (NSMutableArray *)tableViewConentOffsets {
    if (_tableViewConentOffsets == nil) {
        _tableViewConentOffsets = [NSMutableArray array];
        for (NSInteger i = 0; i < kTypeStrs.count; i++) {
            CGPoint offset = CGPointMake(0, -64 + kCellMargin);
            [_tableViewConentOffsets addObject:[NSValue valueWithCGPoint:offset]];
        }
    }
    return _tableViewConentOffsets;
}

- (NSMutableArray *)tableViewNoMoreDataStatus {
    if (_tableViewNoMoreDataStatus == nil) {
        _tableViewNoMoreDataStatus = [NSMutableArray array];
        for (NSInteger i = 0; i < kTypeStrs.count; i++) {
            [_tableViewNoMoreDataStatus addObject:@(0)];
        }
    }
    return _tableViewNoMoreDataStatus;
}

- (NSMutableArray *)typeModels {
    if (_typeModels == nil) {
        _typeModels = [NSMutableArray array];
        for (NSInteger i = 0; i < kTypeStrs.count; i++) {
            [_typeModels addObject:[NSMutableArray array]];
        }
    }
    return _typeModels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupData];
    
    [self setupTableView];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)leftSwipe {
    NSInteger type = (self.curType + 1) % kTypeStrs.count;
    [self.typeScrollView setSelectType:type];
}

- (void)rightSwipe {
    NSInteger type = (self.curType - 1);
    if (type == -1) {
        type = kTypeStrs.count - 1;
    }
    [self.typeScrollView setSelectType:type];
}

//初始默认参数
- (void)setupData {
    self.curType = 0;
    self.leftFrame = CGRectMake(-kMaxW, 0, kMaxW, kMaxH);
    self.midFrame = CGRectMake(0, 0, kMaxW, kMaxH);
    self.rightFrame = CGRectMake(kMaxW, 0, kMaxW, kMaxH);
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//初始化tableView
- (void)setupTableView {
    ZGTableView *tableView1 = [ZGTableView initWithDelegate:self dataSource:self extraPadding:0];
    self.tableView1 = tableView1;
    tableView1.type = 0;
    tableView1.frame = self.midFrame;
    [tableView1 beginRefresh];
    [self.view addSubview:tableView1];
    
    
    ZGTableView *tableView2 = [ZGTableView initWithDelegate:self dataSource:self extraPadding:0];
    self.tableView2 = tableView2;
    tableView2.type = 1;
    tableView2.frame = self.rightFrame;
    [self.view addSubview:tableView2];
    
    ZGStatusTypeScrollView *typeScrollView = [[ZGStatusTypeScrollView alloc] init];
    typeScrollView.frame = CGRectMake(0, 64, kMaxW, ktypeScrollViewH);
    typeScrollView.userInteractionEnabled = YES;
    typeScrollView.scrollEnabled = YES;
    typeScrollView.didSelectType = ^(NSInteger type) {
        [self.tableView1 stopAllRefresh];
        [self.tableView2 stopAllRefresh];
        if (type > self.curType) {//往左
            if(self.tableView1.frame.origin.x == 0) {//当前屏幕的tableView
                self.tableView2.frame = self.rightFrame;
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView1.frame = self.leftFrame;
                    self.tableView2.frame = self.midFrame;
                }];
            } else {
                self.tableView1.frame = self.rightFrame;
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView2.frame = self.leftFrame;
                    self.tableView1.frame = self.midFrame;
                }];
            }
        } else if(type < self.curType) {//往右
            if(self.tableView1.frame.origin.x == 0) {//当前屏幕的tableView
                self.tableView2.frame = self.leftFrame;
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView1.frame = self.rightFrame;
                    self.tableView2.frame = self.midFrame;
                }];
            } else {
                self.tableView1.frame = self.leftFrame;
                [UIView animateWithDuration:0.25 animations:^{
                    self.tableView2.frame = self.rightFrame;
                    self.tableView1.frame = self.midFrame;
                }];
            }
        }
        if (self.tableView1.frame.origin.x == 0) {
            self.tableView1.type = type;
            self.tableViewConentOffsets[self.curType] = [NSValue valueWithCGPoint:self.tableView2.contentOffset];
            NSLog(@"%ld --- %@",(long)type, self.tableViewConentOffsets[type]);
            /**
             *  恢复footer状态
             */
            NSNumber *noMoreStatus = self.tableViewNoMoreDataStatus[type];
            if (noMoreStatus.intValue == 1) {
                [self.tableView1 endRefreshingWithNoMoreData];
            } else {
                [self.tableView1 resetNoMoreData];
            }
            
            [self.tableView1 reloadData];
            self.tableView1.contentOffset = [self.tableViewConentOffsets[type] CGPointValue];
        } else {
            self.tableView2.type = type;
            self.tableViewConentOffsets[self.curType] = [NSValue valueWithCGPoint:self.tableView1.contentOffset];
            /**
             *  恢复footer状态
             */
            NSNumber *noMoreStatus = self.tableViewNoMoreDataStatus[type];
            if (noMoreStatus.intValue == 1) {
                [self.tableView2 endRefreshingWithNoMoreData];
            } else {
                [self.tableView2 resetNoMoreData];
            }
            [self.tableView2 reloadData];
            NSLog(@"%ld --- %@",(long)type, self.tableViewConentOffsets[type]);
            self.tableView2.contentOffset = [self.tableViewConentOffsets[type] CGPointValue];
        }
        self.curType = type;
    };
    self.typeScrollView = typeScrollView;
//    [self.view addSubview:typeScrollView];
    self.navigationItem.titleView = self.typeScrollView;
    
    self.navigationItem.rightBarButtonItem = [ZGBarButtonItem rightBarButtonItemWithImage:@"u_group" highlightImage:@"u_group_h" addTarget:self action:@selector(universityGroup) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [ZGBarButtonItem leftBarButtonItemWithImage:@"dingwei" highlightImage:@"dingwei_h" addTarget:self action:@selector(switchActiveUniversity) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)universityGroup {
    NSLog(@"----");
}

- (void)switchActiveUniversity {
    PickUniversityViewController *pick = [[PickUniversityViewController alloc] init];
    pick.didPickUniversityBlock = ^(NSString *text){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [YepsSDK switchActiveUniversity:text success:^(id data) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
            self.typeModels = nil;
            [self.tableView1 reloadData];
            [self.tableView2 reloadData];
            [self.tableView1 beginRefresh];
            [self.tableView2 beginRefresh];
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"]];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络故障"];
        }];
    };
    [self presentViewController:pick animated:YES completion:nil];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(ZGTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *models = self.typeModels[tableView.type];
    if (models.count == 0 && tableView.type != 0) {
        [tableView beginRefresh];
    }
    return models.count;
}

- (UITableViewCell *)tableView:(ZGTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *models = self.typeModels[tableView.type];
    ZGStatusCell *cell = [ZGStatusCell statusCellWithTableView:tableView];
    StatusFrameModel *statusF = models[indexPath.row];
    cell.statusF = statusF;
    return cell;
    
}

- (CGFloat)tableView:(ZGTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *models = self.typeModels[tableView.type];
    StatusFrameModel *statusF = models[indexPath.row];
    return statusF.height;
}

- (void)tableView:(ZGTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StatusDetailViewController *vc = [[StatusDetailViewController alloc] init];
    NSMutableArray *models = self.typeModels[tableView.type];
    StatusFrameModel *statusF = models[indexPath.row];
    StatusFrameModel *detailF = [[StatusFrameModel alloc] init];
    detailF.style = StatusCellFrameStyleDetail;
    detailF.status = statusF.status;
    vc.statusF = detailF;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewDidRefresh:(ZGTableView *)tableView {
    NSMutableArray *models = self.typeModels[tableView.type];
    StatusFrameModel *modelF = models.firstObject;
    StatusModel *model = modelF.status;
    NSInteger since_id = -1;
    NSInteger type = tableView.type;
    if (modelF) {
        since_id = model.status_id;
    }
    [YepsSDK getNewStatus:since_id type:type success:^(id data) {
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
        [models insertObjects:statusFrameList atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, statusFrameList.count)]];
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
    NSMutableArray *models = self.typeModels[tableView.type];
    StatusFrameModel *modelF = models.lastObject;
    StatusModel *model = modelF.status;
    NSInteger max_id = -1;
    NSInteger type = tableView.type;
    if (modelF) {
        max_id = model.status_id;
    }
    [YepsSDK getOldStatus:max_id type:type success:^(id data) {
        [tableView stopPullUpRefresh];
        NSArray *statuses = data;
        if (statuses.count == 0) {
            [tableView endRefreshingWithNoMoreData];
            self.tableViewNoMoreDataStatus[tableView.type] = @(1);
            return;
        }
        NSArray *statusModelList = [StatusModel mj_objectArrayWithKeyValuesArray:statuses];
        NSMutableArray *statusFrameList = [NSMutableArray array];
        for (StatusModel *status in statusModelList) {
            StatusFrameModel *frameModel = [[StatusFrameModel alloc] init];
            frameModel.status = status;
            [statusFrameList addObject:frameModel];
        }
        [models addObjectsFromArray:statusFrameList];
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
