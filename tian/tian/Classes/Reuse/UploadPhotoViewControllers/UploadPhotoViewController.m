//
//  UploadPhotoViewController.m
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import "XTUploadImageManage.h"
#import "YYTBarButtonItem.h"
#import "XTTabBarController.h"
#import "PhotoListTableViewCell.h"
#import "AddTagTableViewCell.h"
#import "XTAddTagViewController.h"
#import "XTUploadAlbumListViewController.h"
#import "XTLocalPhotoModel.h"
#import "XTLocalImageStoreManage.h"
#import "XTGuideManage.h"
#import "XTEditDesTableViewCell.h"
@interface UploadPhotoViewController ()<UITableViewDataSource,UITableViewDelegate, PhotoListCellDelegate, AddTagCellDelegate>
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, assign) NSInteger rowCount;
@property (nonatomic, weak) UIImageView *guideImageView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
//原数据
@property (nonatomic, strong) NSArray *tags;
@end

@implementation UploadPhotoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.parameterDic = [NSMutableDictionary dictionaryWithCapacity:2];
        self.localPhotoArray = [XTLocalPhotoModel localPhotoModelWithList];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"上传照片";
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(uploadImageWithAblum)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    
    self.rowCount = 3;
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 判断是否需要引导
    if ([XTGuideManage checkPhotoUploadNeeded]) {
        //下次正常运行
        [XTGuideManage setPhotoUploadNeeded];
        //展示引导
        [self.guideImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}

- (void)uploadImageWithAblum{
    NSLog(@"上传图片到指定相册");
    PhotoListTableViewCell *cell = (PhotoListTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (self.type == XTUploadPhotoTypeSureAlbum){
        [self.parameterDic setObject:[NSNumber numberWithLong:self.albumInfo.id] forKey:@"albumId"];
    }
    [self.parameterDic setObject:cell.photoDesTextView.text forKey:@"text"];
    XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
    uploadManage.albumParameterDic = [NSMutableDictionary dictionaryWithDictionary:self.parameterDic];
    uploadManage.type = XTUploadImageTypeAlbum;
    [uploadManage uploadImages:self.localPhotoArray];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isShowTabBar",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showUserHomePageNotification" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetsGroupCell = @"PhotoListTableViewCell";
    
    if (indexPath.row == self.rowCount - 2) {
        AddTagTableViewCell *cell = [[AddTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.placeholderLabel.text = @"给图片帖标签可上头条哦！";
        cell.titleLabel.text = @"";
        cell.delegate = self;
        return cell;
        
    }else if(indexPath.row == self.rowCount - 1){
        XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = @"图册：";
        if (self.type == XTUploadPhotoTypeSureAlbum) {
            cell.contentLabel.text = self.albumInfo.title;
            cell.arrowImageView.hidden = YES;
        }else{
            cell.contentLabel.text = @"点击创建图册";
        }
        
        [cell.buttomLineView updateConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(cell.contentView);
            make.height.equalTo(@0.5);
        }];
        return cell;
        
    }else{
        PhotoListTableViewCell *cell = (PhotoListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AssetsGroupCell];
        if (cell == nil) {
            cell = [[PhotoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AssetsGroupCell];
        }
        if ([self.localPhotoArray count] > 0) {
            cell.model = [self.localPhotoArray objectAtIndex:0];
            [cell setPhotoCount:[NSString stringWithFormat:@"%ld",[self.localPhotoArray count]]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && self.type == XTUploadPhotoTypeDefault) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateSelectedAlbum:)
                                                     name:UpdateSelectedNotification
                                                   object:nil];
        XTUploadAlbumListViewController *albumListController = [[XTUploadAlbumListViewController alloc] init];
        albumListController.title = @"上传到图册";
        [self.navigationController pushViewController:albumListController animated:YES];
    }
}

- (void)showAssetsGroupView
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.rowCount = [self.assetsArray count]+2;
                     }completion:^(BOOL finished) {
                         [self.tableView reloadData];
                     }];
}

- (void)hideAssetsGroupView
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.rowCount = 3;
                     }completion:^(BOOL finished) {
                         [self.tableView reloadData];
                     }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.rowCount-2) {
        return 57.0;
    }else if(indexPath.row == self.rowCount-1){
        return 52.0;
    }else{
        return 83.0;
    }
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
        [self.view addSubview:_tableView];
        [_tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 6, 0, 6));
        }];
    }
    return _tableView;
}

- (void)clickAddTagBtn:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUploadImageTag:)
                                                 name:AddTagNotification
                                               object:nil];
    XTAddTagViewController *addTagViewCtr = [[XTAddTagViewController alloc] init];
    addTagViewCtr.oldTags = self.tags.mutableCopy;
    [self.navigationController pushViewController:addTagViewCtr animated:YES];
}

- (void)updateSelectedAlbum:(NSNotification *)notification{
    XTEditDesTableViewCell *cell = (XTEditDesTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if ([notification object]) {
        NSDictionary *dic = [notification object];
        [self.parameterDic setObject:[dic objectForKey:@"albumID"] forKey:@"albumId"];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"albumTitle"]];
    }else{
        [self.parameterDic removeObjectForKey:@"albumId"];
        cell.contentLabel.text = @"无（暂时不建图册）";
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UpdateSelectedNotification object:nil];
}

- (void)updateUploadImageTag:(NSNotification *)notification{
    NSMutableArray *tags = [notification object];
    self.tags = tags.copy;
    NSLog(@"%@",self.tags);
    [self changeDictionaryTags:tags];
    
    AddTagTableViewCell *cell = (AddTagTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.placeholderLabel.hidden = YES;
    [cell.tagView removeAllTags];
    [cell.tagView addTags:tags];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddTagNotification object:nil];
}
///当点击tag删除
- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag{
    self.tags = view.tags.mutableCopy;
    [self changeDictionaryTags:self.tags];
    if ([self.tags count] == 0) {
        AddTagTableViewCell *cell = (AddTagTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.placeholderLabel.hidden = NO;
    }
}
///根据数组改变改变字符串数据
-(void)changeDictionaryTags:(NSArray *)tags{
    if ([tags count] > 0){
        NSMutableString *tagStr = [[NSMutableString alloc] initWithCapacity:0];
        for (NSString *tag in tags) {
            [tagStr appendString:[NSString stringWithFormat:@"%@,",tag]];
        }
        [tagStr deleteCharactersInRange:NSMakeRange(tagStr.length-1, 1)];
        [self.parameterDic setObject:tagStr forKey:@"tags"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
    [self.guideImageView removeFromSuperview];
}
-(UIImageView *)guideImageView{
    if (_guideImageView == nil) {
        NSString *guideName;
        if ([UIScreen mainScreen].scale == 2) {
            guideName = @"GuideShowAdd";
        }else{
            guideName = @"GuideShowAdd6P";
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:guideName]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:self.tap];
        [self.navigationController.view addSubview:imageView];
        _guideImageView = imageView;
    }
    return _guideImageView;
}
-(UITapGestureRecognizer *)tap{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    }
    return _tap;
}
@end
