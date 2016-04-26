//
//  LoginStepTwoViewController.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "LoginStepTwoViewController.h"
#import "MainTabBarController.h"
#import "ZGTextField.h"
#import "UserTool.h"

@interface LoginStepTwoViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) ZGTextField *textField;
@property (nonatomic, weak) UIBarButtonItem *nextBtn;
@end

@implementation LoginStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Do any additional setup after loading the view from its nib.
    UILabel *label = [[UILabel alloc] init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    label.frame = CGRectMake(0, 100.0 + ([UIScreen mainScreen].scale/3 * 40), screenW, 30);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor popFontColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = @"您的登录密码?";
    [self.view addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, screenW, 20);
    [btn setTitleColor:[UIColor popColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitle:@"忘记密码了?" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    ZGTextField *textField = [[ZGTextField alloc] init];
    textField.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 20, screenW, 60);
    textField.returnKeyType = UIReturnKeyGo;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.secureTextEntry = YES;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    self.textField = textField;
    [self.view addSubview:textField];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    设置导航条信息
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextBtn = nextBtn;
    self.nextBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = nextBtn;
    
    self.title = @"填写密码";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = [textField.text stringByReplacingCharactersInRange:range withString:string].length;
    if ([string isEqualToString:@"\n"]) {
        if (length > 6) {
            [self next];
        }
        return NO;
    }
    if (length > 16) {
        return NO;
    }
    self.nextBtn.enabled = length >= 6;
    return YES;
}

- (void)next {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK loginWithPhone:self.phone pwd:self.textField.text success:^(id data) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[MainTabBarController alloc] init];
        [SVProgressHUD dismiss];
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障" maskType:SVProgressHUDMaskTypeGradient];
    }];
}


@end
