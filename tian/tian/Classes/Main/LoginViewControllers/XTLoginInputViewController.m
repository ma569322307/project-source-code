//
//  XTLoginInputViewController.m
//  tian
//
//  Created by cc on 15-5-20.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLoginInputViewController.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTUserStore.h"
#import "XTTabBarController.h"
#import "XTGuideManage.h"
#import "XTForgetPasswordViewController.h"
#import "NSError+XTError.h"
#import "XTRongCloudManager.h"
#define XTUserNameKey @"xtusername"
#define PWD_TEXT_MIX_LENGTH 4
@interface XTLoginInputViewController ()<UITextFieldDelegate>

@end

@implementation XTLoginInputViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"登录";
    [self addBackNavigationItem];
    
    NSString *userNameStr = [[NSUserDefaults standardUserDefaults] objectForKey:XTUserNameKey];
    if (userNameStr&&userNameStr.length>0) {
        _nameTextField.text = userNameStr;
    }
        
    self.loginBtn.enabled = NO;
    
   
    
    // Do any additional setup after loading the view from its nib.
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
- (void)setdata:(id)user withError:(NSError *)error andName:(NSString *)name
{
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:XTUserNameKey];
        CLog(@"登陆成功。，。，。，。");
        [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录成功" withCompletionBlock:^{
            
        }];
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        keyWindow.rootViewController = [XTGuideManage createDispayViewController];
        
        [[XTRongCloudManager shareInstance] rongCloudLogin];
    } else {
        [self.view endEditing:YES];
        CLog(@"登陆失败。。。。。。");
        [YYTAlertView showHalfTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] completaionBlock:nil];
    }
}
//登陆
- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
//    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
//        [self showTipViewWithTitle:@"网络未连接" Type:TIP_ERROR];
//        return;
//    }
    [YYTHUD showPromptAddedTo:XTKeyWindow withText:@"登录中。。" withCompletionBlock:nil];
    [self.view endEditing:YES];
    
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = _passwordTextField.text;
    __weak XTLoginInputViewController *wself = self;
    [[XTUserStore sharedManager] loginWithUserName:name password:password completionBlock:^(id user, NSError *error) {
        
        [wself setdata:user withError:error andName:name];
        [YYTHUD hideLoadingFrom:XTKeyWindow];
    }];

}

//找回密码
- (IBAction)forgetPasswordAction:(id)sender {
    XTForgetPasswordViewController *forgetPasswordVC = [[XTForgetPasswordViewController alloc]init];
    forgetPasswordVC.theType = ForgetPassword;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}
//注册新账号
- (IBAction)registAction:(id)sender {
    XTForgetPasswordViewController *forgetPasswordVC = [[XTForgetPasswordViewController alloc]init];
    forgetPasswordVC.theType = EnterPhoneNumber;
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}


#pragma mark -UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.nameTextField) {
            [_passwordTextField becomeFirstResponder];
        }else{
            [_passwordTextField resignFirstResponder];
        }
    }
    if (textField.tag == 1002 ) {
        if (newLength >= PWD_TEXT_MIX_LENGTH && _nameTextField.text.length >= PWD_TEXT_MIX_LENGTH) {
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
    }else if(textField.tag == 1001){
        if (newLength >= PWD_TEXT_MIX_LENGTH && _passwordTextField.text.length >= PWD_TEXT_MIX_LENGTH) {
            self.loginBtn.enabled = YES;
        }else{
            self.loginBtn.enabled = NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
     self.loginBtn.enabled = NO;
    return YES;
}
@end
