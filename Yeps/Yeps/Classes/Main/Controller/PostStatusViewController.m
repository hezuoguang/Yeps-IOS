//
//  PostStatusViewController.m
//  Yeps
//
//  Created by weimi on 16/3/20.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "PostStatusViewController.h"
#import "ZGEditTextView.h"
#import "ZGPickImageListView.h"
#import "ZGCreateVoteView.h"


#import <objc/runtime.h>
#import <UzysAssetsPickerController.h>

#define kTitleMaxLength 45

@interface PostStatusViewController()<ZGPickImageListViewDelegate, UIScrollViewDelegate, UITextViewDelegate, UzysAssetsPickerControllerDelegate>
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) ZGEditTextView *titleTexiView;
@property (nonatomic, weak) ZGEditTextView *contentTextView;
@property (nonatomic, weak) ZGPickImageListView *imageListView;
@property (nonatomic, weak) UILabel *titleTipLabel;
@property (nonatomic, weak) ZGCreateVoteView *voteView;
@property (nonatomic, assign) CGPoint contentOffset;

@end

@implementation PostStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor popBackGroundColor];
    self.typeStr = kTypeStrs[self.type];
    self.title = [NSString stringWithFormat:@"%@", self.typeStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem = right;
    
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameDidChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!objc_getAssociatedObject(self, _cmd)) {
        objc_setAssociatedObject(self, _cmd, @"POSTSTATUS", OBJC_ASSOCIATION_RETAIN);
        [self.titleTexiView becomeFirstResponder];
    }
}

- (void)keyBoardFrameDidChange:(NSNotification *)notifi {
    NSDictionary *userInfo = notifi.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGPoint contentOffset = self.contentOffset;
    if (frame.origin.y < self.view.bounds.size.height) {//键盘显示
        if (![self.titleTexiView isFirstResponder] && ![self.contentTextView isFirstResponder]) {
            CGFloat offsetY = [self.voteView inputFieldMinY] - 64;
            contentOffset = CGPointMake(contentOffset.x, offsetY);
        } else if([self.titleTexiView isFirstResponder]){
            CGFloat offsetY = CGRectGetMinX(self.titleTexiView.frame) - 64;
            contentOffset = CGPointMake(contentOffset.x, offsetY);
        } else if([self.contentTextView isFirstResponder]) {
            CGFloat offsetY = CGRectGetMinX(self.contentTextView.frame) - 64;
            contentOffset = CGPointMake(contentOffset.x, offsetY);
        } else {
            contentOffset = self.scrollView.contentOffset;
        }
    } else {
        contentOffset = self.scrollView.contentOffset;
    }
    self.contentOffset = self.scrollView.contentOffset;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentOffset = contentOffset;
    }];

}

- (void)setupUI {
    
    CGFloat maxW = self.view.bounds.size.width;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    ZGEditTextView *titleTextView = [[ZGEditTextView alloc] init];
    self.titleTexiView = titleTextView;
    titleTextView.delegate = self;
    titleTextView.returnKeyType = UIReturnKeyDone;
    titleTextView.minHeight = titleTextView.font.lineHeight * 3;
    titleTextView.maxHeight = titleTextView.font.lineHeight * 3;
    titleTextView.placeholder = [NSString stringWithFormat:@"填写%@的标题", self.typeStr];
    titleTextView.frame = CGRectMake(0, 0, maxW, titleTextView.minHeight);
    [scrollView addSubview:titleTextView];
    
    UILabel *titleTipLabel = [[UILabel alloc] init];
    self.titleTipLabel = titleTipLabel;
    titleTipLabel.textAlignment = NSTextAlignmentRight;
    titleTipLabel.frame = CGRectMake(titleTextView.bounds.size.width - 40, titleTextView.minHeight - 20, 30, 20);
    titleTipLabel.font = [UIFont systemFontOfSize:13];
    titleTipLabel.textColor = [UIColor popFontDisableColor];
    titleTipLabel.text = [NSString stringWithFormat:@"%d", kTitleMaxLength];
    [scrollView addSubview:titleTipLabel];
    
    ZGEditTextView *contentTextView = [[ZGEditTextView alloc] init];
    self.contentTextView = contentTextView;
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.minHeight = contentTextView.font.lineHeight * 9;
    contentTextView.maxHeight = contentTextView.font.lineHeight * 9;
    contentTextView.placeholder = [NSString stringWithFormat:@"填写%@的内容", self.typeStr];
    contentTextView.frame = CGRectMake(0, CGRectGetMaxY(titleTextView.frame) + 1, maxW, contentTextView.minHeight);
    contentTextView.delegate = self;
    [scrollView addSubview:contentTextView];
    
    ZGCreateVoteView *voteView = [[ZGCreateVoteView alloc] init];
    voteView.frame = CGRectMake(0, CGRectGetMaxY(self.contentTextView.frame) + 1, maxW, 1);
    voteView.hidden = YES;
    voteView.backgroundColor = [UIColor whiteColor];
    self.voteView = voteView;
    [scrollView addSubview:voteView];
    
    if (self.type == 1) {
        voteView.hidden = NO;
        voteView.frameDidChange = ^{
            [self updateSubViewsFrame];
        };
    }
    
    ZGPickImageListView *imageListView = [[ZGPickImageListView alloc] init];
    self.imageListView = imageListView;
    imageListView.frame = CGRectMake(0, CGRectGetMaxY(voteView.frame) + 1, maxW, 0);
    imageListView.delegate = self;
    [scrollView addSubview:imageListView];
    
    CGFloat maxH = CGRectGetMaxY(self.imageListView.frame);
    if (maxH < self.view.frame.size.height) {
        maxH = self.view.frame.size.height + 1;
    }
    
    scrollView.contentSize = CGSizeMake(0,  maxH);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView == self.titleTexiView) {
            [self.contentTextView becomeFirstResponder];
        } else if (textView == self.contentTextView) {
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.titleTexiView) {
        NSInteger length = textView.text.length;
        if (length > kTitleMaxLength) {
            textView.text = [textView.text substringToIndex:kTitleMaxLength];
            length = kTitleMaxLength;
        }
        length = kTitleMaxLength - length;
        self.titleTipLabel.text = [NSString stringWithFormat:@"%ld", (long)length];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)updateSubViewsFrame {
    CGRect imageListViewFrame = self.imageListView.frame;
    if (self.type != 1) {
        imageListViewFrame.origin.y = CGRectGetMaxY(self.contentTextView.frame) + 1;
    } else {
        imageListViewFrame.origin.y = CGRectGetMaxY(self.voteView.frame) + 1;
    }
    self.imageListView.frame = imageListViewFrame;
    CGFloat maxH = CGRectGetMaxY(self.imageListView.frame);
    if (maxH < CGRectGetMaxY(self.view.frame)) {
        maxH = CGRectGetMaxY(self.view.frame) + 1;
    }
    self.scrollView.contentSize = CGSizeMake(0,  maxH);
}

- (void)pickImageListViewHeightDidChange:(ZGPickImageListView *)pickImageListView {
    [self updateSubViewsFrame];
}

- (void)pickImageListViewDidClickAddImageButton:(ZGPickImageListView *)pickImageListView {
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor popColor];
//    appearanceConfig.assetsGroupSelectedImageName = @"checker";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionPhoto = self.imageListView.imageMaxCount - self.imageListView.imageCount;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker {
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    for (ALAsset *asset in assets) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [self.imageListView addImage:image];
    }
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker {
    [SVProgressHUD showErrorWithStatus:@"图片数量已满上限"];
}

- (void)dismiss {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validate {
    return YES;
}

- (void)publish {
    if (![self validate]) {
        return;
    }
    NSMutableDictionary *vote = [NSMutableDictionary dictionary];
    if (self.type == 1) {
        vote[@"vote_option"] = [self.voteView voteOptions];
        vote[@"end_time"] = @(4);
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK publishStatus:self.titleTexiView.text content:self.contentTextView.text image_list:self.imageListView.images type:self.type vote:vote success:^(id data) {
        [SVProgressHUD dismiss];
        [self dismiss];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"]];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
