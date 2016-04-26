//
//  ZGEditProfileViewController.m
//  Yeps
//
//  Created by weimi on 16/4/22.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGEditProfileViewController.h"
#import "ZGProfileTextField.h"
#import "UserTool.h"
#import "UserInfoModel.h"

@interface ZGEditProfileViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet ZGProfileTextField *nickTextField;

@property (weak, nonatomic) IBOutlet ZGProfileTextField *emailTextfield;

@property (weak, nonatomic) IBOutlet ZGProfileTextField *birthdayTextfield;

@property (weak, nonatomic) IBOutlet UIButton *manBUtton;

@property (weak, nonatomic) IBOutlet UIButton *womanButton;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, weak) UITextField *hideBirthdayTextField;

@end

@implementation ZGEditProfileViewController

+ (instancetype)initEditProfileViewController {
    ZGEditProfileViewController *vc = [[UIStoryboard storyboardWithName:@"ZGEditProfileViewController" bundle:nil] instantiateInitialViewController];
    return vc;
}

- (UIDatePicker *)datePicker {
    if (_datePicker == nil) {
        UIDatePicker *picker = [[UIDatePicker alloc] init];
        _datePicker = picker;
        picker.datePickerMode = UIDatePickerModeDate;
        [picker addTarget:self action:@selector(datePickerDateDidChange:) forControlEvents:UIControlEventValueChanged];
        NSDate *cur = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *addCom = [[NSDateComponents alloc] init];
        [addCom setYear:-18];
        [addCom setMonth:0];
        [addCom setMonth:0];
        NSDate *maxDate = [calendar dateByAddingComponents:addCom toDate:cur options:0];
        [addCom setYear:-100];
        NSDate *minDate = [calendar dateByAddingComponents:addCom toDate:cur options:0];
        picker.minimumDate = minDate;
        picker.maximumDate = maxDate;
    }
    return _datePicker;
}

- (UITextField *)hideBirthdayTextField {
    if (_hideBirthdayTextField == nil) {
        UITextField *tf = [[UITextField alloc] init];
        _hideBirthdayTextField = tf;
        _hideBirthdayTextField.delegate = self;
        [self.view addSubview:_hideBirthdayTextField];
    }
    return _hideBirthdayTextField;
}

- (void)datePickerDateDidChange:(UIDatePicker *)picker {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *DateStr = [dateFormat stringFromDate:picker.date];
    self.birthdayTextfield.text = DateStr;
}

- (void)setup {
    [self.manBUtton setTitleColor:[UIColor popColor] forState:UIControlStateSelected];
    [self.manBUtton setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    self.manBUtton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.womanButton setTitleColor:[UIColor popColor] forState:UIControlStateSelected];
    [self.womanButton setTitleColor:[UIColor popFontColor] forState:UIControlStateNormal];
    self.womanButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.manBUtton addTarget:self action:@selector(sexBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.womanButton addTarget:self action:@selector(sexBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nickTextField.delegate = self;
    self.emailTextfield.delegate = self;
    self.birthdayTextfield.delegate = self;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.hideBirthdayTextField.inputView = self.datePicker;
    
    self.birthdayTextfield.userInteractionEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)sexBtnDidClick:(UIButton *)btn {
    if (btn.selected) {
        return;
    }
    if (self.manBUtton == btn) {
        self.manBUtton.selected = YES;
        self.womanButton.selected = NO;
    } else if (self.womanButton == btn) {
        self.manBUtton.selected = NO;
        self.womanButton.selected = YES;
    }
}

- (void)setUserInfo {
    UserInfoModel *userInfo = [UserTool getCurrentUserInfo];
    self.nickTextField.text = userInfo.nick;
    self.emailTextfield.text = userInfo.email;
    self.birthdayTextfield.text = userInfo.birthday;
    if ([userInfo.sex isEqualToString:@"男"]) {
        [self sexBtnDidClick:self.manBUtton];
    } else {
        [self sexBtnDidClick:self.womanButton];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.view.backgroundColor = [UIColor popBackGroundColor];
    [self setup];
}

- (void)rightBtnClick {
    [self.view endEditing:YES];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    NSString *nick = self.nickTextField.text;
    if (nick == nil || nick.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"昵称未填写" maskType:SVProgressHUDMaskTypeGradient];
        [self.nickTextField becomeFirstResponder];
        return;
    }
    
    if (nick.length > 12) {
        [SVProgressHUD showErrorWithStatus:@"昵称不能超过12个字符" maskType:SVProgressHUDMaskTypeGradient];
        [self.nickTextField becomeFirstResponder];
        return;
    }
    
    NSString *email = self.emailTextfield.text;
    if (email == nil || email.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"邮箱未填写" maskType:SVProgressHUDMaskTypeGradient];
        [self.emailTextfield becomeFirstResponder];
        return;
    }
    
    NSString *birthday = self.birthdayTextfield.text;
    if (birthday == nil || birthday.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"生日未填写" maskType:SVProgressHUDMaskTypeGradient];
        [self.birthdayTextfield becomeFirstResponder];
        return;
    }
    
    NSInteger sex = 1;
    if(self.manBUtton.selected) {
        sex = 0;
    }
    [YepsSDK updateInfo:nick email:email birthday:birthday sex:sex success:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" maskType:SVProgressHUDMaskTypeGradient];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } error:^(id data) {
        [SVProgressHUD showErrorWithStatus:data[@"info"] maskType:SVProgressHUDMaskTypeGradient];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败" maskType:SVProgressHUDMaskTypeGradient];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.nickTextField) {
            [self.emailTextfield becomeFirstResponder];
        } else if(textField == self.emailTextfield) {
            [self.birthdayTextfield becomeFirstResponder];
        } else if(textField == self.birthdayTextfield){
            [self rightBtnClick];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.hideBirthdayTextField) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date =[dateFormat dateFromString:self.birthdayTextfield.text];
        [self.datePicker setDate:date animated:YES];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        [self.hideBirthdayTextField becomeFirstResponder];
    } else if (indexPath.row == 0) {
        [self.nickTextField becomeFirstResponder];
    } else if (indexPath.row == 1) {
        [self.emailTextfield becomeFirstResponder];
    }
}

@end
