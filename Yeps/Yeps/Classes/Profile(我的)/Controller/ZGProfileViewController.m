//
//  ZGProfileViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UzysAssetsPickerController/UzysAssetsPickerController.h>
#import "ZGProfileViewController.h"
#import "ZGProfileHeaderView.h"
#import "MainNavigationController.h"
#import "UserTool.h"
#import "UserInfoModel.h"
#import "StatusModel.h"
#import "ZGBarButtonItem.h"
#import "ZGProfileSettingItemCell.h"
#import "ZGProfileSettingItemModel.h"
#import "ZGProfileTool.h"
#import "ZGShareView.h"
#import "UnLoginViewController.h"
#import "ZGProfileSettingViewController.h"
#import "ZGEditProfileViewController.h"
#import "PickTagsViewController.h"
#import "ZGEditIntroViewController.h"

@interface ZGProfileViewController ()<UIScrollViewDelegate, ZGProfileSettingItemCellDelegate, UIAlertViewDelegate, UzysAssetsPickerControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ZGProfileHeaderViewDelegate>

@property (nonatomic, weak) ZGProfileHeaderView *headerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic, assign) CGFloat headerH;
@property (nonatomic, weak) UILabel *navTitleLabel;
@property (nonatomic, strong) NSArray *settingItems;
@property (nonatomic, weak) UIView *itemsView;
@property (nonatomic, assign) BOOL navIsHide;
//@property (nonatomic, weak) ZGProfileSettingItemCell *claerCacheCell;

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
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrollView];
    }
    return _scrollView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHeaderView:self.scrollView];
    [self update];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [self updateHeaderView:self.scrollView];
    }];
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self resetNavTransparent];
//}

- (NSArray *)settingItems {
    if (_settingItems == nil) {
        _settingItems = [ZGProfileTool profileItems];
    }
    return _settingItems;
}

- (ZGProfileHeaderView *)headerView {
    if (_headerView == nil) {
        ZGProfileHeaderView *headerView = [ZGProfileHeaderView profileHeaderView];
        _headerView = headerView;
        self.headerH = headerView.frame.size.height;
        headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.headerH);
        headerView.delegate = self;
        [self.scrollView addSubview:_headerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViweDidClick)];
        [headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

/** 更新headerView 信息 以及 navgationTitleView 标题*/
- (void)update {
    self.userInfo = nil;
    self.headerView.userInfo = self.userInfo;
    self.navTitleLabel.text = self.userInfo.nick;
}

- (UserInfoModel *)userInfo {
    if (_userInfo == nil) {
        _userInfo = [UserTool getCurrentUserInfo];
    }
    return _userInfo;
}

- (void)setNavTransparent {
    self.navIsHide = YES;
    MainNavigationController *nav = (MainNavigationController *)self.navigationController;
    [nav setTransparent];
}

- (void)resetNavTransparent {
    self.navIsHide = NO;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        [self updateHeaderView:scrollView];
    }
}

- (void)updateHeaderView:(UIScrollView *)scrollView {
    CGFloat Y = scrollView.contentOffset.y;
    if (Y >= 105) {
        if (self.navIsHide) {
            [self resetNavTransparent];
            self.navTitleLabel.hidden = NO;
            [self.headerView setNickLabelStatus:!self.navTitleLabel.hidden];
        }
    } else if(!self.navIsHide) {
        [self setNavTransparent];
        self.navTitleLabel.hidden = YES;
        [self.headerView setNickLabelStatus:!self.navTitleLabel.hidden];
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
    CGRect f = self.itemsView.frame;
    f.origin.y = CGRectGetMaxY(self.headerView.frame);
    self.itemsView.frame = f;
}

- (void)setupSettingItems {
    UIView *itemsView = [[UIView alloc] init];
    self.itemsView = itemsView;
    [self.view addSubview:itemsView];
    CGFloat maxW = self.view.bounds.size.width;
    CGFloat H = 44.0;
    CGFloat X = 0;
    CGFloat Y = 0;
    for (NSArray *array in self.settingItems) {
        for (ZGProfileSettingItemModel *model in array) {
            ZGProfileSettingItemCell *cell = [[ZGProfileSettingItemCell alloc] init];
            cell.frame = CGRectMake(X, Y, maxW, H);
            cell.model = model;
            cell.delegate = self;
            [itemsView addSubview:cell];
//            if (model.type == ZGProfileSettingItemTypeClearCache) {
//                self.claerCacheCell = cell;
//            }
            Y += H + 0.5;
        }
        Y += 20;
    }
    itemsView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), maxW, Y + H + 10);
    [self.scrollView addSubview:itemsView];
    CGFloat offsetY = self.view.bounds.size.height + self.headerH - 64;
    if (CGRectGetMaxY(itemsView.frame) > offsetY) {
        offsetY = CGRectGetMaxY(itemsView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(0, offsetY);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    self.navigationItem.rightBarButtonItem = [ZGBarButtonItem rightBarButtonItemWithImage:@"setting" highlightImage:@"setting_h" addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setupSettingItems];
    [self updateUI];
    [self getSelfInfo];
}

/** push 之前做一些事情*/
- (void)didPush:(void(^)())complete {
    [self getSelfInfo];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.scrollView.contentOffset.y < self.headerH - 64) {
            self.scrollView.contentOffset = CGPointMake(0, self.headerH - 64);
        }
    } completion:^(BOOL finished) {
        [self updateHeaderView:self.scrollView];
        if(complete) {
            complete();
        }
    }];
}

- (void)rightBarButtonClick {
    [self didPush:^{
        ZGProfileSettingViewController *vc = [[ZGProfileSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)updateUI {
    self.headerView.userInfo = self.userInfo;
    self.navTitleLabel.text = self.userInfo.nick;
    self.navTitleLabel.hidden = !self.headerView.nickLabelStatus;
}

- (void)profileSettingItemCellDidClick:(ZGProfileSettingItemCell *)cell {
    switch (cell.model.type) {
        case ZGProfileSettingItemTypeTag:{
            [self tagAction];
            break;
        }
        case ZGProfileSettingItemTypeInfo:{
            [self infoAction];
            break;
        }
        case ZGProfileSettingItemTypeAbout:{
            [self aboutAction];
            break;
        }
        case ZGProfileSettingItemTypeShare:{
            [self shareAction];
            break;
        }
        case ZGProfileSettingItemTypeLogout:{
            [self logoutAction];
            break;
        }
        case ZGProfileSettingItemTypeMessage:{
            [self messgeAction];
            break;
        }
//        case ZGProfileSettingItemTypeClearCache:{
//            [self clearCacheAction];
//            break;
//        }
//        case ZGProfileSettingItemTypeModifyPassword:{
//            [self modifyPasswordAction];
//            break;
//        }
        default:
            break;
    }
}

- (void)shareAction {
    ZGShareView *shareView = [ZGShareView shareInstance];
    shareView.shareUrl = @"http://yeps.dev4app.com";
    shareView.shareTitle = @"Yeps 分享校园生活";
    shareView.shareContent = @"小伙伴们,来Yeps分享你们的校园生活吧!";
    shareView.shareImage = [UIImage imageNamed:@"share_image"];
    [shareView show];
}

- (void)logoutAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [YepsSDK logout];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            MainNavigationController *nav = [[MainNavigationController alloc] init];
            UnLoginViewController *unLoginVC = [[UnLoginViewController alloc] init];
            [nav pushViewController:unLoginVC animated:NO];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        });
    }
}


- (void)aboutAction {
    
}

- (void)infoAction {
    [self didPush:^{
        ZGEditProfileViewController *vc = [ZGEditProfileViewController initEditProfileViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)tagAction {
    PickTagsViewController *vc = [[PickTagsViewController alloc] initWithSelectTags:[UserTool getCurrentUserInfo].tag_list];
    vc.didSelectTagsBlock = ^(NSArray *tags) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [YepsSDK updateTagList:tags success:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功" maskType:SVProgressHUDMaskTypeGradient];
            [self dismissViewControllerAnimated:YES completion:nil];
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
        } failure:^(NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"修改失败" maskType:SVProgressHUDMaskTypeGradient];
        }];
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)messgeAction {
    
}

//- (void)clearCacheAction {
//    [YepsSDK clearCache];
//    self.claerCacheCell.model = self.claerCacheCell.model;
//}
//
//- (void)modifyPasswordAction {
//    
//}

- (void)headViweDidClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"选择操作" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"更换头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateImageWithType:1];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"更换背景图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateImageWithType:0];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"编辑个性签名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editIntro];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/** 更换图片 0 背景图片, 1 头像*/
- (void)updateImageWithType:(NSInteger)type {
    if (type == 0) {
        UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
        appearanceConfig.finishSelectionButtonColor = [UIColor popColor];
        [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        picker.maximumNumberOfSelectionPhoto = 1;
        [self presentViewController:picker animated:YES completion:nil];
    } else if (type == 1) {
        //判断是否有相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-照片“选项中，允许%@访问你的照片",@"Yeps"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        [MainNavigationController resetTransparent:pick];
        pick.delegate = self;
        pick.mediaTypes = @[@"public.image"];
        pick.allowsEditing = YES;
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pick animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK updatePhoto:image success:^(id data) {
        [SVProgressHUD dismiss];
        [self update];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"头像上传失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets.count > 0) {
        ALAsset *asset = assets[0];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [YepsSDK updateProfileBackImage:image success:^(id data) {
            [SVProgressHUD dismiss];
            [self update];
        } error:^(id data) {
            [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"背景上传失败" maskType:SVProgressHUDMaskTypeGradient];
        }];
    }
    
}

- (void)editIntro {
    ZGEditIntroViewController *vc = [[ZGEditIntroViewController alloc] init];
    vc.editSuccess = ^(NSString *intro) {
        [self update];
    };
    vc.intro = self.headerView.userInfo.intro;
    MainNavigationController *nav = [[MainNavigationController alloc] init];
    [nav pushViewController:vc animated:NO];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getSelfInfo {
    [YepsSDK getUserInfo:^(id data) {
        [self update];
    } error:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)profileHeaderViewHeaderViewButtonDidClick:(ZGProfileHeaderView *)headerView type:(ZGProfileHeaderViewButtonType)type {
    switch (type) {
        case ZGProfileHeaderViewButtonTypeFans:
            
            break;
        case ZGProfileHeaderViewButtonTypeFollow:
            
            break;
        case ZGProfileHeaderViewButtonTypeStatus:{
            [self didPush:^{
                [ZGProfileTool popToUserStatusListViewController:headerView.userInfo nav:self.navigationController];
            }];
            break;
        }
        default:
            break;
    }
}


@end
