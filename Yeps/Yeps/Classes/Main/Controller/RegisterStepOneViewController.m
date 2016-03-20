//
//  RegisterStepOneViewController.m
//  Yeps
//
//  Created by weimi on 16/3/2.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepOneViewController.h"
#import "ZGTextField.h"
#import "RegisterStepTwoViewController.h"

@interface RegisterStepOneViewController ()<UITextFieldDelegate>


@end

@implementation RegisterStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)next {
    [self.view endEditing:YES];
    RegisterStepTwoViewController *twoVC = [[RegisterStepTwoViewController alloc] init];
    twoVC.textFieldTextMaxLength = 11;
    twoVC.infoText = @"您的手机号码?";
    twoVC.subInfoText = @"仅支持中国大陆手机号";
    twoVC.textFieldTextMinLength = 11;
    twoVC.nick = self.textFieldText;
    [self.navigationController pushViewController:twoVC animated:YES];
}

@end
