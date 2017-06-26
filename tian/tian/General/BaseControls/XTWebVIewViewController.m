//
//  XTWebVIewViewController.m
//  tian
//
//  Created by cc on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTWebVIewViewController.h"

@interface XTWebVIewViewController ()<UIWebViewDelegate>

@end

@implementation XTWebVIewViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    if (self.theUrl) {
        [self.theWebView loadRequest:[NSURLRequest requestWithURL:self.theUrl]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [YYTHUD showLoadingAddedTo:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [YYTHUD hideLoadingFrom:self.view];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [YYTHUD hideLoadingFrom:self.view];
    [YYTHUD showPromptAddedTo:self.view withText:@"加载网页失败" withCompletionBlock:nil];
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
