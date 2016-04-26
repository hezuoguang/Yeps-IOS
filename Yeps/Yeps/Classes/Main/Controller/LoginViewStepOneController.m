//
//  LoginViewController.m
//  Yeps
//
//  Created by weimi on 16/3/6.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "LoginViewStepOneController.h"
#import "ZGTextField.h"
#import "LoginStepTwoViewController.h"
@interface LoginViewStepOneController ()

@end

@implementation LoginViewStepOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.title = @"填写手机号";
}

- (void)next {
    [self.view endEditing:YES];
    LoginStepTwoViewController *loginVC = [[LoginStepTwoViewController alloc] init];
    loginVC.phone = self.textField.text;
    [self.navigationController pushViewController:loginVC animated:YES];
}



@end
