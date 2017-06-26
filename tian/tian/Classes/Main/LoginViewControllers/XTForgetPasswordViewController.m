//
//  XTForgetPasswordViewController.m
//  tian
//
//  Created by cc on 15-5-20.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTForgetPasswordViewController.h"
#import "XTUserStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTResetPasswordViewController.h"
@interface XTForgetPasswordViewController ()
@end

@implementation XTForgetPasswordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_theType) {
        case ForgetPassword:
            self.title = @"重置密码(1/2)";
            break;
            case EnterPhoneNumber:
            self.title = @"填写手机号(1/2)";
            break;
        default:
            break;
    }
    
    [self addBackNavigationItem];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"resetTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerFromPhone {
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    if (_phoneNumberTextField.text.length >= 11) {
        [YYTHUD showLoadingWithMaskAddedTo:self.view];
        NSDictionary *param = @{@"phone":_phoneNumberTextField.text,
                                @"type":@"register"};
        __weak XTForgetPasswordViewController *wself = self;
        [[XTUserStore sharedManager] checkPhoneAuthCode:param completionBlock:^(id dic, NSError *error) {
            [YYTHUD hideLoadingFrom:self.view];
            if (!dic[@"error"] && !error) {
                XTResetPasswordViewController *viewController = [[XTResetPasswordViewController alloc] init];
                viewController.phoneNumber = wself.phoneNumberTextField.text;
                viewController.countdownNum = [dic[@"actionInterval"] intValue];
                viewController.theVCType = XTSetPassword;
                [wself.navigationController pushViewController:viewController animated:YES];
            } else {
                NSString *errorTip = nil;
                if (error) {
                    errorTip = [error xtErrorMessage];
                } else {
                    errorTip = dic[@"display_message"];
                }
                
                [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:errorTip completaionBlock:nil];
            }
        }];
    }
}

- (void)resetPasswordFromPhone {
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    NSInteger resetTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"resetTime"];
    if (resetTime > 0) {
        XTResetPasswordViewController *viewController = [[XTResetPasswordViewController alloc] init];
        viewController.phoneNumber = self.phoneNumberTextField.text;
        viewController.countdownNum = resetTime;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
//        if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//            [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//            return;
//        }
        [YYTHUD showLoadingWithMaskAddedTo:self.view];
        __weak XTForgetPasswordViewController *wself = self;
        NSDictionary *param = @{@"phone":_phoneNumberTextField.text,
                                @"type":@"resetPassword"};
        [[XTUserStore sharedManager] checkPhoneAuthCode:param completionBlock:^(id dic, NSError *error) {
            [YYTHUD hideLoadingFrom:self.view];
            if (!dic[@"error"] && !error) {
                XTResetPasswordViewController *viewController = [[XTResetPasswordViewController alloc] init];
                viewController.phoneNumber = wself.phoneNumberTextField.text;
                viewController.countdownNum = [dic[@"actionInterval"] intValue];
                viewController.theVCType = XTResetPassword;
                [wself.navigationController pushViewController:viewController animated:YES];
            } else {
                [self.view endEditing:YES];
                NSString *errorTip = nil;
                if (error) {
                    errorTip = [error xtErrorMessage];
                } else {
                    errorTip = dic[@"display_message"];
                }
                [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:errorTip completaionBlock:nil];

            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)VerificationPhoneNumberFormat
{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if ([phoneNumber isEqualToString:@""]||phoneNumber.length<=0||phoneNumber == nil) {
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"手机号不能为空" completaionBlock:nil];
        return NO;
    }else if (phoneNumber.length<11)
    {
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"请输入正确的手机号" completaionBlock:nil];
        return NO;
    }
    return YES;
}
- (IBAction)clickNextBtn:(id)sender {
    if (![self VerificationPhoneNumberFormat]) {
        return;
    }
    if (_theType == EnterPhoneNumber) {
        [self registerFromPhone];
        
    } else {
        [self resetPasswordFromPhone];
    }
    [_phoneNumberTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
