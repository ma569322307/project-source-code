//
//  XTPushToOtherVCManager.m
//  tian
//
//  Created by cc on 15/7/14.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTPushToOtherVCManager.h"
#import "XTHotEventsViewController.h"
#import "XTVSpreadViewController.h"
#import "XTSeriesContentController.h"
#import "XTHotTopicViewController.h"
#import "XTSpecificArtistViewController.h"
#import "XTOriginalViewController.h"
#import "XTTopicIndexViewController.h"
#import "XTWebVIewViewController.h"
#import "XTMessageInfo.h"
@implementation XTPushToOtherVCManager
+ (void)pushMessagePushToOtherViewControllerWithType:(NSString *)type withViewController:(UINavigationController *)viewController withModel:(XTMessageInfo *)messageInfo
{
    UIViewController *toViewController = nil;
    if ([type isEqualToString:@"topic"]) {
        //话题
        XTTopicIndexViewController *topicCtr = [[XTTopicIndexViewController alloc] init];
        topicCtr.topicId = [messageInfo.dataId integerValue];
        toViewController = topicCtr;
    }else if ([type isEqualToString:@"album"])
    {//相册
        
        XTOriginalViewController *originalVC = [[XTOriginalViewController alloc]init];
        originalVC.pictureId = [messageInfo.dataId integerValue];
        originalVC.type = XTPageTypeOther;
        toViewController = originalVC;
    
    }else if ([type isEqualToString:@"link"])
    {//链接
        XTWebVIewViewController *webView = [[XTWebVIewViewController alloc]init];
        webView.theUrl = [NSURL URLWithString:messageInfo.dataId];
        toViewController = webView;
        
    }else if ([type isEqualToString:@"xlnr"])
    {//系列内容
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTSeriesContentController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTSeriesContentController"];
        controller.itemID = [NSNumber numberWithInteger:[messageInfo.dataId integerValue]];
        toViewController = controller;
        
    }else if ([type isEqualToString:@"djyc"])
    {//独家原创
        XTOriginalViewController *originalVC = [[XTOriginalViewController alloc]init];
        originalVC.originalId = [messageInfo.dataId integerValue];
        originalVC.type = XTPageTypeOriginal;
        toViewController = originalVC;
        
    }else if ([type isEqualToString:@"zsyr"])
    {//专属艺人
        XTSpecificArtistViewController *artistVC = [[XTSpecificArtistViewController alloc] init];
        artistVC.recommendId = [messageInfo.dataId integerValue];
//        artistVC.recommendTitle = recInfo.title;
        toViewController = artistVC;
    }else if ([type isEqualToString:@"rdsj"])
    {//热点事件
        XTHotEventsViewController *hotEventVC = [[XTHotEventsViewController alloc] init];
        hotEventVC.hotEventsId = [messageInfo.dataId integerValue];
//        hotEventVC.hotEventsTitle = recInfo.title;
        toViewController = hotEventVC;

    }else if ([type isEqualToString:@"rmht"])
    {//热门话题
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
        XTHotTopicViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTHotTopicViewController"];
        controller.itemID = [NSNumber numberWithInteger:[messageInfo.dataId integerValue]];
        toViewController = controller;
    }else if ([type isEqualToString:@"dvxc"])
    {//大V宣传
        XTVSpreadViewController *spreadVC = [[XTVSpreadViewController alloc] init];
        spreadVC.recId = [messageInfo.dataId integerValue];
//        spreadVC.recTitle = recInfo.title;
        toViewController = spreadVC;
        
    }
    [viewController pushViewController:toViewController animated:YES];
}
@end
