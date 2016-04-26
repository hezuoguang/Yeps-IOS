//
//  RegisterStepTwoViewController.m
//  Yeps
//
//  Created by weimi on 16/3/3.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepTwoViewController.h"
#import "RegisterStepThreeViewController.h"
#import "ZGTextField.h"
#import "SMSTool.h"

@interface RegisterStepTwoViewController ()<UITextFieldDelegate>

@end

@implementation RegisterStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.title = @"设置手机号";
}



- (void)next {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [YepsSDK checkPhoneExist:self.textFieldText success:^(id data) {
        [SMSTool getSMSCodeWithPhone:self.textFieldText success:^{
            [SVProgressHUD dismiss];
            RegisterStepThreeViewController *threeVC = [[RegisterStepThreeViewController alloc] init];
            threeVC.textFieldTextMaxLength = 4;
            threeVC.textFieldTextMinLength = 4;
            threeVC.infoText = @"输入收到的验证码";
            threeVC.subInfoText = [NSString stringWithFormat:@"您的手机号:%@",self.textFieldText];
            threeVC.nick = self.nick;
            threeVC.phone = self.textFieldText;
            [self.navigationController pushViewController:threeVC animated:YES];
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"获取验证码失败" maskType:SVProgressHUDMaskTypeGradient];
        }];
        
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
        [self.textField becomeFirstResponder];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络故障" maskType:SVProgressHUDMaskTypeGradient];
    }];
    
    
}

@end
