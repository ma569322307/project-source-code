//
//  XTboundiphoneTwoViewController.m
//  tian
//
//  Created by yyt on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTboundphoneViewController.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTForgetPasswordViewController.h"
#import "XTUserStore.h"
#import "XTResetPasswordViewController.h"
#import "XTUIButton.h"
#import "YYTAlertView.h"
#import "YYTHUD.h"
#import "XTcheckBoundPhoneViewController.h"
#define K_BOUNDIPHONENUMBER @"http://capi.yinyuetai.com/common/account/bind_phone.json"//绑定手机号码
@interface XTboundphoneViewController ()<UITextFieldDelegate,XTUIButtonDelegate>
{
    NSTimer * _timer;
}
@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;
@property (strong, nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) NSInteger countdownNum;
@property (assign, nonatomic) VCType theVCType;
@property (nonatomic ,assign) BOOL open;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (nonatomic, weak) IBOutlet XTUIButton *againButton;
- (IBAction)againGetButton:(id)sender;
- (IBAction)FinishButton:(id)sender;
@end

@implementation XTboundphoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定手机号";
    [self setTextField];
}
-(void)setTextField{
    self.iphoneTextField.delegate = self;
    self.codeTextField.delegate = self;
    self.againButton.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark----------XTUIButtonDelegate
- (void)countdownBeginning
{
    NSLog(@"%s",__func__);
    self.againButton.userInteractionEnabled = NO;
}
- (void)countdownEnding
{
    NSLog(@"%s",__func__);
    self.againButton.userInteractionEnabled = YES;
    [self.againButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
}
- (IBAction)againGetButton:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (self.iphoneTextField.text.length == 0) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"请输入手机号码" delegate:self];
        return;
    }
    if (self.iphoneTextField.text.length != 11) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"你输入的手机号码有误！" delegate:self];
        return;
    }
    
//
    [self requestSendCode];
    

}

/**
 *  开始倒计时
 */
- (void)countdownBegin
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countdown)
                                                userInfo:nil
                                                 repeats:YES];
    }
    if ([self.againButton.delegate respondsToSelector:@selector(countdownBeginning)]) {
        [self.againButton.delegate countdownBeginning];
    }
}
- (void)countdown
{
    if (_countdownNum <= 1) {
        _countdownNum = 0;
        [self.againButton countdownEnd];
        return;
    }
    _countdownNum --;
    //    NSLog(@"%ld", (long)_countdownNum);
    [self.againButton setTitle:[NSString stringWithFormat:@"重新获取 (%ld)",(_countdownNum < 0 ? 1 : _countdownNum)] forState:UIControlStateNormal];
}

- (void)setNum {
    self.againButton.countdownNum = self.countdownNum;
    
    [self.againButton countdownBegin];
}

- (IBAction)FinishButton:(id)sender {
    if (self.codeTextField.text == 0) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"请输入验证码" delegate:self];
    }
    if (self.codeTextField.text.length != 6) {
        [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"你输入的验证码有误！" delegate:self];
        return;
 }
    [self requestIphoneAndCode];
    [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"绑定成功" delegate:self];
    if (self.completionBlock) {
        self.completionBlock();
    }
    sleep(1);
    XTcheckBoundPhoneViewController *boundIphoneVC = [[XTcheckBoundPhoneViewController alloc]init];
    [self.navigationController presentViewController:boundIphoneVC animated:YES completion:^{
        
    }];
    
    
}
#
#pragma mark - 当绑定成功手机时，更换存在本地的用户信息
//changeLoginUserInfo
- (void)changeLoginuserInfoWithPhoneNumber:(NSString *)phoneStr
{
    XTUserAccountInfo *loginUserinfo = [[XTUserStore sharedManager] user];
    loginUserinfo.phone = phoneStr;
    loginUserinfo.bindStatus = 3;
    [NSKeyedArchiver archiveRootObject:loginUserinfo toFile:[self userArchivePath]];

}
//usercaseFilePath
- (NSString *)userArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}
//将获得的手机号码进行绑定
-(void)requestIphoneAndCode{
    NSDictionary *paramDic = @{@"phone":self.iphoneTextField.text,@"code":self.codeTextField.text};
    
    [[XTUserStore sharedManager] boundIphoneNumberWithComletionBlock:paramDic and:^(id dic, NSError *error) {
        CLog(@"返回是否绑定成功的字典:%@",dic);
        
        if (!error) {
            if ([dic objectForKey:@"success"]) {
                CLog(@"绑定手机号成功，修改本地用户信息");
                [self changeLoginuserInfoWithPhoneNumber:self.iphoneTextField.text];
            }
        }else
        {
            [YYTAlertView showFullTypeAlertViewWithTitle:@"提示"message:[error xtErrorMessage] delegate:self];

        }
    }];

}
//发送验证码
-(void)requestSendCode{
    XTUserStore *store = [XTUserStore sharedManager];
    NSDictionary *paramDic = @{@"phone":self.iphoneTextField.text,@"type":@"bind"};
    [store checkPhoneAuthCode:paramDic completionBlock:^(id dic, NSError *error) {
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
            [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:[error xtErrorMessage] delegate:self];
        }
    }];

}
@end
