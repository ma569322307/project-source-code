//
//  XTLoginViewController.h
//  tian
//
//  Created by cc on 15-5-18.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTLoginViewController : XTRootViewController
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) UIButton *sinaLoginBtn;
@property (strong, nonatomic) UIButton *qqLoginBtn;
@property (strong, nonatomic) UIButton *wxloginBtn;
- (IBAction)clickLoginBtn:(id)sender;
- (IBAction)clickOtherLoginBtn:(id)sender;
- (IBAction)clickTkBtn:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoImageV_Height;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoImageV_width;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sinaBtn_layoutCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqBtn_layoutCenter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxBtn_layoutCenter;

@end
