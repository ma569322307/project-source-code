//
//  XTUserHonourCollectViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-6-15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserHonourCollectViewCell.h"
#import "XTUserHonourTableViewCell.h"
#import "XTSubStore.h"
#import "XTUserStore.h"
#import <MJRefresh.h>
@interface XTUserHonourCollectViewCell()<UITableViewDataSource, UITableViewDelegate>
@end
@implementation XTUserHonourCollectViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a image view
        [self slideView];
    }
    
    return self;
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"1111-----%f,%f",point.x,point.y);
    scrollView.bounces = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"2222-----%f,%f",point.x,point.y);
    NSLog(@"velocity:%f,%f,targetContentOffset:%f,%f",velocity.x,velocity.y,(*targetContentOffset).x,(*targetContentOffset).y);
    if ((*targetContentOffset).y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:velocity.y]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    NSLog(@"4444-----%f,%f",point.x,point.y);
    if (point.y <= 0) {
        scrollView.bounces = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:-point.y]];
    }
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.honours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserHonourCell = @"XTUserHonourTableViewCell";
    XTUserHonourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserHonourCell];
    if (cell == nil) {
        cell = [[XTUserHonourTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserHonourCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell.lineView updateConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.right.equalTo(cell.contentView);
//        make.height.equalTo(@8);
//    }];
    NSString *str = [[self.honours objectAtIndex:0] objectForKey:@"imgUrl"];
    
//    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        //[YYTConfig sharedConfig].networkFlow = receivedSize;
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//        [cell.iconImageView setImage:image];
//        [cell.iconImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//        [cell.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [cell.iconImageView setClipsToBounds:YES];
//        cell.iconImageView.alpha = 0.0;
//        [UIView animateWithDuration:1.0f animations:^{
//            cell.iconImageView.alpha = 1.0;
//        }];
//    }];
    [cell.iconImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [cell.iconImageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell.iconImageView setClipsToBounds:YES];
    [cell.iconImageView an_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
//    if (indexPath.row == [self.honours count]-1) {
//        [cell.lineView updateConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(cell.contentView);
//            make.height.equalTo(@0);
//        }];
//    }
    cell.titleLabel.text = [[self.honours objectAtIndex:0] objectForKey:@"name"];
    cell.contentLabel.text = [[self.honours objectAtIndex:0] objectForKey:@"depict"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [self.honours count]-1) {
        return 85.0f;
    }
    return 93.0f;
}

- (UITableView *)slideView{
    if (!_slideView) {
        _slideView = [SlideTableView new];
        _slideView.tableViewCellStyle = XTTopicTableViewCellStyleOwn;
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = [UIColor whiteColor];
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slideView.delegate = self;
        _slideView.dataSource = self;
        
        [self addSubview:_slideView];
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.and.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 8, 0, 8));
        }];
    }
    return _slideView;
}

- (void)setContentOffset:(CGPoint)point{
    [self.slideView setContentOffset:point animated:YES];
}

- (void)setSlideViewState:(State)state{
    self.slideView.tState = state;
}

- (State)slideViewState{
    return self.slideView.tState;
}

@end
