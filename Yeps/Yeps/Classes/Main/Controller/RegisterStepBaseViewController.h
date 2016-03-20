//
//  RegisterStepBaseViewController.h
//  Yeps
//
//  Created by weimi on 16/3/3.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZGTextField;
@interface RegisterStepBaseViewController : UIViewController

@property (nonatomic, assign) NSInteger textFieldTextMaxLength;
@property (nonatomic, copy) NSString *nextButtonTitle;
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, copy) NSString *subInfoText;
@property (nonatomic, weak) ZGTextField *textField;
@property (nonatomic, assign) NSInteger textFieldTextMinLength;

- (NSString *) textFieldText;


@end
