//
//  TestCollectionViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-5-29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserFilesCollectionViewCell.h"
#import "XTUserFilesTableViewCell.h"
#import "XTSubStore.h"
#import "XTUserFilesInfo.h"
#import "YYTHUD.h"
#import "XTUserHomePageViewController.h"
@interface XTUserFilesCollectionViewCell()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *beiZhuArray;
@property (nonatomic, strong) NSDictionary *beiZhuDic;
@end

@implementation XTUserFilesCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(updateUserFiles)
//                                                     name:@"updateUserFilesNotification"
//                                                   object:nil];
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"XTUserFiles" ofType:@"plist"];
        if (!configPath) {
            [NSException raise:@"App startup fail" format:@"Can not found XTUserFiles.plist file"];
        } else {
            self.beiZhuDic = [NSDictionary dictionaryWithContentsOfFile:configPath];
        }
        self.beiZhuArray = [NSMutableArray arrayWithCapacity:5];
        [self slideView];
    }
    
    return self;
}

- (void)loadUserFilesDataWithCompletionBlock:(void(^)(NSError *error))completionBlock{
    // 没有回调表示是普通刷新，有回调表示是下拉刷新不需要提示框
    if (!completionBlock) {
        [YYTHUD showLoadingNoLockFreeCenterAddedTo:self];
    }
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = self.userID;
    [subStore fetchUserFilesWithUserId:[userId integerValue]
                       completionBlock:^(XTUserFilesInfo *userFilesInfo, NSError *error) {
                           if (!error) {
                               NSLog(@"userFilesInfo:%@",userFilesInfo);
                               [UIViewController UserHomePageController].isRefreshUserFiles = NO;
                               self.userFilesInfo = userFilesInfo;
                               NSMutableArray *beizhuArray = [NSMutableArray arrayWithArray:[self.userFilesInfo.beiZhu componentsSeparatedByString:@"↑↓"]];
                               [_beiZhuArray removeAllObjects];
                               [beizhuArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                                   NSRange range = [obj rangeOfString:@"→←"];
                                   NSString *str = [obj substringFromIndex:range.location+2];
                                   if (![str isEqualToString:@""]) {
                                       [_beiZhuArray addObject:obj];
                                   }
                               }];
                               [self.slideView reloadData];
                               if (completionBlock) {
                                   completionBlock(nil);
                               }
                           }else if (completionBlock) {
                               // 完成的回调失败不作处理
                               completionBlock(error);
                           }
                           [YYTHUD hideLoadingFrom:self];
                       }];
}

//- (void)updateUserFiles{
//    //[self performSelector:@selector(loadUserFilesData) withObject:self afterDelay:2];
//    [self loadUserFilesDataWithCompletionBlock:nil];
//}

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 2;
        }
            break;
        case 1:{
            return 6;
        }
            break;
        case 2:{
            return [self.beiZhuArray count];
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserFilesCell = @"XTUserFilesTableViewCell";
    XTUserFilesTableViewCell *cell = (XTUserFilesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:UserFilesCell];
    if (cell == nil) {
        cell = [[XTUserFilesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UserFilesCell];
    }
    [self resetUserFilesTableViewCell:cell];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_renown"];
                    cell.titleLabel.text = @"声望";
                    cell.contentLabel.text = _userFilesInfo.renownCount;
                    cell.valueLabel.text = [NSString stringWithFormat:@"今日+%@", _userFilesInfo.renownToday];
                }
                    break;
                case 1:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_credits"];
                    cell.titleLabel.text = @"积分";
                    cell.contentLabel.text = _userFilesInfo.creditsCount;
                    if ([_userFilesInfo.creditsToday integerValue] < 0) {
                        cell.valueLabel.text = [NSString stringWithFormat:@"今日%@", _userFilesInfo.creditsToday];
                    }else{
                        cell.valueLabel.text = [NSString stringWithFormat:@"今日+%@", _userFilesInfo.creditsToday];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_gender"];
                    cell.titleLabel.text = @"性别";
                    cell.contentLabel.text = _userFilesInfo.gender;
                    cell.valueLabel.text = @"";
                }
                    break;
                case 1:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_age"];
                    cell.titleLabel.text = @"年龄";
                    cell.contentLabel.text = _userFilesInfo.age;
                }
                    break;
                case 2:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_star"];
                    cell.titleLabel.text = @"星座";
                    cell.contentLabel.text = _userFilesInfo.star;
                }
                    break;
                case 3:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_address"];
                    cell.titleLabel.text = @"地址";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@", _userFilesInfo.province?_userFilesInfo.province:@"",_userFilesInfo.city?_userFilesInfo.city:@""];
                }
                    break;
                case 4:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_qingGan"];
                    cell.titleLabel.text = @"情感";
                    cell.contentLabel.text = _userFilesInfo.qingGan;
                }
                    break;
                case 5:{
                    cell.iconImageView.image = [UIImage imageNamed:@"icon_brief"];
                    cell.titleLabel.text = @"签名";
                    cell.contentLabel.text = _userFilesInfo.brief;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            NSString *str = [self.beiZhuArray objectAtIndex:indexPath.row];
            NSRange range = [str rangeOfString:@"→←"];
            NSString *keyStr = [str substringToIndex:range.location];
            cell.iconImageView.image = [UIImage imageNamed:[_beiZhuDic objectForKey:keyStr]?[_beiZhuDic objectForKey:keyStr]:@"icon_default"];
            cell.titleLabel.text = keyStr;
            cell.contentLabel.text = [str substringFromIndex:range.location+2];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)resetUserFilesTableViewCell:(XTUserFilesTableViewCell *)cell{
    cell.iconImageView.image = [UIImage imageNamed:@""];
    cell.titleLabel.text = @"";
    cell.contentLabel.text = @"";
    cell.valueLabel.text = @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 0.0;
    }else{
        return 16.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.xtwidth, 16)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableView *)slideView{
    if (!_slideView) {
        _slideView = [SlideTableView new];
        _slideView.tableViewCellStyle = XTTopicTableViewCellStyleOwn;
        _slideView.backgroundView = [[UIView alloc] init];
        _slideView.backgroundView.backgroundColor = UIColorFromRGB(0xececec);
        _slideView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slideView.delegate = self;
        _slideView.dataSource = self;
        [self addSubview:_slideView];
        [_slideView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.bottom.right.equalTo(self);
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
