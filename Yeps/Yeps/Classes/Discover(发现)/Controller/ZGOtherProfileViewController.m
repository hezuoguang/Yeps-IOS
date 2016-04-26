//
//  ZGOtherProfileViewController.m
//  Yeps
//
//  Created by weimi on 16/4/25.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGOtherProfileViewController.h"
#import "ZGOtherProfileHeaderView.h"
#import "UserInfoModel.h"
#import "UserBaseInfoModel.h"
#import "ZGOtherProfilePhotoCell.h"
#import "ZGOtherProfileCollectionHeaderView.h"
#import "ZGOtherProfilePhotoModel.h"
#import "StatusDetailViewController.h"

#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

#define kCellMargin 2
#define kCellWH (([UIScreen mainScreen].bounds.size.width - 2 * kCellMargin) / 3.0)
#define kHeaderW [UIScreen mainScreen].bounds.size.width
#define kHeaderH (414 + 44)

@interface ZGOtherProfileViewController ()<UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, weak) ZGOtherProfileCollectionHeaderView *headerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photos;

@end

static NSString *collectionCellID = @"ZGOtherProfilePhotoCell";
static NSString *collectionHeaderID = @"ZGOtherProfileCollectionHeaderView";

@implementation ZGOtherProfileViewController

- (NSMutableArray *)photos {
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = kCellMargin;
        flowLayout.minimumInteritemSpacing = kCellMargin;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView = collectionView;
        [collectionView registerClass:[ZGOtherProfilePhotoCell class] forCellWithReuseIdentifier:collectionCellID];
        [collectionView registerClass:[ZGOtherProfileCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor popBackGroundColor];
        collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getOtherUserInfo];
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)collectionView.mj_header;
        header.ignoredScrollViewContentInsetTop = -64;
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getImages];
        }];
        [self.view addSubview:collectionView];
    }
    return _collectionView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.frame = self.view.bounds;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
    }
    return _scrollView;
}

//- (ZGOtherProfileHeaderView *)headerView {
//    if (_headerView == nil) {
//        ZGOtherProfileHeaderView *headerView = [ZGOtherProfileHeaderView headerView];
//        _headerView = headerView;
//        self.headerViewHeight = headerView.frame.size.height;
//        headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.size.height);
//        [self.scrollView addSubview:headerView];
//    }
//    return _headerView;
//}

- (void)update {
    [self.collectionView reloadData];
    self.navigationItem.title = self.userInfo.nick;
}

- (void)setUserInfo:(UserInfoModel *)userInfo {
    _userInfo = userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor popBackGroundColor];
    [self updateScrollViewContentSize];
    
    self.navigationItem.title = self.userInfo.nick;
    if (self.userInfo.university == nil) {
        [self.collectionView.mj_header beginRefreshing];
    }
    [self.collectionView.mj_footer beginRefreshing];
}

- (void)updateScrollViewContentSize {
    self.scrollView.contentSize = CGSizeMake(0, self.headerView.frame.size.height + self.view.frame.size.height - 54 - 64);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGRect frame = self.headerView.frame;
        if (offsetY > 0) {
//            CGFloat maxOffsetY = self.headerViewHeight - 54 - 64;
//            if (offsetY >= maxOffsetY) {
//                frame.origin.y = offsetY - maxOffsetY;
//            }
            
        } else {
            frame.origin.y = offsetY;
            frame.size.height = self.headerViewHeight - offsetY;
        }
        self.headerView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZGOtherProfilePhotoCell *cell = (ZGOtherProfilePhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.photoModel = self.photos[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZGOtherProfileCollectionHeaderView *cell = (ZGOtherProfileCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderID forIndexPath:indexPath];
    cell.userInfo = self.userInfo;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellWH, kCellWH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kHeaderW, kHeaderH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ZGOtherProfilePhotoModel *model = self.photos[indexPath.row];
    StatusDetailViewController *detailVC = [[StatusDetailViewController alloc] init];
    detailVC.status_sha1 = model.status_sha1;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)getOtherUserInfo {
    [YepsSDK getOtherUserInfo:self.userInfo.user_sha1 success:^(id data) {
        [self.collectionView.mj_header endRefreshing];
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:data];
        self.userInfo = model;
        [self update];
    } error:^(id data) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"资料获取失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (void)getImages {
    NSInteger max_id = -1;
    if ([self.photos lastObject]) {
        ZGOtherProfilePhotoModel *model = self.photos.lastObject;
        max_id = model.image_id;
    }
    [YepsSDK getUserStatusImages:self.userInfo.user_sha1 max_id:max_id success:^(id data) {
        [self.collectionView.mj_footer endRefreshing];
        NSArray *images = data[@"image_list"];
        if (images.count == 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
            return;
        }
        NSArray *models = [ZGOtherProfilePhotoModel mj_objectArrayWithKeyValuesArray:images];
        [self.photos addObjectsFromArray:models];
        if (models.count < 30) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
        }
        [self.collectionView reloadData];
    } error:^(id data) {
        [self.collectionView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

@end
