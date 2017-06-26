//
//  XTTopicIndexTableView.m
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicTableView.h"
#import "NSString+TextSize.h"
#import "XTPostInfo.h"
#import "XTTopicInfo.h"
#import "XTTopicIndexTableViewCell.h"
#import "XTPostTableViewCell.h"
#import "XTShareManager.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTTopicIndexHeaderView.h"
#import "NSError+XTError.h"
#import "XTUserStore.h"

@interface XTTopicTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *cellHeightCacheDic;
@property (nonatomic, assign) float imageViewWidth;
@property (nonatomic, assign) float imageViewHeight;

@end

@implementation XTTopicTableView

static NSString *topicIndexCellIdentifier = @"TopicCell";
static NSString *postIndexCellIdentifier  = @"PostCell";

static NSString *complaintUrl = @"/topic/posts/complaint.json";
static NSString *topUrl       = @"/topic/posts/top.json";
static NSString *cancelTopUrl = @"/topic/posts/top/cancel.json";
static NSString *deleteUrl    = @"/topic/posts/delete.json";

+ (XTTopicTableView *)topicTableViewWithCellStyle:(XTTopicTableViewCellStyle)cellStyle {
    XTTopicTableView *topicTV = [[XTTopicTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    topicTV.cellHeightCacheDic = [NSMutableDictionary dictionary];
    topicTV.backgroundColor = [UIColor clearColor];
    topicTV.dataSource = topicTV;
    topicTV.delegate = topicTV;
    topicTV.showsVerticalScrollIndicator = NO;
    [topicTV registerNib:[UINib nibWithNibName:@"XTTopicIndexTableViewCell" bundle:nil] forCellReuseIdentifier:topicIndexCellIdentifier];
    [topicTV registerNib:[UINib nibWithNibName:@"XTPostTableViewCell" bundle:nil] forCellReuseIdentifier:postIndexCellIdentifier];
    topicTV.tableViewCellStyle = cellStyle;
    topicTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return topicTV;
}

- (void)refreshTableView {
    [self.cellHeightCacheDic removeAllObjects];
    [self reloadData];

}

- (void)moreHandler:(XTPostInfo *)postInfo andImage:(UIImage *)shareImage {
    if(self.isMine) {
        if(postInfo.top) {

            [[XTShareManager sharedManager] shareWithTitle:self.topicTitle
                                                withMvDesc:postInfo.postDescription
                                                 withImage:shareImage
                                         withShareModeType:XTShareModeTypeTopicDetails
                                                   withPid:postInfo.postId
                                        withShareSheetType:XTShareSheetItemCancelTop | XTShareSheetItemDelete
                                       withCompletionBlock:^(NSInteger index) {
                if(index == 1) {
                    [self requestCanceltopWithPostInfo:postInfo];
                }else if(index == 2) {
                    [self requestDeleteWithPostInfo:postInfo];
                }
            }];
            
        }else {
            
            [[XTShareManager sharedManager] shareWithTitle:self.topicTitle
                                                withMvDesc:postInfo.postDescription
                                                 withImage:shareImage
                                         withShareModeType:XTShareModeTypeTopicDetails
                                                   withPid:postInfo.postId
                                        withShareSheetType:XTShareSheetItemTop | XTShareSheetItemDelete
                                       withCompletionBlock:^(NSInteger index) {
                if(index == 1) {
                    [self requestTopWithPostInfo:postInfo];
                }else if(index == 2) {
                    [self requestDeleteWithPostInfo:postInfo];
                }
            }];
            
        }
    }else if(postInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        [[XTShareManager sharedManager] shareWithTitle:self.topicTitle
                                            withMvDesc:postInfo.postDescription
                                             withImage:shareImage
                                     withShareModeType:XTShareModeTypeTopicDetails
                                               withPid:postInfo.postId
                                    withShareSheetType:XTShareSheetItemDelete
                                   withCompletionBlock:^(NSInteger index) {
                                       if(index == 1) {
                                           [self requestDeleteWithPostInfo:postInfo];
                                       }
                                   }];
    }else {
        [[XTShareManager sharedManager] shareWithTitle:self.topicTitle
                                            withMvDesc:postInfo.postDescription
                                             withImage:shareImage
                                     withShareModeType:XTShareModeTypeTopicDetails
                                               withPid:postInfo.postId
                                    withShareSheetType:XTShareSheetItemWarning
                                   withCompletionBlock:^(NSInteger index) {
            if(index == 1) {
                [self requestComplaintWithPostInfo:postInfo];
            }
        }];
    }
    
}

- (void)requestComplaintWithPostInfo:(XTPostInfo *)postInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{@"postId" : @(postInfo.postId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:complaintUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        @weakify(self);
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"举报成功" withCompletionBlock:^{
//            @strongify(self);
//            if(self.refreshTopicInfo) {
//                self.refreshTopicInfo();
//            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
}

- (void)requestTopWithPostInfo:(XTPostInfo *)postInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{
                                 @"topicId" : @(self.topicId),
                                 @"postId" : @(postInfo.postId)
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:topUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        if([responseObject[@"rs"] integerValue] == 200) {
            @weakify(self);
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"置顶成功" withCompletionBlock:^{
                @strongify(self);
                if(self.refreshTopicInfo) {
                    self.refreshTopicInfo();
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)requestCanceltopWithPostInfo:(XTPostInfo *)postInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{
                                 @"topicId" : @(self.topicId),
                                 @"postId" : @(postInfo.postId)
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:cancelTopUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"rs"] integerValue] == 200) {
            [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
            @weakify(self);
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"取消置顶成功" withCompletionBlock:^{
                @strongify(self);
                if(self.refreshTopicInfo) {
                    self.refreshTopicInfo();
                }
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)requestDeleteWithPostInfo:(XTPostInfo *)postInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{@"postId" : @(postInfo.postId)};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:deleteUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @weakify(self);
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"删除成功" withCompletionBlock:^{
            @strongify(self);
            if(self.refreshTopicInfo) {
                self.refreshTopicInfo();
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    if([self.topicArray[indexPath.row] isKindOfClass:[XTPostInfo class]]) {
        XTPostTableViewCell *postCell = (XTPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:postIndexCellIdentifier];
        [postCell configureCell:self.topicArray[indexPath.row] andCellStyle:self.tableViewCellStyle];
        @weakify(self);
        postCell.moreClick = ^(XTPostInfo *postInfo, UIImage *shareImage) {
            @strongify(self);
            [self moreHandler:postInfo andImage:shareImage];
        };
        cell = postCell;
    }else if ([self.topicArray[indexPath.row] isKindOfClass:[XTTopicInfo class]]) {
        XTTopicIndexTableViewCell *topicCell = (XTTopicIndexTableViewCell *)[tableView dequeueReusableCellWithIdentifier:topicIndexCellIdentifier];
        [topicCell configureCell:self.topicArray[indexPath.row]];
        cell = topicCell;
    }else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UnknownCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.topicCellClick) {
        self.topicCellClick(self.topicArray[indexPath.row]);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.topicArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float cellHeight = 0;
    if(self.cellHeightCacheDic[indexPath]) {
        cellHeight = [self.cellHeightCacheDic[indexPath] floatValue];
    }else {
    
        if([self.topicArray[indexPath.row] isKindOfClass:[XTPostInfo class]]) {
            XTPostTableViewCell *postCell = (XTPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:postIndexCellIdentifier];
            cellHeight = [postCell heightForIndexPath:self.topicArray[indexPath.row] andCellStyle:self.tableViewCellStyle];
        }else if ([self.topicArray[indexPath.row] isKindOfClass:[XTTopicInfo class]]) {
            cellHeight = 140;
        }
        self.cellHeightCacheDic[indexPath] = [NSNumber numberWithFloat:cellHeight];
    }
    return cellHeight;
}

//- (void)reloadData {
//    [self.cellHeightCacheDic removeAllObjects];
//    [super reloadData];
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(self.tableViewCellStyle == XTTopicTableViewCellStyleOwn) {
        scrollView.bounces = YES;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if(self.tableViewCellStyle == XTTopicTableViewCellStyleOwn) {
        if ((*targetContentOffset).y <= 0) {
            scrollView.bounces = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:velocity.y]];
        }
    }else if(scrollView.contentOffset.y < -110) {
        if(self.refreshTopicInfo) {
            [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.refreshTopicInfo();
            });
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.tableViewCellStyle == XTTopicTableViewCellStyleOwn) {
        CGPoint point = scrollView.contentOffset;
        if (point.y <= 0) {
            scrollView.bounces = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustContainerViewNotifition" object:[NSNumber numberWithFloat:-point.y]];
        }
    }else if([self.tableHeaderView isKindOfClass:[XTTopicIndexHeaderView class]]){
        
        XTTopicIndexHeaderView *headerView = (XTTopicIndexHeaderView *)self.tableHeaderView;
        CGFloat yOffset   = self.contentOffset.y;
        UIImageView *contentImageView = headerView.contentImageView;
        
        if(self.imageViewWidth == 0) {
            [headerView layoutIfNeeded];
            [contentImageView layoutIfNeeded];
            self.imageViewWidth = contentImageView.frame.size.width;
            self.imageViewHeight = contentImageView.frame.size.height;
            
        }
        if (yOffset < 0) {
            
//            float contentOriginX = 0;
//            float contentWidth = self.imageViewWidth;

//            CGFloat factor = (((ABS(yOffset)+(self.imageViewHeight))*self.imageViewWidth)/(self.imageViewHeight));
            
//            if(imageViewCurrentHeight > self.imageViewWidth-50) {
//                contentOriginX = -(factor-self.imageViewWidth)/2;
//                contentWidth = factor;
//            }
//            if(contentOriginX >= 0) {
//                contentOriginX = 0;
//            }
//            if(contentWidth <= self.imageViewWidth) {
//                contentWidth = self.imageViewWidth;
//            }
            
            CGRect f = CGRectMake(0, yOffset, self.imageViewWidth, self.imageViewHeight+ABS(yOffset));
            contentImageView.frame = f;
        }
        
    }
}

@end
