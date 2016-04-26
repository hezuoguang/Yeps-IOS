//
//  LoginViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "UnLoginViewController.h"
#import "RegisterStepOneViewController.h"
#import "LoginViewStepOneController.h"

@interface UnLoginViewController ()

@property (nonatomic, weak) UIButton *registerBtn;
@property (nonatomic, weak) UIButton *loginBtn;

@end

@implementation UnLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yepsTitle"]];
    
    self.view.backgroundColor = [UIColor popBackGroundColor];
    
    [self setupBtns];
}

- (void)setupBtns{
    CGFloat btnH = 65;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnW = screenW * 0.5;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(0, screenH - btnH, btnW, btnH);
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(CGRectGetMaxX(loginBtn.frame), screenH - btnH, btnW, btnH);
    registerBtn.backgroundColor = [UIColor popColor];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    self.registerBtn = registerBtn;
}

- (void)loginBtnClick {
    LoginViewStepOneController *loginVC = [[LoginViewStepOneController alloc] init];
    loginVC.infoText = @"您的手机号码?";
    loginVC.textFieldTextMaxLength = 11;
    loginVC.textFieldTextMinLength = 11;
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)registerBtnClick {
    RegisterStepOneViewController *oneVC = [[RegisterStepOneViewController alloc] init];
    oneVC.infoText = @"您的昵称?";
    oneVC.textFieldTextMaxLength = 12;
    [self.navigationController pushViewController:oneVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
