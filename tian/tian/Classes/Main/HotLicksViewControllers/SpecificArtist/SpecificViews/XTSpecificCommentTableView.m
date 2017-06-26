//
//  XTSpecificCommentTableView.m
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSpecificCommentTableView.h"
#import "XTSpecificCommentTableViewCell.h"
#import "JKUtil.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XTHotEventCommentTableViewHeader.h"
#import "XTCommentsModel.h"
#import "XTCommentItemModel.h"
#import "XTHTTPRequestOperationManager.h"
#import "NSError+XTError.h"

@interface XTSpecificCommentTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *sectionTitleLabel;
@property (nonatomic, strong) UILabel *commentNumLabel;
@property (nonatomic, strong) XTHotEventCommentTableViewHeader *headerView;

@end

@implementation XTSpecificCommentTableView

static NSString *commentCellIdentifier = @"CommentCell";

+ (XTSpecificCommentTableView *)specificCommentTableView {
    XTSpecificCommentTableView *specificCommentTV = [[XTSpecificCommentTableView alloc] initWithFrame:CGRectMake(0., 0., SCREEN_SIZE.width, SCREEN_SIZE.height-64) style:UITableViewStyleGrouped];
    specificCommentTV.backgroundColor = [UIColor clearColor];
    specificCommentTV.dataSource = specificCommentTV;
    specificCommentTV.delegate = specificCommentTV;
    specificCommentTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [specificCommentTV registerNib:[UINib nibWithNibName:@"XTSpecificCommentTableViewCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];

    return specificCommentTV;
}

- (void)configureCommentTableView {
    if(self.tableViewStyle == XTSpecificCommentTableViewStyleHeader) {
        self.headerView = [XTHotEventCommentTableViewHeader hotEventCommentTableViewHeaderWithCommentModel:self.commentModel];
        @weakify(self);
        self.headerView.lickClickBlock = ^(BOOL isPoison) {
            @strongify(self);
            if(isPoison) {
                [self requestLickApiWithBelongId:self.belongId
                                      apiAddress:@"/operate/pk/du.json"
                                        isPoison:YES];
            }else {
                [self requestLickApiWithBelongId:self.belongId
                                      apiAddress:@"/operate/pk/tian.json"
                                        isPoison:NO];
            }
        };
        self.tableHeaderView = self.headerView;
        [self.headerView configureHeaderView];
    }
    [self reloadData];
}

- (void)requestLickApiWithBelongId:(NSString *)belongId
                        apiAddress:(NSString *)apiAddress
                          isPoison:(BOOL)isPoision   {
    
    NSDictionary *parameters = @{
                                 @"id" : belongId
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *pkDic = [NSMutableDictionary dictionaryWithDictionary:self.commentModel.pk];
        if(isPoision) {
            pkDic[@"duCount"] = [NSString stringWithFormat:@"%@",@([self.commentModel.pk[@"duCount"] integerValue] + 1)];
        }else {
            pkDic[@"tianCount"] = [NSString stringWithFormat:@"%@",@([self.commentModel.pk[@"tianCount"] integerValue] + 1)];
        }
        self.commentModel.pk = [pkDic copy];
        self.headerView.commentModel = self.commentModel;
        [self.headerView configureHeaderView];
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"选择成功" withCompletionBlock:nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
}

- (void)requestPraiseApiWithUserCommentId:(NSString *)commentId
                              andBelongId:(NSString *)belongId
                            andApiAddress:(NSString *)apiAddress {
    
    NSDictionary *parameters = @{
                                 @"commentId": commentId,
                                 @"belongId" : belongId
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager GET:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XTSpecificCommentTableViewCell *cell = (XTSpecificCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:commentCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCell:self.commentModel.comments[indexPath.row]];
    
    cell.praiseClickBlock = ^(XTCommentItemModel *itemModel) {
        if(itemModel.supported) {
            itemModel.supported = NO;
            itemModel.totalSupports = [NSNumber numberWithInteger:[itemModel.totalSupports integerValue] - 1];
            [self requestPraiseApiWithUserCommentId:[NSString stringWithFormat:@"%@",itemModel.itemID] andBelongId:self.belongId andApiAddress:@"/operate/comment/cancelsupport.json"];
        }else {
            itemModel.supported = YES;
            itemModel.totalSupports = [NSNumber numberWithInteger:[itemModel.totalSupports integerValue] + 1];
            [self requestPraiseApiWithUserCommentId:[NSString stringWithFormat:@"%@",itemModel.itemID] andBelongId:self.belongId andApiAddress:@"/operate/comment/support.json"];
        }
        [self reloadData];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    self.sectionTitleLabel = [[UILabel alloc] init];
    self.sectionTitleLabel.backgroundColor = [UIColor clearColor];
    self.sectionTitleLabel.font = [UIFont systemFontOfSize:12.f];
    self.sectionTitleLabel.textColor = [JKUtil getColor:@"7b7b7b"];
    [headerView addSubview:self.sectionTitleLabel];
    
    headerView.frame = CGRectMake(0., 0., tableView.frame.size.width, 25.f);
    
    [self.sectionTitleLabel updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 14., 0., 0.));
    }];
    
    switch (section) {
        case 0: {
            if([self.commentModel.totalCount integerValue] > 0) {
                self.sectionTitleLabel.hidden = NO;
                
                self.sectionTitleLabel.text = [NSString stringWithFormat:@"评论（%@）",[self.commentModel.totalCount integerValue] > 0 ? self.commentModel.totalCount : @(0)];
                [headerView addSubview:self.commentNumLabel];
                
                [self.commentNumLabel updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 14.));
                }];
            }else {
                self.sectionTitleLabel.hidden = YES;
            }
            
            break;
        }
            
        default:
            break;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.commentModel.comments count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:commentCellIdentifier cacheByIndexPath:indexPath configuration:^(XTSpecificCommentTableViewCell *cell) {
        [cell configureCell:self.commentModel.comments[indexPath.row]];
    }];
    
}

@end
