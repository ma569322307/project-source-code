//
//  XTWebVIewViewController.h
//  tian
//
//  Created by cc on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTRootViewController.h"

@interface XTWebVIewViewController : XTRootViewController
@property (weak, nonatomic) IBOutlet UIWebView *theWebView;
@property (strong, nonatomic) NSURL *theUrl;
@end
