//
//  XTLoginInputViewController.h
//  tian
//
//  Created by cc on 15-5-20.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTLoginInputViewController : XTRootViewController
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(id)sender;
- (IBAction)forgetPasswordAction:(id)sender;
- (IBAction)registAction:(id)sender;

@end
