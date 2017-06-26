//
//  XTSearchTopicTableView.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTopicTableView.h"
#import "XTTopicWithUserHeaderTableViewCell.h"
#import "XTTopicIndexViewController.h"
#import "UIViewController+Extend.h"
#import "XTHotLicksTopicsInfo.h"

@interface XTSearchTopicTableView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation XTSearchTopicTableView

static NSString *topicCellIdentifier = @"topicCell";

+ (XTSearchTopicTableView *)topicTableView {
    
    XTSearchTopicTableView *topicTV = [[XTSearchTopicTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    topicTV.backgroundColor = [UIColor clearColor];
    topicTV.dataSource = topicTV;
    topicTV.delegate = topicTV;
    topicTV.showsVerticalScrollIndicator = NO;
    topicTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    topicTV.contentInset = UIEdgeInsetsMake(10., 0., 0., 0.);
    [topicTV registerNib:[UINib nibWithNibName:@"XTTopicWithUserHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:topicCellIdentifier];
    
    return topicTV;

}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XTTopicWithUserHeaderTableViewCell *cell = (XTTopicWithUserHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:topicCellIdentifier];
    [cell configWithCell:self.topicArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.topicArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XTTopicIndexViewController *topicIndexVC = [[XTTopicIndexViewController alloc] init];
    if([self.topicArray[indexPath.row] isKindOfClass:[XTHotLicksTopicsInfo class]]) {
        XTHotLicksTopicsInfo *topicModel = (XTHotLicksTopicsInfo *)self.topicArray[indexPath.row];
        topicIndexVC.topicId = topicModel.id;
        topicIndexVC.topicTitle = topicModel.title;
    }else if([self.topicArray[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        topicIndexVC.topicId = [self.topicArray[indexPath.row][@"id"] integerValue];
        topicIndexVC.topicTitle = self.topicArray[indexPath.row][@"title"];
    }
    
    [[UIViewController topViewController] pushViewController:topicIndexVC animated:YES];
}

@end
