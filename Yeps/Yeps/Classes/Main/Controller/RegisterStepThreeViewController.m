//
//  RegisterStepThreeViewController.m
//  Yeps
//
//  Created by weimi on 16/3/3.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepThreeViewController.h"
#import "ZGTextField.h"
#import "RegisterStepFourViewController.h"
#import "SMSTool.h"
@interface RegisterStepThreeViewController ()

@end

@implementation RegisterStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)next {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [SMSTool checkSMSCodeWithCode:self.textFieldText phone:self.phone success:^{
        [SVProgressHUD dismiss];
        RegisterStepFourViewController *fourVC = [[RegisterStepFourViewController alloc] init];
        fourVC.phone = self.phone;
        fourVC.nick = self.nick;
        fourVC.textFieldTextMaxLength = 16;
        fourVC.textFieldTextMinLength = 6;
        fourVC.infoText = @"设置您的登录密码?";
        [self.navigationController pushViewController:fourVC animated:YES];
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"验证码错误"];
    }];
    
}

@end
