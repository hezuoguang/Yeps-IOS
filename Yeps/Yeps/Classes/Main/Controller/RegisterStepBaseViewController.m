//
//  RegisterStepBaseViewController.m
//  Yeps
//
//  Created by weimi on 16/3/3.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "RegisterStepBaseViewController.h"
#import "ZGTextField.h"

@interface RegisterStepBaseViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIBarButtonItem *nextBtn;

@end

@implementation RegisterStepBaseViewController


- (void)setNextButtonTitle:(NSString *)nextButtonTitle {
    _nextButtonTitle = nextButtonTitle;
}

- (instancetype)init {
    if (self = [super init]) {
        self.nextButtonTitle = @"下一步";
        self.textFieldTextMaxLength = 20;
        self.textFieldTextMinLength = 1;
        self.infoText = @"提示信息";
        self.subInfoText = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *label = [[UILabel alloc] init];
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    label.frame = CGRectMake(0, 100.0 + ([UIScreen mainScreen].scale/3 * 40), screenW, 30);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor popFontColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.text = self.infoText;
    [self.view addSubview:label];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(0, CGRectGetMaxY(label.frame) + 10, screenW, 20);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor popFontColor];
    label2.font = [UIFont systemFontOfSize:16.0];
    label2.text = self.subInfoText;
    [self.view addSubview:label2];
    
    ZGTextField *textField = [[ZGTextField alloc] init];
    textField.frame = CGRectMake(0, CGRectGetMaxY(label2.frame) + 20, screenW, 60);
    textField.returnKeyType = UIReturnKeyNext;
    textField.enablesReturnKeyAutomatically = YES;
    textField.delegate = self;
    self.textField = textField;
    [self.view addSubview:textField];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    设置导航条信息
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.nextBtn = nextBtn;
    self.nextBtn.enabled = NO;
    self.navigationItem.rightBarButtonItem = nextBtn;
    
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
        if (length > self.textFieldTextMinLength) {
            [self next];
        }
        return NO;
    }
    if (length > self.textFieldTextMaxLength) {
        return NO;
    }
    self.nextBtn.enabled = length >= self.textFieldTextMinLength;
    return YES;
}

- (void)next {
    
}

- (NSString *)textFieldText {
    return self.textField.text;
}

@end
