//
//  XTRuleViewController.m
//  tian
//
//  Created by yyt on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTRuleViewController.h"
static NSString *string = @"http://m.yinyuetai.com/tian/rule";
@interface XTRuleViewController ()
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation XTRuleViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self addconstraint];
    [self addTitleLable];
 }
#pragma mark----懒加载
-(UIWebView *)webView{
    if (!_webView) {
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectZero];
        self.webView = webView;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    }
    return _webView;
}
//给导航控制器设置title
-(void)addTitleLable{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = @"声望、等级、积分规则";
    self.navigationItem.titleView = lable;
}
//添加约束
-(void)addconstraint{
            [self.webView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(@0);
                make.left.bottom.right.equalTo(self.view).offset(@0);
            }];
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

@end
