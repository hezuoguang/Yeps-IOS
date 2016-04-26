//
//  ZGEditIntroViewController.m
//  Yeps
//
//  Created by weimi on 16/4/24.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGEditIntroViewController.h"
#import "ZGEditTextView.h"

#define kIntroMaxLength 90

@interface ZGEditIntroViewController ()<UITextViewDelegate>

@property (nonatomic, weak) ZGEditTextView *introTextView;
@property (nonatomic, weak) UILabel *introTipLabel;

@end

@implementation ZGEditIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
    self.navigationItem.title = @"编辑个性签名";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZGEditTextView *textView = [[ZGEditTextView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 0)];
    textView.minHeight = 6 * textView.font.lineHeight;
    textView.maxHeight = textView.minHeight;
    textView.delegate = self;
    textView.placeholder = @"设定你的个性签名";
    textView.text = self.intro;
    textView.returnKeyType = UIReturnKeyDefault;
    self.introTextView = textView;
    [self.view addSubview:textView];
    
    UILabel *introTipLabel = [[UILabel alloc] init];
    self.introTipLabel = introTipLabel;
    introTipLabel.textAlignment = NSTextAlignmentRight;
    introTipLabel.frame = CGRectMake(textView.bounds.size.width - 40, CGRectGetMaxY(textView.frame) - 20, 30, 20);
    introTipLabel.font = [UIFont systemFontOfSize:13];
    introTipLabel.textColor = [UIColor popFontDisableColor];
    introTipLabel.text = [NSString stringWithFormat:@"%d", kIntroMaxLength];
    [self.view addSubview:introTipLabel];
    
    [self textViewDidChange:textView];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnDidClick)];
    self.navigationItem.rightBarButtonItem = right;
    self.navigationItem.rightBarButtonItem.enabled = textView.text.length > 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.introTextView becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.introTextView) {
        NSInteger length = textView.text.length;
        if (length > kIntroMaxLength) {
            textView.text = [textView.text substringToIndex:kIntroMaxLength];
            length = kIntroMaxLength;
        }
        length = kIntroMaxLength - length;
        self.introTipLabel.text = [NSString stringWithFormat:@"%ld", (long)length];
        self.navigationItem.rightBarButtonItem.enabled = textView.text.length > 0;
    }
    
}

- (void)rightBtnDidClick {
    if (self.introTextView.text.length <= 0) {
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK updateIntro:self.introTextView.text success:^(id data) {
        [SVProgressHUD dismiss];
        if (self.editSuccess) {
            self.editSuccess(self.introTextView.text);
        }
        [self dismiss];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"修改失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
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
