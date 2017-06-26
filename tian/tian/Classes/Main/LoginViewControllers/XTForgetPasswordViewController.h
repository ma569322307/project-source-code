//
//  XTForgetPasswordViewController.h
//  tian
//
//  Created by cc on 15-5-20.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
typedef enum
{
    ForgetPassword,//找回密码
    EnterPhoneNumber//手机注册
}ViewType;
@interface XTForgetPasswordViewController : XTRootViewController
@property (nonatomic,assign)ViewType theType;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
- (IBAction)clickNextBtn:(id)sender;
@end
