//
//  XTResetPasswordViewController.m
//  tian
//
//  Created by cc on 15-5-21.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTResetPasswordViewController.h"
#import "XTUserStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTTabBarController.h"
#import "XTGuideManage.h"
#import "XTRongCloudManager.h"
@interface XTResetPasswordViewController ()

@end

@implementation XTResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_theVCType) {
        case XTResetPassword:
            self.title = @"重置密码(2/2)";
            break;
        case XTSetPassword:
            self.title = @"设置密码(2/2)";
            break;
        default:
            break;
    }
    
    [self addBackNavigationItem];
    
    _sureBtn.enabled = NO;
    _numBtn.delegate = self;
    
    [self setNum];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_passwordField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_theVCType == XTResetPassword) {

    if (_numBtn.countdownNum > 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:_numBtn.countdownNum forKey:@"resetTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_numBtn cancleTime];
    }
}
#pragma mark - button delegate
- (void)countdownBeginning
{
    NSLog(@"%s",__func__);
    _numBtn.userInteractionEnabled = NO;
    [_numBtn setBackgroundImage:UIIMAGE(@"") forState:UIControlStateNormal];
}
- (void)countdownEnding
{
    NSLog(@"%s",__func__);
    _numBtn.userInteractionEnabled = YES;
    [_numBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [_numBtn setBackgroundImage:UIIMAGE(@"re-enterCode") forState:UIControlStateNormal];
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
- (void)setNum {
    _numBtn.countdownNum = self.countdownNum;
    [_numBtn countdownBegin];
}
- (void)requestCode {
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    NSString *type = @"resetPassword";
    if (_theVCType == XTSetPassword) {
        type = @"register";
    }
    NSDictionary *param = @{@"phone":_phoneNumber,
                            @"type":type};
    [[XTUserStore sharedManager] checkPhoneAuthCode:param completionBlock:^(id dic, NSError *error) {
        if (!dic[@"error"] && !error) {
            self.countdownNum = [dic[@"actionInterval"] intValue];
            [self setNum];
        } else {
            NSString *errorTip = nil;
            if (error) {
                errorTip = [error xtErrorMessage];
            } else {
                errorTip = dic[@"display_message"];
            }
            [self.view endEditing:YES];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:errorTip completaionBlock:nil];
        }
    }];
}
- (IBAction)sendCode:(id)sender {
    [_numBtn setBackgroundImage:UIIMAGE(@"") forState:UIControlStateNormal];
    
    [self requestCode];
}
//重置密码
- (void)resetPasswordRequest
{
    NSDictionary *param = @{@"phone": _phoneNumber,@"password":_passwordField.text,@"code":_codeTextField.text};
    [[XTUserStore sharedManager] resetPassword:param completionBlock:^(id dic, NSError *error) {
        if (!dic[@"error"] && !error) {
            [self.view endEditing:YES];
            [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:dic[@"message"] completaionBlock:^(NSInteger index){
                [[XTUserStore sharedManager] removeUserInfo];
                UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
                keyWindow.rootViewController = [XTGuideManage createDispayViewController];
                [[XTRongCloudManager shareInstance] rongCloudLogin];
            }];
            
            
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
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"resetTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}
- (void)setdata:(XTUserAccountInfo *)user withError:(NSError *)error
{
    if (user) {
        [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"注册成功" withCompletionBlock:^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            keyWindow.rootViewController = [XTGuideManage createDispayViewController];
            [[XTRongCloudManager shareInstance] rongCloudLogin];
        }];
        
    } else {
        [YYTHUD showPromptNoLockAddedTo:XTKeyWindow withText:@"注册失败" withCompletionBlock:nil];
//        [self showAlertWithTitle:@"提醒" Message:[error xtErrorMessage] cancelBtnBlock:nil otherBtnBlock:nil];
    }
}
//注册
- (void)registRequest{
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    __weak XTResetPasswordViewController *wself = self;
    [[XTUserStore sharedManager] registerWithPhoneNumber:_phoneNumber verificationCode:_codeTextField.text password:_passwordField.text repassword:_confirmPasswordTextField.text completionBlock:^(NSMutableDictionary *dic, XTUserAccountInfo *user, NSError *error) {
        [wself setdata:user withError:error];
    }];
}
- (BOOL)VerificationPhoneNumberFormat
{
    NSString *phoneNumber = _passwordField.text;
    NSString *confirmPassword = _confirmPasswordTextField.text;
    if ([phoneNumber isEqualToString:@""]||phoneNumber.length<=0||phoneNumber == nil||[confirmPassword isEqualToString:@""]||confirmPassword.length<=0||confirmPassword == nil) {
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"亲，密码不能为空..." completaionBlock:nil];
        return NO;
    }else if (phoneNumber.length<4||phoneNumber.length>20||confirmPassword.length<4||confirmPassword.length>20)
    {
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"亲，密码只能4-20位字符..." completaionBlock:nil];
        return NO;
    }else if (![phoneNumber isEqualToString:confirmPassword])
    {
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:@"亲，两次密码输入不一致哟.." completaionBlock:nil];
        return NO;
    }
    return YES;
}
- (IBAction)sureAction:(id)sender {
    [self.view endEditing:YES];
//    [UIView animateWithDuration:0.5 animations:^{
//        _layout_inputBg_top.constant = 30;
//    }];
    
    if(![self VerificationPhoneNumberFormat])
    {
        return;
    }
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    switch (_theVCType) {
        case XTResetPassword:
            [self resetPasswordRequest];
            break;
        case XTSetPassword:
            [self registRequest];
            break;
            
        default:
            break;
    }
}

#pragma mark -UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (textField == self.confirmPasswordTextField) {
        if (newLength >= 4 && _codeTextField.text.length >= 4) {
            _sureBtn.enabled = YES;
        }else{
            _sureBtn.enabled = NO;
        }
    }else{
        if (newLength >= 4 && _confirmPasswordTextField.text.length >= 4) {
            _sureBtn.enabled = YES;
        }else{
            _sureBtn.enabled = NO;
        }
    }
    if (textField == _passwordField) {
        if ([string isEqualToString:@"\n"]) {
            [_confirmPasswordTextField becomeFirstResponder];
        }
    }else if (textField == _confirmPasswordTextField){
        if ([string isEqualToString:@"\n"]) {
            [_codeTextField becomeFirstResponder];
        }
    }else if (textField == _codeTextField){
        if ([string isEqualToString:@"\n"]) {
            [_codeTextField resignFirstResponder];
//            [UIView animateWithDuration:0.5 animations:^{
//                _layout_inputBg_top.constant = 30;
//            }];
        }
    }
    
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _passwordField) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _layout_inputBg_top.constant = 30;
//        }];
        
    }else if (textField == _confirmPasswordTextField)
    {
//        [UIView animateWithDuration:0.5 animations:^{
//            _layout_inputBg_top.constant = 30;
//        }];
        
    }else if (textField == _codeTextField)
    {
//        [UIView animateWithDuration:0.5 animations:^{
//            _layout_inputBg_top.constant = 30;
//        }];
        
    }
}
#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [UIView animateWithDuration:0.5 animations:^{
//        _layout_inputBg_top.constant = 30;
//    }];
    [self.view endEditing:YES];
}
@end
