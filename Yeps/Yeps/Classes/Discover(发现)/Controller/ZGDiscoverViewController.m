//
//  ZGDiscoverViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGDiscoverViewController.h"
#import "ZGOtherProfileHeaderView.h"
#import "UserInfoModel.h"
#import "UserTool.h"
#import "ZGOtherProfileViewController.h"
#import "ZGBarButtonItem.h"
#import "ZGSearchUserViewController.h"

#import <MJExtension/MJExtension.h>

#import <pop/POP.h>
#define kBtnViewH 120
#define kBtnWH 80
#define kHeaderViewOutPadding 6
#define kHeaderViewCount 4
#define kHeaderViewPadding 10
#define kHeaderViewY (kHeaderViewPadding + 64)
//#define kHeaderViewMinHeight 350
#define kHeaderViewMinHeight ([UIScreen mainScreen].bounds.size.height - kHeaderViewY - 49 - kBtnViewH)
#define kHeaderViewMaxHeigth (414 + 44)
#define kHeaderViewMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define kHeaderViewMinWidth (kHeaderViewMaxWidth - 2 * kHeaderViewPadding)


@interface ZGDiscoverViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger currnetIndex;
@property (nonatomic, weak) UIView *headerViewBackView;
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, strong) NSMutableArray *headerViewFrames;
@property (nonatomic, weak) UIView *btnView;
@property (nonatomic, weak) UIButton *likeBtn;
@property (nonatomic, weak) UIButton *unLikeBtn;
@property (nonatomic, weak) UIView *tapView;
//是否正在获取数据
@property (nonatomic, assign) BOOL isGetData;
//是否可以获取数据 NO 允许 YES 不允许
@property (nonatomic, assign) BOOL cannotGetData;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, assign) BOOL isFirstGetData;

@property (nonatomic, assign) CGRect likeF;
@property (nonatomic, assign) CGRect unLikeF;


@end

@implementation ZGDiscoverViewController

- (UIView *)btnView {
    if (_btnView == nil) {
        UIView *view = [[UIView alloc] init];
        _btnView = view;
        CGRect frame = [self.headerViewFrames.lastObject CGRectValue];
        CGFloat Y = CGRectGetMaxY(frame);
        CGFloat H = self.view.bounds.size.height - Y - 49;
        view.frame = CGRectMake(0, Y, self.view.bounds.size.width, H);
//        view.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nothing)];
        [view addGestureRecognizer:tap];
        [self.view insertSubview:view atIndex:0];
    }
    return _btnView;
}

- (UIView *)tapView {
    if (_tapView == nil) {
        UIView *tapView = [[UIView alloc] init];
        CGRect frame = [self.headerViewFrames.firstObject CGRectValue];
        tapView.frame = frame;
        tapView.backgroundColor = [UIColor clearColor];
        _tapView = tapView;
        [self.view addSubview:_tapView];
    }
    return _tapView;
}

- (void)nothing {
    
}

- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (UIView *)headerViewBackView {
    if (_headerViewBackView == nil) {
        UIView *headerViewBackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _headerViewBackView = headerViewBackView;
        headerViewBackView.userInteractionEnabled = NO;
        [self.view addSubview:headerViewBackView];
    }
    return _headerViewBackView;
}

- (NSMutableArray *)headerViewFrames {
    if (_headerViewFrames == nil) {
        CGFloat X = 0;
        CGFloat Y = 0;
        CGFloat W = 0;
        CGFloat H = 0;
        _headerViewFrames = [NSMutableArray array];
        for (NSInteger i = 0; i < kHeaderViewCount; i++) {
            NSInteger index = i;
            if (index == kHeaderViewCount - 1) {
                index--;
            }
            X = kHeaderViewPadding + index * kHeaderViewOutPadding;
            Y = kHeaderViewY + 2 * index * kHeaderViewOutPadding;
            W = kHeaderViewMaxWidth - 2 * X;
            H = kHeaderViewMinHeight - index * kHeaderViewOutPadding;
            CGRect frame = CGRectMake(X, Y, W, H);
            [_headerViewFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
    return _headerViewFrames;
}

- (NSMutableArray *)headerViews {
    if (_headerViews == nil) {
        _headerViews = [NSMutableArray array];
        for (NSInteger i = 0; i < kHeaderViewCount; i++) {
            ZGOtherProfileHeaderView *headerView = [ZGOtherProfileHeaderView headerView];
            headerView.frame = [self.headerViewFrames[i] CGRectValue];
            [headerView miniStyle];
            [self.headerViewBackView insertSubview:headerView atIndex:0];
            [_headerViews addObject:headerView];
        }
        
    }
    return _headerViews;
}

//获得当前第一个HeaderView
- (ZGOtherProfileHeaderView *)getCurrentFirstHeaderView {
    ZGOtherProfileHeaderView *headerView = [self.headerViews objectAtIndex:self.currnetIndex % kHeaderViewCount];
    return headerView;
}

//滑动中
- (void)updateHeaderViewsWithOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY{
    
    ZGOtherProfileHeaderView *headerView = [self getCurrentFirstHeaderView];
    CGPoint center = headerView.center;
    center.x += offsetX;
    center.y += offsetY;
    headerView.center = center;
    CGRect firstFrame = [[self.headerViewFrames firstObject] CGRectValue];
    CGFloat curX = headerView.center.x;
    CGFloat curY = headerView.center.y;
    CGFloat centerX = CGRectGetMidX(firstFrame);
    CGFloat centerY = CGRectGetMidY(firstFrame);
//    CGFloat midX = centerX * 0.5;
    CGFloat tmpX = fabs(curX - centerX);
    CGFloat tmpY = fabs(curY - centerY);
    CGFloat progress = 0;
    if (tmpX >= 15 || tmpY >= 15) {
        if (tmpX >= 15 && tmpY >= 15) {
            progress = tmpX > tmpY ? tmpX : tmpY;
        } else {
            progress = tmpX >= 15 ? tmpX : tmpY;
        }
    }
    progress = progress / (centerX * 0.75) * kHeaderViewOutPadding;
    if (progress > kHeaderViewOutPadding) {
        progress = kHeaderViewOutPadding;
    }
    CGRect unLikeF = self.unLikeF;
    CGRect likeF = self.likeF;
    if (curX <= centerX) {//左滑
        unLikeF.size.width += 2 * progress;
        unLikeF.size.height += 2 * progress;
        unLikeF.origin.x -= progress;
        unLikeF.origin.y -= progress;
    } else {//右滑
        likeF.size.width += 2 * progress;
        likeF.size.height += 2 * progress;
        likeF.origin.x -= progress;
        likeF.origin.y -= progress;
    }
    self.likeBtn.frame = likeF;
    self.unLikeBtn.frame = unLikeF;
    
    for (NSInteger i = 1; i < kHeaderViewCount; i++) {
        if (i == kHeaderViewCount - 1) {
            continue;
        }
        NSInteger index = (self.currnetIndex + i) % kHeaderViewCount;
        ZGOtherProfileHeaderView *view = [self.headerViews objectAtIndex:index];
        CGRect frame = [[self.headerViewFrames objectAtIndex:i] CGRectValue];
        frame.size.width += 2 * progress;
        frame.origin.x -= progress;
        frame.origin.y -= 2 * progress;
        frame.size.height += progress;
        view.frame = frame;
    }
}

//滑出
- (void)slideOut:(BOOL)isLeft {
    self.view.userInteractionEnabled = NO;
    UserInfoModel *model = self.models[self.currnetIndex];
    [YepsSDK matchOption:model.user_sha1 is_match:!isLeft success:nil error:nil failure:nil];
    ZGOtherProfileHeaderView *headerView = [self getCurrentFirstHeaderView];
    CGFloat centerX = -(headerView.frame.size.width * 0.5);
    if (!isLeft) {
        centerX = self.view.bounds.size.width - centerX;
    }
    for (NSInteger i = 1; i < kHeaderViewCount; i++) {
        NSInteger index = (self.currnetIndex + i) % kHeaderViewCount;
        ZGOtherProfileHeaderView *view = [self.headerViews objectAtIndex:index];
        CGRect frame = [[self.headerViewFrames objectAtIndex:i - 1] CGRectValue];
        [UIView animateWithDuration:0.1 animations:^{
            view.frame = frame;
        }];
    }
    [UIView animateWithDuration:0.25 animations:^{
        headerView.center = CGPointMake(centerX, headerView.center.y);
        self.likeBtn.frame = self.likeF;
        self.unLikeBtn.frame = self.unLikeF;
    } completion:^(BOOL finished) {
        [headerView removeFromSuperview];
        headerView.frame = [self.headerViewFrames[kHeaderViewCount - 1] CGRectValue];
        [self.headerViewBackView insertSubview:headerView atIndex:0];
        self.view.userInteractionEnabled = self.currnetIndex < self.models.count;
        [self updateHeaderViewUserInfo];
    }];
    self.currnetIndex ++;
    if (self.currnetIndex == self.models.count) {
        self.view.userInteractionEnabled = NO;
        if (self.cannotGetData) {
            [SVProgressHUD showErrorWithStatus:@"没有下一个了" maskType:SVProgressHUDMaskTypeGradient];
//            [SVProgressHUD showErrorWithStatus: maskType:SVProgressHUDMaskTypeGradient];
            self.view.userInteractionEnabled = NO;
            return;
        }
        if (self.isGetData) {
            [SVProgressHUD show];
            self.isFirstGetData = YES;
        }
    } else if(self.currnetIndex + 10 >= self.models.count) {
        [self recommendUserList];
    }
}

//左滑
- (void)leftSlideOut {
    [self slideOut:YES];
}

//右滑
- (void)rightSlideOut {
    [self slideOut:NO];
}

//恢复
- (void)resetSlide {
    self.view.userInteractionEnabled = NO;
    for (NSInteger i = kHeaderViewCount - 1; i >= 0; i--) {
        NSInteger index = (self.currnetIndex + i) % kHeaderViewCount;
        ZGOtherProfileHeaderView *view = [self.headerViews objectAtIndex:index];
        POPSpringAnimation *anima = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anima.fromValue = [NSValue valueWithCGRect:view.frame];
        anima.toValue = self.headerViewFrames[i];
        if (i == 0) {//当前显示的HeaderView
            anima.springBounciness = 6;
            anima.completionBlock = ^(POPAnimation *anim, BOOL complete) {
                if (complete) {
                    self.view.userInteractionEnabled = self.currnetIndex < self.models.count;
                }
            };
        }
        [view pop_addAnimation:anima forKey:kPOPViewFrame];
    }
    
    POPSpringAnimation *anima0 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anima0.fromValue = [NSValue valueWithCGRect:self.likeBtn.frame];
    anima0.toValue = [NSValue valueWithCGRect:self.likeF];
    anima0.springBounciness = 15;
    [self.likeBtn pop_addAnimation:anima0 forKey:kPOPViewFrame];
    
    POPSpringAnimation *anima1 = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anima1.fromValue = [NSValue valueWithCGRect:self.unLikeBtn.frame];
    anima1.toValue = [NSValue valueWithCGRect:self.unLikeF];
    anima1.springBounciness = 15;
    [self.unLikeBtn pop_addAnimation:anima1 forKey:kPOPViewFrame];
    
}

//滑动结束
- (void)moveEndHeaderViews{
    
    CGFloat centerX = self.headerViewBackView.center.x;
//    CGFloat midX = centerX * 0.5;
    ZGOtherProfileHeaderView *headerView = [self getCurrentFirstHeaderView];
    if (CGRectGetMaxX(headerView.frame) <= centerX) {
        [self leftSlideOut];
    } else if(CGRectGetMinX(headerView.frame) >= centerX) {
        [self rightSlideOut];
    } else {
        [self resetSlide];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self getCurrentFirstHeaderView] update];
    if (self.isFirstGetData) {
        [SVProgressHUD show];
        self.view.userInteractionEnabled = NO;
        [self recommendUserList];
    } else {
        [self resetSlide];
        if (self.currnetIndex >= self.models.count) {
            [SVProgressHUD show];
            self.currnetIndex = 0;
            self.headerViews = nil;
            self.isFirstGetData = YES;
            self.cannotGetData = NO;
            self.models = nil;
            self.view.userInteractionEnabled = NO;
            [self recommendUserList];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isFirstGetData && self.isGetData) {
        [SVProgressHUD dismiss];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isFirstGetData && self.isGetData) {
        [SVProgressHUD dismiss];
    }
}

- (void)setupButtons {
    CGRect btnViewFrame = self.btnView.frame;
    CGFloat midW = btnViewFrame.size.width * 0.5;
    CGFloat maxH = btnViewFrame.size.height;
    CGFloat X = (midW - kBtnWH) * 0.5;
    CGFloat Y = (maxH - kBtnWH) * 0.5;
    CGRect unlikeBtnF = CGRectMake(X, Y, kBtnWH, kBtnWH);
    UIButton *unlikeBtn = [[UIButton alloc] initWithFrame:unlikeBtnF];
    self.unLikeBtn = unlikeBtn;
    [unlikeBtn addTarget:self action:@selector(leftSlideOut) forControlEvents:UIControlEventTouchUpInside];
    [unlikeBtn setBackgroundImage:[UIImage imageNamed:@"un_like_btn"] forState:UIControlStateNormal];
    [unlikeBtn setBackgroundImage:[UIImage imageNamed:@"un_like_btn"] forState:UIControlStateHighlighted];
    [self.btnView addSubview:unlikeBtn];
    
    CGRect likeBtnF = CGRectMake(midW + X, Y, kBtnWH, kBtnWH);
    UIButton *likeBtn = [[UIButton alloc] initWithFrame:likeBtnF];
    [likeBtn addTarget:self action:@selector(rightSlideOut) forControlEvents:UIControlEventTouchUpInside];
    self.likeBtn = likeBtn;
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
    [likeBtn setBackgroundImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateHighlighted];
    [self.btnView addSubview:likeBtn];
    
    self.likeF = likeBtnF;
    self.unLikeF = unlikeBtnF;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor popBackGroundColor];
    self.navigationItem.title = @"发现";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToProfileDetail)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.isFirstGetData = YES;
    
    self.navigationItem.rightBarButtonItem = [ZGBarButtonItem rightBarButtonItemWithImage:@"search_user" highlightImage:@"search_user_h" addTarget:self action:@selector(searchUser) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupButtons];
}

- (void)searchUser {
    ZGSearchUserViewController *vc = [[ZGSearchUserViewController alloc] init];
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)updateHeaderViewUserInfo {
    NSInteger index = self.currnetIndex % kHeaderViewCount;
    BOOL flag = YES;
    for (NSInteger i = 0; i < kHeaderViewCount; i++) {
        NSInteger j = self.currnetIndex + i;
        ZGOtherProfileHeaderView *view = self.headerViews[(index + i) % kHeaderViewCount];
        if (j >= self.models.count) {
            view.userInfo = nil;
            view.hidden = YES;
        } else {
            view.hidden = NO;
            flag = NO;
            view.userInfo = self.models[j];
        }
    }
    if (flag) {
        self.btnView.hidden = YES;
    } else {
        self.btnView.hidden = NO;
    }
}

- (void)recommendUserList {
    if(self.isGetData || self.cannotGetData) return;
    self.isGetData = YES;
    NSInteger max_id = -1;
    if (self.models.lastObject) {
        UserInfoModel *infoModel = self.models.lastObject;
        max_id = infoModel.recommend_id;
    }
    NSInteger count = 40;
    [YepsSDK recommendUserList:max_id count:40 success:^(id data) {
        NSArray *array = data[@"user_list"];
        if (array.count < count) {
            self.cannotGetData = YES;
        }
        if(array.count) {
            NSArray *models = [UserInfoModel mj_objectArrayWithKeyValuesArray:array];
            [self.models addObjectsFromArray:models];
        }
        self.isGetData = NO;
        if (self.isFirstGetData) {
            [SVProgressHUD dismiss];
            self.isFirstGetData = NO;
            self.view.userInteractionEnabled = YES;
            [self updateHeaderViewUserInfo];
        }
    } error:^(id data) {
        self.isGetData = NO;
        if (self.isFirstGetData) {
//            [SVProgressHUD showErrorWithStatus:@"先去别处逛逛吧!" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:@"没有推荐了,先去别处逛逛吧!" maskType:SVProgressHUDMaskTypeGradient];
            [self updateHeaderViewUserInfo];
        }
    } failure:^(NSError *error) {
        self.isGetData = NO;
        if (self.isFirstGetData) {
//            [SVProgressHUD showErrorWithStatus:@"先去别处逛逛吧!" maskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showErrorWithStatus:@"没有推荐了,先去别处逛逛吧!" maskType:SVProgressHUDMaskTypeGradient];
            [self updateHeaderViewUserInfo];
        }
    }];
}

- (void)popToProfileDetail {
    ZGOtherProfileViewController *vc = [[ZGOtherProfileViewController alloc] init];
    vc.userInfo = [self getCurrentFirstHeaderView].userInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.headerViewBackView];
    CGPoint prePoint = [touch previousLocationInView:self.headerViewBackView];
    CGFloat offsetX = curPoint.x - prePoint.x;
    CGFloat offsetY = curPoint.y - prePoint.y;
    
    [self updateHeaderViewsWithOffsetX:offsetX offsetY:offsetY];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveEndHeaderViews];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveEndHeaderViews];
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
