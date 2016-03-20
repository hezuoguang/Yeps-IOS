//
//  PickTagsViewController.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "PickTagsViewController.h"
#import "ZGTagListView.h"
#import "ZGTagCollectionViewCell.h"

@interface PickTagsViewController()

@property (nonatomic, strong) NSMutableArray *selectTagList;
@property (nonatomic, weak) ZGTagListView *selectTagListView;
@property (nonatomic, weak) ZGTagListView *tagListView;
@property (nonatomic, weak) UIButton *closeBtn;

@end

@implementation PickTagsViewController

- (instancetype)initWithSelectTags:(NSArray *)tags {
    if (self = [super init]) {
        self.selectTagList = [NSMutableArray arrayWithArray:[tags copy]];
    }
    return self;
}

- (NSMutableArray *)selectTagList {
    if (_selectTagList == nil) {
        _selectTagList = [NSMutableArray array];
    }
    return _selectTagList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenW = self.view.bounds.size.width;
    CGFloat screenH = self.view.bounds.size.height;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor popFontGrayColor] forState:UIControlStateDisabled];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    closeBtn.bounds = CGRectMake(0, 0, screenW, 44);
    closeBtn.center = CGPointMake(self.view.center.x, screenH - 0.5 * CGRectGetHeight(closeBtn.bounds));
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = closeBtn;
    [self.view addSubview:closeBtn];
    
    ZGTagListView *selectTagListView = [[ZGTagListView alloc] init];
    selectTagListView.frame = CGRectMake(0, 0, screenW, 200);
    selectTagListView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [selectTagListView addTags:self.selectTagList];
    selectTagListView.didSelectTag = ^(NSString *tagName) {
        [self.tagListView addTag:tagName];
        [self updateCloseBtnStatus];
    };
    
    selectTagListView.backgroundColor = [UIColor popBorderColor];
    self.selectTagListView = selectTagListView;
    [self.view addSubview:selectTagListView];
    
    
    ZGTagListView *tagListView = [[ZGTagListView alloc] init];
    tagListView.frame = CGRectMake(0, CGRectGetMaxY(selectTagListView.frame), screenW, CGRectGetMinY(closeBtn.frame) - CGRectGetMaxY(selectTagListView.frame));
    tagListView.didSelectTag = ^(NSString *tagName){
        [self.selectTagList addObject:tagName];
        [self.selectTagListView addTag:tagName];
        [self updateCloseBtnStatus];
    };
    tagListView.cellStyle = ZGTagCollectionViewCellStyleHighlight;
    tagListView.backgroundColor = [UIColor popBorderColor];
    self.tagListView = tagListView;
    [self.view addSubview:tagListView];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"设置标签";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 20, screenW, 44);
    UIView *navgationBar = [[UIView alloc] init];
    navgationBar.frame = CGRectMake(0, 0, screenW, 64);
    navgationBar.backgroundColor = [UIColor popFontGrayColor];
    navgationBar.alpha = 0.95;
    [navgationBar addSubview:label];
    [self.view addSubview:navgationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self getTagList];
    [self updateCloseBtnStatus];
}

- (void)updateCloseBtnStatus {
    if (self.selectTagListView.tags.count > 0) {
        self.closeBtn.enabled = YES;
    } else {
        self.closeBtn.enabled = NO;
    }
    
}

- (void)getTagList {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK tagList:^(id data) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:data[@"tag_list"]];
        for (NSString *t in self.selectTagList) {
            for (NSString *tt in arrayM) {
                if ([tt isEqualToString:t]) {
                    [arrayM removeObject:tt];
                    break;
                }
            }
        }
        [self.tagListView addTags:arrayM];
        [SVProgressHUD dismiss];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:@"获取系统标签失败"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障"];
    }];
}

- (void)closeBtnClick {
    if (self.didSelectTagsBlock) {
        self.didSelectTagsBlock(self.selectTagListView.tags);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
