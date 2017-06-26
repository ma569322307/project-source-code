//
//  XTNewAlbumViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTNewAlbumViewController.h"
#import "XTAddTagViewController.h"
#import "XTEditAlbumNameTableViewCell.h"
#import "XTEditDesTableViewCell.h"
#import "AddTagTableViewCell.h"
#import "XTSetAlbumTableViewCell.h"
#import "XTSelectCoverTableViewCell.h"
#import "XTSetFootView.h"
#import "XTSubStore.h"
#import "XTEditUserInfoViewController.h"
#import "UIImage+rn_Blur.h"
#import "YYTAlertView.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTBatchSettingPicturesViewController.h"
static NSString * const XTMessageSetTableViewCellIdentifier = @"XTMessageSetTableViewCell";
static NSString * const XTSetTableViewCellIdentifier = @"XTSetTableViewCell";

@interface XTNewAlbumViewController()<UITableViewDataSource, UITableViewDelegate, AddTagCellDelegate, SetFootViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) XTEditAlbumNameTableViewCell *albumNameCell;
@property (nonatomic, strong) XTEditDesTableViewCell *albumNameCell;
@property (nonatomic, strong) XTEditDesTableViewCell *albumDesCell;
@property (nonatomic, strong) AddTagTableViewCell *albumTagCell;
@property (nonatomic, strong) XTSetAlbumTableViewCell *albumSetCell;
@property (nonatomic, strong) XTSelectCoverTableViewCell *albumCoverCell;
//原数据
@property (nonatomic, strong) NSArray *tags;
@end

@implementation XTNewAlbumViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type == XTAlbumChangeTypeNew) {
        self.navigationItem.title = @"新建图册";
    }else if (self.type == XTAlbumChangeTypeEdit){
        self.navigationItem.title = @"编辑图册";
    }
    
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(uploadAblumInfo)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    [self tableView];
}

- (void)uploadAblumInfo
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    //[self.albumNameCell.textView resignFirstResponder];
    XTAlbumInfo *info = [[XTAlbumInfo alloc] init];
    //info.title = self.albumNameCell.textView.text.length > 0?self.albumNameCell.textView.text:@"默认图册";
    info.title = self.albumNameCell.contentLabel.text.length > 0?self.albumNameCell.contentLabel.text:@"默认图册";
    info.des = self.albumDesCell.contentLabel.text.length > 0?self.albumDesCell.contentLabel.text:@"";
    info.type = self.albumSetCell.messageSwitch.on?AlbumTypeSecret:AlbumTypePublic;
    info.tags = self.albumTagCell.tagView.tags;
    if (self.type == XTAlbumChangeTypeEdit) {
        info.id = self.albumInfo.id;
        info.cover = self.albumInfo.cover;
    }
    
    XTSubStore *subStore = [[XTSubStore alloc] init];
    if (self.type == XTAlbumChangeTypeNew) {
        [subStore newAlbumWithAlbumInfo:info
                        completionBlock:^(XTAlbumInfo *albumInfo, NSError *error) {
                            NSLog(@"%@",albumInfo);
                            if (!error) {
                                [YYTHUD showPromptAddedTo:self.view
                                                 withText:@"图册新建成功"
                                      withCompletionBlock:^{
                                          [self.navigationController popViewControllerAnimated:YES];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNewAlbumListNotification" object:nil];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumHeadNotification" object:nil];
                                      }];
                            }else{
                                [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:[error xtErrorMessage] delegate:nil];
                            }
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                        }];
    }else{
        [subStore editAlbumWithAlbumInfo:info
                         completionBlock:^(id favoriteVideos, NSError *error) {
                            if (!error) {
                                self.albumInfo = info;//编辑相册成功后，更新数据模型，更新马坚辉界面
                                [YYTHUD showPromptAddedTo:self.view
                                                 withText:@"图册修改成功"
                                      withCompletionBlock:^{
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumHeadNotification" object:nil];
                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
                                      }];
                            }else{
                                [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:[error xtErrorMessage] delegate:nil];
                            }
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                         }];
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == XTAlbumChangeTypeEdit && self.albumInfo.picCount > 1){
        return 5;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AlbumNameCellIdentifier = @"AlbumNameCellIdentifier";
    static NSString *AlbumDesCellIdentifier = @"AlbumDesCellIdentifier";
    static NSString *AlbumAddTagCellIdentifier = @"AlbumAddTagCellIdentifier";
    static NSString *AlbumTypeCellIdentifier = @"AlbumTypeCellIdentifier";
    static NSString *AlbumCoverCellIdentifier = @"AlbumCoverCellIdentifier";
    
    switch (indexPath.row) {
        case 0:{
            /*
            XTEditAlbumNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumNameCellIdentifier];
            if (cell == nil) {
                cell = [[XTEditAlbumNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumNameCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.type == XTAlbumChangeTypeEdit) {
                cell.textView.text = self.albumInfo.title;
            }
            self.albumNameCell = cell;
            return cell;*/
            
            XTEditDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumDesCellIdentifier];
            if (cell == nil) {
                cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumDesCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"名称";
            if (self.type == XTAlbumChangeTypeEdit) {
                cell.contentLabel.text = self.albumInfo.title;
            }
            [cell.buttomLineView updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(cell.contentView);
                make.height.equalTo(@0.5);
            }];
            self.albumNameCell = cell;
            return cell;
        }
            break;
        case 1:{
            XTEditDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumDesCellIdentifier];
            if (cell == nil) {
                cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumDesCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = @"描述";
            if (self.type == XTAlbumChangeTypeEdit) {
                cell.contentLabel.text = self.albumInfo.des;
            }
            [cell.buttomLineView updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(cell.contentView);
                make.height.equalTo(@0.5);
            }];
            self.albumDesCell = cell;
            return cell;
        }
            break;
        case 2:{
            AddTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumAddTagCellIdentifier];
            if (cell == nil) {
                cell = [[AddTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumAddTagCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.type == XTAlbumChangeTypeEdit && [self.albumInfo.tags count]>0) {
                self.tags = self.albumInfo.tags.mutableCopy;
                [cell.tagView addTags:self.albumInfo.tags];
                cell.placeholderLabel.hidden = YES;
            }
            cell.delegate = self;
            self.albumTagCell = cell;
            return cell;
        }
            break;
        case 3:{
            XTSetAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumTypeCellIdentifier];
            if (cell == nil) {
                cell = [[XTSetAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumTypeCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.type == XTAlbumChangeTypeEdit) {
                if (self.albumInfo.type == AlbumTypeSecret) {
                    cell.messageSwitch.on = YES;
                }else if (self.albumInfo.type == AlbumTypePublic){
                    cell.messageSwitch.on = NO;
                }
            }
            [cell.buttomLineView updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(cell.contentView);
                make.height.equalTo(@0.5);
            }];
            self.albumSetCell = cell;
            return cell;
        }
            break;
        case 4:{
            XTSelectCoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AlbumCoverCellIdentifier];
            if (cell == nil) {
                cell = [[XTSelectCoverTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AlbumCoverCellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.type == XTAlbumChangeTypeEdit) {
//                [cell.coverImageView sd_setImageWithURL:self.albumInfo.cover placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    
//                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    [cell.coverImageView setImage:image];
//                    [cell.coverImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//                    [cell.coverImageView setContentMode:UIViewContentModeScaleAspectFill];
//                    [cell.coverImageView setClipsToBounds:YES];
//                    cell.coverImageView.alpha = 0.0;
//                    [UIView animateWithDuration:1.0f animations:^{
//                        cell.coverImageView.alpha = 1.0;
//                    }];
//                }];
                [cell.coverImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                [cell.coverImageView setContentMode:UIViewContentModeScaleAspectFill];
                [cell.coverImageView setClipsToBounds:YES];
                [cell.coverImageView an_setImageWithURL:self.albumInfo.cover placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
            }
            [cell.buttomLineView updateConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.right.equalTo(cell.contentView);
                make.height.equalTo(@0.5);
            }];
            self.albumCoverCell = cell;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateAlbumDes:)
                                                     name:EditUserInfoNotification
                                                   object:nil];
        
        XTEditUserInfoViewController *editInfoCtr = [[XTEditUserInfoViewController alloc] init];
        editInfoCtr.title = @"名称";
        editInfoCtr.placeHolderText = self.albumNameCell.contentLabel.text;
        editInfoCtr.type = XTEditAlbumTypeName;
        editInfoCtr.count = 30;
        [self.navigationController pushViewController:editInfoCtr animated:YES];
    }
    
    if (indexPath.row == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateAlbumDes:)
                                                     name:EditUserInfoNotification
                                                   object:nil];
        
        XTEditUserInfoViewController *editInfoCtr = [[XTEditUserInfoViewController alloc] init];
        editInfoCtr.title = @"描述";
        editInfoCtr.placeHolderText = self.albumDesCell.contentLabel.text;
        editInfoCtr.type = XTEditAlbumTypeDes;
        editInfoCtr.count = 70;
        [self.navigationController pushViewController:editInfoCtr animated:YES];
    }
    
    if (indexPath.row == 4) {
        XTBatchSettingPicturesViewController *picCtr = [[XTBatchSettingPicturesViewController alloc] init];
        [picCtr setCompletionBlock:^(NSString *coverUrl) {
            self.albumInfo.cover = [NSURL URLWithString:coverUrl];
            [self.tableView reloadData];
        }];
        picCtr.albumId = self.albumInfo.id;
        [self.navigationController pushViewController:picCtr animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        if (self.type == XTAlbumChangeTypeEdit) {
            XTSetFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"XTSetFootView" owner:self options:nil] objectAtIndex:0];
            footView.delegate = self;
            [footView.logoutBtn setTitle:@"删除图册" forState:UIControlStateNormal];
            [footView.logoutBtn setTitle:@"删除图册" forState:UIControlStateHighlighted];
            _tableView.tableFooterView = footView;
        }
        
        [self.view addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(6, 6, 6, 6));
        }];
    }
    return _tableView;
}

- (void)clickAddTagBtn:(UIButton *)button{
    XTAddTagViewController *addTagViewCtr = [[XTAddTagViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAlbumTag:)
                                                 name:AddTagNotification
                                               object:nil];
    addTagViewCtr.oldTags = self.tags.mutableCopy;
    [self.navigationController pushViewController:addTagViewCtr animated:YES];
}

- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag{
    self.tags = view.tags.mutableCopy;
    if ([self.tags count] == 0) {
        self.albumTagCell.placeholderLabel.hidden = NO;
    }
}

- (void)clickDeleteBtn:(UIButton *)button{
    [YYTAlertView showFullTypeAlertViewWithTitle:@"温馨提示" message:@"您确认要删除此图册吗？" completaionBlock:^(NSInteger index) {
        if (index == 1){
            [self deleteAlbumRequest];
        }
    }];
}

- (void)deleteAlbumRequest{
    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
        [YYTHUD showPromptAddedTo:self.view
                         withText:@"网络未连接"
              withCompletionBlock:nil];
        return;
    }
    XTSubStore *subStore = [[XTSubStore alloc] init];
    [subStore deleteAlbumWithAlbumID:self.albumInfo.id
                           isDelPics:YES
                     completionBlock:^(id results, NSError *error) {
                         if (!error) {
                             [YYTHUD showPromptAddedTo:self.view
                                              withText:@"图册删除成功"
                                   withCompletionBlock:nil];
                             [self.navigationController popToRootViewControllerAnimated:YES];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumDetailNotification" object:nil];
                         }else{
                             [YYTAlertView showHalfTypeAlertViewWithTitle:@"提醒" message:[error xtErrorMessage] completaionBlock:nil];
                         }
                     }];
}

//给相册添加标签
- (void)addAlbumTag:(NSNotification *)notification{
    NSMutableArray *tags = [notification object];
    self.tags = tags.copy;
    [self.albumTagCell.tagView removeAllTags];
    [self.albumTagCell.tagView addTags:tags];
    self.albumTagCell.placeholderLabel.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddTagNotification object:nil];
}

//更新相册描述
- (void)updateAlbumDes:(NSNotification *)notification{
    NSDictionary *albumDic = [notification object];
    if (albumDic[@"albumName"]) {
        self.albumNameCell.contentLabel.text = [albumDic objectForKey:@"albumName"];
    }else if (albumDic[@"albumDes"]){
        self.albumDesCell.contentLabel.text = [albumDic objectForKey:@"albumDes"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EditUserInfoNotification object:nil];
}
@end
