//
//  RegisterStepEndViewController.m
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepEndViewController.h"
#import "ZGTextField.h"
#import "MainTabBarController.h"
#import "PickUniversityViewController.h"
#import "UploadImageTool.h"
#import "PickTagsViewController.h"
#import "ZGTagListView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserTool.h"

@interface RegisterStepEndViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIBarButtonItem *nextBtn;
@property (nonatomic, weak) UIButton *universityBtn;
@property (nonatomic, assign) NSUInteger sex;
@property (nonatomic, weak) UIButton *maleBtn;
@property (nonatomic, weak) UIButton *womanBtn;
@property (nonatomic, weak) UIImageView *photoView;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, weak) ZGTagListView *tagListView;
@property (nonatomic, weak) UILabel *tagTip;
@property (nonatomic, strong) NSArray *tagList;
@property (nonatomic, copy) NSString *university;
//状态标识 status | 1\ status | 2
@property (nonatomic, assign) NSInteger status;
@end

@implementation RegisterStepEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.status = 0;
    
    // Do any additional setup after loading the view.
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.backgroundColor = [UIColor popColor];
    photoView.bounds = CGRectMake(0, 0, 120, 120);
    photoView.center = CGPointMake(self.view.center.x, CGRectGetHeight(photoView.frame) + 20);
    photoView.layer.cornerRadius = photoView.bounds.size.width * 0.5;
    photoView.layer.masksToBounds = YES;
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoViewClick)];
    [photoView addGestureRecognizer:tap];
    self.photoView = photoView;
    [self.view addSubview:photoView];
    
    UIButton *universityBtn = [[UIButton alloc] init];
    universityBtn.frame = CGRectMake(0, CGRectGetMaxY(photoView.frame) + 20, screenW, 60);
    [universityBtn addTarget:self action:@selector(universityBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [universityBtn setTitle:@"点击选择您的学校" forState:UIControlStateNormal];
    [universityBtn setTitleColor:[UIColor popFontGrayColor] forState:UIControlStateNormal];
    self.universityBtn = universityBtn;
    [self.view addSubview:universityBtn];
    

    UIButton *maleBtn = [[UIButton alloc] init];
    maleBtn.frame = CGRectMake(0, screenH - 60, screenW * 0.5, 60);
    maleBtn.tag = 0;
    [maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [maleBtn setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    [maleBtn setTitleColor:[UIColor popColor] forState:UIControlStateSelected];
    [maleBtn addTarget:self action:@selector(switchSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.maleBtn = maleBtn;
    [self.view addSubview:maleBtn];
    
    UIButton *womanBtn = [[UIButton alloc] init];
    womanBtn.frame = CGRectMake(CGRectGetMaxX(maleBtn.frame), CGRectGetMinY(maleBtn.frame), screenW * 0.5, 60);
    womanBtn.tag = 1;
    [womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor popColor] forState:UIControlStateSelected];
    [womanBtn addTarget:self action:@selector(switchSexBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.womanBtn = womanBtn;
    [self.view addSubview:womanBtn];   
    self.view.backgroundColor = [UIColor whiteColor];
    
    //tags
    ZGTagListView *tagListView = [[ZGTagListView alloc] init];
    tagListView.frame = CGRectMake(20, CGRectGetMaxY(universityBtn.frame), screenW - 40, CGRectGetMinY(womanBtn.frame) - CGRectGetMaxY(universityBtn.frame));
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagListViewClick)];
    [tagListView addGestureRecognizer:tap2];
    
    UILabel *tagTip = [[UILabel alloc] init];
    tagTip.text = @"点击设置标签";
    tagTip.textColor = [UIColor popFontGrayColor];
    tagTip.frame = tagListView.bounds;
    tagTip.backgroundColor = [UIColor clearColor];
    tagTip.textAlignment = NSTextAlignmentCenter;
    [tagListView addSubview:tagTip];
    self.tagTip = tagTip;
    self.tagListView = tagListView;
    [self.view addSubview:tagListView];
    
    //    设置导航条信息
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextBtn = nextBtn;
    self.nextBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = nextBtn;
}

- (NSArray *)tagList {
    if (_tagList == nil) {
        _tagList = [NSArray array];
    }
    return _tagList;
}

- (void)tagListViewClick {
    PickTagsViewController *pick = [[PickTagsViewController alloc] initWithSelectTags:self.tagList];
    pick.didSelectTagsBlock = ^(NSArray *tags) {
        self.tagTip.hidden = tags.count != 0;
        self.tagList = tags;
        [self.tagListView setTags:tags];
        self.status |= (1 << 3);
        [self updateNextBtnStatus];
    };
    [self presentViewController:pick animated:YES completion:nil];
}


- (void)updateNextBtnStatus {
    if(self.status == 30) {
        self.nextBtn.enabled = YES;
    } else {
        self.nextBtn.enabled = NO;
    }
}

//头像被点击
- (void)photoViewClick {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    pick.mediaTypes = @[@"public.image"];
    pick.allowsEditing = YES;
    if (buttonIndex == 0) {//相机
        //判断是否有相机权限
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            //无权限
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相机“选项中，允许%@访问你的手机相机",@"Yeps"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    } else if(buttonIndex == 1) {//相册
        //判断是否有相册权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-照片“选项中，允许%@访问你的照片",@"Yeps"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:tips delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:pick animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    self.photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [UploadImageTool uploadimage:image success:^(NSString *url) {
        [SVProgressHUD dismiss];
        self.status |= (1 << 1);
        self.photo = url;
        [self updateNextBtnStatus];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
        self.photoView.image = nil;
        self.phone = nil;
        self.status &= ~(1 << 1);
        [self updateNextBtnStatus];
    }];
}


//切换性别
- (void)switchSexBtn:(UIButton *)btn {
    self.sex = btn.tag;
    self.status |= (1 << 4);
    [self updateNextBtnStatus];
    if (btn.tag == 0) {
        self.maleBtn.selected = YES;
        self.womanBtn.selected = NO;
    } else {
        self.maleBtn.selected = NO;
        self.womanBtn.selected = YES;
    }
}

//学校选择按钮被点击
- (void)universityBtnClick {
    PickUniversityViewController *pick = [[PickUniversityViewController alloc] init];
    pick.didPickUniversityBlock = ^(NSString *university) {
        self.university = [university copy];
        [self.universityBtn setTitle:university forState:UIControlStateNormal];
        [self.universityBtn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
        self.status |= (1 << 2);
        [self updateNextBtnStatus];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:pick animated:YES completion:nil];
}


//完成按钮被点击
- (void)next {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK registerWithPhone:self.phone nick:self.nick pwd:self.pwd photo:self.photo sex:self.sex tagList:self.tagList university:self.university success:^(id data) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[MainTabBarController alloc] init];
        [SVProgressHUD dismiss];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
    }];
}

@end
