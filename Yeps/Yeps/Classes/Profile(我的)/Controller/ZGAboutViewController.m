//
//  ZGAboutViewController.m
//  Yeps
//
//  Created by weimi on 16/4/29.
//  Copyright © 2016年 weimi. All rights reserved.
//

#import "ZGAboutViewController.h"

@interface ZGAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *YepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end

@implementation ZGAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"关于Yeps";
    self.YepsLabel.font = [UIFont systemFontOfSize:22];
    self.YepsLabel.textColor = [UIColor popFontColor];
    self.YepsLabel.alpha = 0.85;
    
    self.versionLabel.font = [UIFont systemFontOfSize:15];
    self.versionLabel.textColor = [UIColor popContentColor];
    
    self.aboutLabel.font = [UIFont systemFontOfSize:11];
    self.aboutLabel.textColor = [UIColor popContentColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
