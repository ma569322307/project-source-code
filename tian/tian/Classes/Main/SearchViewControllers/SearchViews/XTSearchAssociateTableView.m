//
//  XTSearchAssociateTableView.m
//  tian
//
//  Created by huhuan on 15/6/17.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchAssociateTableView.h"

@interface XTSearchAssociateTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XTSearchAssociateTableView

+ (XTSearchAssociateTableView *)associateTableView {

    XTSearchAssociateTableView *associateTV = [[XTSearchAssociateTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    associateTV.backgroundColor = [UIColor whiteColor];
    associateTV.dataSource = associateTV;
    associateTV.delegate = associateTV;
    associateTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    associateTV.contentInset = UIEdgeInsetsMake(0., 0., 300., 0.);
    if ([associateTV respondsToSelector:@selector(setSeparatorInset:)]) {
        [associateTV setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([associateTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [associateTV setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return associateTV;

}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AssociateCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 1001;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.textColor = UIColorFromRGB(0x595959);
        [cell.contentView addSubview:titleLabel];
        [titleLabel updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.offset(@20);
            make.right.offset(@10);
            make.height.mas_equalTo(@17);
        }];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1001];
    titleLabel.text = self.associateArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.cellClick) {
        self.cellClick(self.associateArray[indexPath.row]);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.associateArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
    
}

@end
