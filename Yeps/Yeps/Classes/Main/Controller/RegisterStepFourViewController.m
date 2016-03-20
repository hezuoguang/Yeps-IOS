//
//  RegisterStepFourViewController.m
//  Yeps
//
//  Created by weimi on 16/3/4.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepFourViewController.h"
#import "RegisterStepEndViewController.h"
#import "ZGTextField.h"
@interface RegisterStepFourViewController ()

@end

@implementation RegisterStepFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.textField.secureTextEntry = YES;
    self.textField.keyboardType = UIKeyboardTypeASCIICapable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)next {
    [self.view endEditing:YES];
    RegisterStepEndViewController *endVC = [[RegisterStepEndViewController alloc] init];
    endVC.nick = self.nick;
    endVC.phone = self.phone;
    endVC.pwd = self.textField.text;
    [self.navigationController pushViewController:endVC animated:YES];
}

@end
