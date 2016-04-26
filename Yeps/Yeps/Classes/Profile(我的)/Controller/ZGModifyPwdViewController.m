//
//  ZGModifyPwdViewController.m
//  Yeps
//
//  Created by weimi on 16/4/21.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGModifyPwdViewController.h"
@interface ZGModifyPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePwdTextField;

@end

@implementation ZGModifyPwdViewController

+ (instancetype)initModifyPwdViewController {
    ZGModifyPwdViewController *vc = [[UIStoryboard storyboardWithName:@"ZGModifyPwdViewController" bundle:nil] instantiateInitialViewController];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPwdTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.rePwdTextField.delegate = self;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor popBackGroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.oldPwdTextField becomeFirstResponder];
}

- (void)rightBtnClick {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [self.view endEditing:YES];
    if (![self validate]) {
        return;
    }
    if (![self.pwdTextField.text isEqualToString:self.rePwdTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"新密码不一致" maskType:SVProgressHUDMaskTypeGradient];
        return;
    }
    [YepsSDK updatePassword:self.oldPwdTextField.text pwd:self.pwdTextField.text success:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"密码修改成功" maskType:SVProgressHUDMaskTypeGradient];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"密码修改失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (BOOL)checkTextFieldTextLength:(UITextField *)textField minLength:(NSInteger)minLength {
    if(textField.text.length >= minLength) return YES;
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        BOOL flag = [self checkTextFieldTextLength:textField minLength:6];
        if (flag) {
            if (textField == self.oldPwdTextField) {
                [self.pwdTextField becomeFirstResponder];
            } else if(textField == self.pwdTextField) {
                [self.rePwdTextField becomeFirstResponder];
            } else if(textField == self.rePwdTextField){
                [self rightBtnClick];
            }
        }
        return NO;
    }
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = str;
    [self updateRightBtnStatus];
    return NO;
}

- (BOOL)validate {
    if ([self checkTextFieldTextLength:self.oldPwdTextField minLength:6] && [self checkTextFieldTextLength:self.pwdTextField minLength:6] && [self checkTextFieldTextLength:self.rePwdTextField minLength:6]) {
        return YES;
    }
    return NO;
}

- (void)updateRightBtnStatus {
    self.navigationItem.rightBarButtonItem.enabled = [self validate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.oldPwdTextField becomeFirstResponder];
    } else if(indexPath.row == 1) {
        [self.pwdTextField becomeFirstResponder];
    } else if(indexPath.row == 2) {
        [self.rePwdTextField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
