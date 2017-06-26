//
//  XTSearchTagTableView.m
//  tian
//
//  Created by huhuan on 15/6/16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchTagTableView.h"
#import "XTSearchTagTableViewCell.h"
#import "XTPhotosListViewController.h"
#import "UIViewController+Extend.h"
#import "XTTagInfo.h"

@interface XTSearchTagTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation XTSearchTagTableView

static NSString *tagCellIdentifier = @"tagCell";

+ (XTSearchTagTableView *)tagTableView {
    XTSearchTagTableView *tagTV = [[XTSearchTagTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tagTV.backgroundColor = [UIColor clearColor];
    tagTV.dataSource = tagTV;
    tagTV.delegate = tagTV;
    tagTV.contentInset = UIEdgeInsetsMake(10., 0., 0., 0.);
    tagTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tagTV registerNib:[UINib nibWithNibName:@"XTSearchTagTableViewCell" bundle:nil] forCellReuseIdentifier:tagCellIdentifier];

    return tagTV;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XTSearchTagTableViewCell *cell = (XTSearchTagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tagCellIdentifier];
    [cell configureTagCell:self.tagArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tagArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XTTagInfo *tagInfo = self.tagArray[indexPath.row];
    
    XTPhotosListViewController *listVC = [[XTPhotosListViewController alloc] init];
    listVC.titleString = tagInfo.tag;
    listVC.type = XTphotosListLabelType;
    [[UIViewController topViewController] pushViewController:listVC animated:YES];
}


@end
