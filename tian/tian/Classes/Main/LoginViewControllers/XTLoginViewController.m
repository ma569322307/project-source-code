//
//  XTLoginViewController.m
//  tian
//
//  Created by cc on 15-5-18.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTLoginViewController.h"
#import "XTShareManager.h"
#import "XTLoginInputViewController.h"
#import "XTWebVIewViewController.h"
#import "XTRongCloudManager.h"
#import "XTGuideManage.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
@interface XTLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation XTLoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

//    
//    self.logoImageV_Height.constant = SCREEN_SIZE.width*(175/750);
//    self.logoImageV_width.constant = SCREEN_SIZE.width*(175/750);
    //新浪微博
    if (![WeiboSDK isWeiboAppInstalled])
    {
        self.sinaLoginBtn.hidden = YES;
    }
    if (![QQApi isQQInstalled]) {
        self.qqLoginBtn.hidden = YES;
    }
    if (![WXApi isWXAppInstalled]) {
        self.wxloginBtn.hidden = YES;
    }
    
//    self.sinaLoginBtn.hidden = NO;
//    self.qqLoginBtn.hidden = NO;
//    self.wxloginBtn.hidden = NO;
//    
    [self updataLoginBtnFrame];
    // Do any additional setup after loading the view from its nib.
}
- (void)updataLoginBtnFrame
{
    if (self.sinaLoginBtn.hidden == YES&&self.qqLoginBtn.hidden == YES&&self.wxloginBtn.hidden == NO) {
        
        [self.wxloginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.centerY.equalTo(self.backView);
        }];
    }else if(!self.sinaLoginBtn.hidden&&self.qqLoginBtn.hidden&&self.wxloginBtn.hidden)
    {
        [self.sinaLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView);
            make.centerY.equalTo(self.backView.centerY);
        }];
    }else if(!self.sinaLoginBtn.hidden&&!self.qqLoginBtn.hidden&&self.wxloginBtn.hidden)
    {
        [self.sinaLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(0.6);
            make.centerY.equalTo(self.backView.centerY);
        }];
        [self.qqLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(1.4);
            make.centerY.equalTo(self.backView.centerY);
        }];
    }else if(self.sinaLoginBtn.hidden&&!self.qqLoginBtn.hidden&&!self.wxloginBtn.hidden)
    {
        [self.wxloginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(0.6);
            make.centerY.equalTo(self.backView.centerY);
        }];
        [self.qqLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(1.4);
            make.centerY.equalTo(self.backView.centerY);
        }];
        
    }else if(!self.sinaLoginBtn.hidden&&self.qqLoginBtn.hidden&&!self.wxloginBtn.hidden)
    {
        [self.sinaLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(0.6);
            make.centerY.equalTo(self.backView.centerY);
        }];
        [self.wxloginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(1.4);
            make.centerY.equalTo(self.backView.centerY);
        }];
    }else{
        [self.qqLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(1.0);
            make.centerY.equalTo(self.backView.centerY);
        }];
        [self.sinaLoginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(0.5);
            make.centerY.equalTo(self.backView.centerY);
        }];
        [self.wxloginBtn updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.backView.centerX).multipliedBy(1.5);
            make.centerY.equalTo(self.backView.centerY);
        }];
    }
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

- (IBAction)clickLoginBtn:(id)sender {
    XTLoginInputViewController *loginInputVC = [[XTLoginInputViewController alloc] init];
  //  loginInputVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:loginInputVC animated:YES];
}
- (IBAction)clickOtherLoginBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            CLog(@"点击了 新浪登陆按钮");
            [[XTShareManager sharedManager] ssoSinaLogin:^{
                [[XTRongCloudManager shareInstance] rongCloudLogin];
                [UIApplication sharedApplication].keyWindow.rootViewController = [XTGuideManage createDispayViewController];
            }];
            break;
        }
        case 2:
        {
            CLog(@"点击了 QQ登陆按钮");
            [[XTShareManager sharedManager] ssoQQLogin:^{
                [[XTRongCloudManager shareInstance] rongCloudLogin];
                [UIApplication sharedApplication].keyWindow.rootViewController = [XTGuideManage createDispayViewController];
            }];
            break;
        }
        case 3:
        {
            CLog(@"点击了 微信登陆按钮");
            [[XTShareManager sharedManager] WXLogin:^{
                [[XTRongCloudManager shareInstance] rongCloudLogin];
                [UIApplication sharedApplication].keyWindow.rootViewController = [XTGuideManage createDispayViewController];
            }];
            break;
        }
        default:
            break;
    }
}

- (IBAction)clickTkBtn:(id)sender {
    CLog(@"服务条款");
    XTWebVIewViewController *webVC = [[XTWebVIewViewController alloc]init];
    webVC.theUrl = [NSURL URLWithString:@"http://m.yinyuetai.com/tian/copyright"];
    [self.navigationController pushViewController:webVC animated:YES];
    
}
#pragma mark 懒加载
-(UIButton *)wxloginBtn
{
    if (_wxloginBtn == nil) {
        _wxloginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wxloginBtn setImage:[UIImage imageNamed:@"login_wx"] forState:UIControlStateNormal];
        [_wxloginBtn setImage:[UIImage imageNamed:@"login_wx_p"] forState:UIControlStateHighlighted];
        _wxloginBtn.tag = 3;
        [_wxloginBtn addTarget:self action:@selector(clickOtherLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_wxloginBtn];
    }
    return _wxloginBtn;
}
-(UIButton *)qqLoginBtn
{
    if (_qqLoginBtn == nil) {
        _qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLoginBtn setImage:[UIImage imageNamed:@"login_qq"] forState:UIControlStateNormal];
        [_qqLoginBtn setImage:[UIImage imageNamed:@"login_qq_p"] forState:UIControlStateHighlighted];
        _qqLoginBtn.tag = 2;
        [_qqLoginBtn addTarget:self action:@selector(clickOtherLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_qqLoginBtn];
    }
    return _qqLoginBtn;
}
-(UIButton *)sinaLoginBtn
{
    if (_sinaLoginBtn == nil) {
        _sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sinaLoginBtn setImage:[UIImage imageNamed:@"login_xl"] forState:UIControlStateNormal];
        [_sinaLoginBtn setImage:[UIImage imageNamed:@"login_xl_p"] forState:UIControlStateHighlighted];
        _sinaLoginBtn.tag = 1;
        [_sinaLoginBtn addTarget:self action:@selector(clickOtherLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_sinaLoginBtn];
    }
    return _sinaLoginBtn;
}
@end
