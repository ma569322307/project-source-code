//
//  XTResetPasswordViewController.h
//  tian
//
//  Created by cc on 15-5-21.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"
#import "XTUIButton.h"
typedef enum
{
    XTResetPassword,
    XTSetPassword
}VCType;
@interface XTResetPasswordViewController : XTRootViewController<XTUIButtonDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSString *phoneNumber;
@property (assign, nonatomic) NSInteger countdownNum;
@property (assign, nonatomic) VCType theVCType;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet XTUIButton *numBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layout_inputBg_top;
- (IBAction)sendCode:(id)sender;
- (IBAction)sureAction:(id)sender;
@end
