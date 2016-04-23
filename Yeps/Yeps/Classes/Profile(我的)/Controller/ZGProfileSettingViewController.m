//
//  ZGProfileSettingViewController.m
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGProfileSettingViewController.h"
#import "ZGProfileSettingItemCell.h"
#import "ZGProfileSettingItemModel.h"
#import "ZGProfileTool.h"
#import "UserTool.h"
#import "ZGModifyPwdViewController.h"
@interface ZGProfileSettingViewController ()<ZGProfileSettingItemCellDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation ZGProfileSettingViewController

- (NSArray *)items {
    if (_items == nil) {
        _items = [ZGProfileTool profileSettingItems];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height - 64);
    [self.view addSubview:scrollView];
    
    [self setupItemCell];
    
    self.title = @"设置";
    
}

- (void)setupItemCell {
    CGFloat maxW = self.view.bounds.size.width;
    CGFloat H = 44.0;
    CGFloat X = 0;
    CGFloat Y = 0;
    for (ZGProfileSettingItemModel *model in self.items) {
        ZGProfileSettingItemCell *cell = [[ZGProfileSettingItemCell alloc] init];
        cell.frame = CGRectMake(X, Y, maxW, H);
        cell.model = model;
        cell.delegate = self;
        [self.scrollView addSubview:cell];
        
        Y += H + 0.5;
    }
}

- (void)profileSettingItemCellDidClick:(ZGProfileSettingItemCell *)cell {
    if (cell.model.type == ZGProfileSettingItemTypeClearCache) {
        [self clearCacheAction:cell];
    } else if(cell.model.type == ZGProfileSettingItemTypeModifyPassword) {
        [self modifyPasswordAction];
    }
}

- (void)modifyPasswordAction {
    ZGModifyPwdViewController *vc = [ZGModifyPwdViewController initModifyPwdViewController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clearCacheAction:(ZGProfileSettingItemCell *)cell {
    [YepsSDK clearCache];
    cell.model = cell.model;
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
