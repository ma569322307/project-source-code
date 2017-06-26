//
//  XTTopicRuleViewController.m
//  tian
//
//  Created by yyt on 15/7/8.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTTopicRuleViewController.h"
#define K_GUIZE_LISTURL  @"http://m.yinyuetai.com/tian/rankingRule"
@interface XTTopicRuleViewController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XTTopicRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @" 规则";
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:K_GUIZE_LISTURL]]];
    [self.view addSubview:self.webView];

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
