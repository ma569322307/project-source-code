//
//  XTChangePassWViewController.m
//  tian
//
//  Created by yyt on 15/7/6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTChangePassWViewController.h"
#import "YYTAlertView.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "AppDelegate.h"
#import "XTRongCloudManager.h"
#import "XTGuideManage.h"
@interface XTChangePassWViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassWordTextField;
#define K_CHANGEPASSWORD @"http://mapi.yinyuetai.com/common/account/change_password.json"
- (IBAction)ChangeButtonClick:(id)sender;
@end

@implementation XTChangePassWViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = UIColorFromRGB(0xececec);
    [self addNavigationBarLable];
}
-(void)addNavigationBarLable{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = @"修改密码";
    self.navigationItem.titleView = lable;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)ChangeButtonClick:(id)sender {
    if ([self respondsToSelector:@selector(inspectinformation)]) {
        [self inspectinformation];
    }
    
}
//判断修改的数据是否符合要求
-(void)inspectinformation{
    if (self.oldPassWordTextField.text.length<4 || self.oldPassWordTextField.text.length > 20) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"亲，输入错误，密码不正确!" delegate:self];
        return ;
    }
    if (self.passWordTextField.text.length<4 || self.passWordTextField.text.length >20) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"亲，密码只能4-20字符!" delegate:self];
        return;
    }
    if (![self.repeatPassWordTextField.text isEqualToString:self.passWordTextField.text]) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"亲，两次密码输入不一致哟!" delegate:self];
        return;
    }
    [self changePassWord];
}
//修改密码
-(void)changePassWord{
    XTSubStore *subStore = [[XTSubStore alloc]init];
    [subStore fetchUserChangePassWord:self.oldPassWordTextField.text newPassword:self.passWordTextField.text comletionBlock:^(id responseObject, NSError *error) {
        
        if (!error) {
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"修改成功" withCompletionBlock:^{
                [self quitLogin];
            }];
        }
        else{
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
        }
    }];
}
-(void)quitLogin{
    [[XTUserStore sharedManager] logoutWithBlock:^(BOOL isSuccess, NSError *error) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = [XTGuideManage createDispayViewController];
            [[XTRongCloudManager shareInstance] rongCloudLogout];
        }
        
    }];
}
@end
