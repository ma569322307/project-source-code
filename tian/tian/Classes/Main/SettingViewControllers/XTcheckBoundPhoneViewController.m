//
//  XTboundiphoneViewController.m
//  tian
//
//  Created by yyt on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTcheckBoundPhoneViewController.h"
#import "XTboundphoneViewController.h"
#import "XTHotLicksStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTConfig.h"
#import "XTUserAccountInfo.h"
#import "XTUserStore.h"
#import "YYTAlertView.h"
#import "XTUserStore.h"
#import <Mantle/EXTScope.h>
 static NSString *str = @"http://capi.yinyuetai.com/common/account/bind_phone.json";
@interface XTcheckBoundPhoneViewController ()

@property (weak, nonatomic) IBOutlet UIButton *boundButton;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLable;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
- (IBAction)boundsIphoneButton:(id)sender;

@end

@implementation XTcheckBoundPhoneViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    XTUserAccountInfo *UserInfo = [XTUserStore sharedManager].user;
    CLog(@"----%@",@(UserInfo.bindStatus));
    CLog(@"--%@",UserInfo);
    
    if (UserInfo.bindStatus == 3||UserInfo.bindStatus == 4) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100];
        [button removeFromSuperview];
        self.boundButton.hidden = YES;
        self.backGroundImageView.hidden = YES;
        self.iphoneLable.text = UserInfo.phone;
    }
    self.boundButton.layer.masksToBounds = YES;
    self.boundButton.layer.cornerRadius = 16.0f;
    self.view.backgroundColor = UIColorFromRGB(0xececec);
    self.title = @"绑定手机号";

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

- (IBAction)boundsIphoneButton:(id)sender {
    XTboundphoneViewController *boundIphone = [[XTboundphoneViewController alloc]initWithNibName:@"XTboundiphoneTwoViewController" bundle:nil];
    @weakify(self){
    [boundIphone setCompletionBlock:^{
        @strongify(self){
            XTUserAccountInfo *UserInfo = [XTUserStore sharedManager].user;
            CLog(@"----%@",@(UserInfo.bindStatus));
            CLog(@"--%@",UserInfo);
            if (UserInfo.bindStatus == 3||UserInfo.bindStatus == 4) {
                UIButton *button = (UIButton *)[self.view viewWithTag:100];
                [button removeFromSuperview];
                self.boundButton.hidden = YES;
                self.iphoneLable.text = UserInfo.phone;
            }

            
        }
    }];
    }
    [self.navigationController pushViewController:boundIphone animated:YES];
}
@end
