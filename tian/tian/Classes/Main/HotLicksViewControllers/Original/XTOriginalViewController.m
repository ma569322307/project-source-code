//
//  XTOriginalViewController.m
//  tian
//
//  Created by yyt on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTOriginalViewController.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTAlbumDetailCollectionViewCell.h"
#import "XTUserFilesCollectionViewCell.h"
#import "XTAlbumListCollectionViewCell.h"
#import "XTUserTopicCollectViewCell.h"
#import "XTUserHonourCollectViewCell.h"
#import "XTDedicateListCollectViewCell.h"
#import "XTHotLicksRecsInfo.h"
#import "XTHomePageStore.h"
#import "YYTAlertView.h"
#import "YYTActionSheet.h"
#import "XTBatchSettingPicturesViewController.h"
#import "XTHotLicksRecsInfo.h"
#import "XTNewAlbumViewController.h"
#import "XTImageInfo.h"
#import "XTUserStore.h"
#import "XTUserInfo.h"
#import "XTSubStore.h"
#import "JKImagePickerController.h"
#import "AddPhotoViewController.h"
#import "XTPhotoHeadModel.h"
#import "XTImgDetailViewController.h"
#import "XTUserHomePageViewController.h"
#import "XTShareManager.h"

static NSString *kAlbumDetailCellIdentifier = @"kAlbumDetailCellIdentifier";
static NSString *kAlbumListCellIdentifier = @"kAlbumListCellIdentifier";
static NSString *kUserFilesCellIdentifier = @"kUserFilesCellIdentifier";
static NSString *kUserTopicCellIdentifier = @"kUserTopicCellIdentifier";
static NSString *kUserHonourCellIdentifier = @"kUserHonourCellIdentifier";
static NSString *kDedicateListCellIdentifier = @"kDedicateListCellIdentifier";
#define K_CREATEURL @"operate/show/sole.json"//上面头的接口
#define K_CREATEURLWITHORIGINAL @"picture/list/user.json"//下面UICollectionView的接口
#define K_COLLECTIONHEAHER @"picture/album/show.json"
@interface XTOriginalViewController ()<XTWaterFallViewControlDelegate,JKImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favouritedImageView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
@property (strong, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UIImageView *vuserImageView;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) BOOL open;
@property (nonatomic, strong) NSArray *picArray;
@property (nonatomic, strong) XTWaterFallControl *waterFallControl;
@property (nonatomic, assign) NSInteger pid;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger maxId;

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareMvDesc;
@property (nonatomic, copy) NSString *pushId;
@property (nonatomic, assign) NSInteger photosId;
- (IBAction)addViewButton:(id)sender;
@end

@implementation XTOriginalViewController
-(void)createWithView{
    
    self.HeadImageView.layer.masksToBounds = YES;
    self.HeadImageView.layer.cornerRadius = 29.f;
    [self addButtonWithNavigationBar];
    RAMCollectionViewFlemishBondLayout *layout = [[RAMCollectionViewFlemishBondLayout alloc]init];
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height-64) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collection];
    self.backGroundView.frame = CGRectMake(5., 0., SCREEN_SIZE.width-10, 72);
    self.waterFallControl = [[XTWaterFallControl alloc]initWithCollectionView:collection headerView:self.backGroundView refreshType:XTWaterFallRefreshType_footer | XTWaterFallRefreshType_none cellType:XTWaterFallViewCellType_imageAndDescription];
    self.waterFallControl.delegate = self;
    self.waterFallControl.dataArray = nil;
    [self.waterFallControl reloadCollectionViewData];
    [self.waterFallControl waterViewTriggerRefresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterTime) name:@"updateAlbumHeadNotification" object:nil];
    self.navigationController.navigationBar.translucent = NO;
    [self setLabelAtr];
    [self createWithView];
    [self GestureRecognizer];
    [self.view addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(@10);
        make.left.equalTo(self.view).with.offset(@10);
        make.right.equalTo(self.view).with.offset(@-10);
        make.bottom.equalTo(self.view).offset(@0);
    }];
    if (self.type ==XTPageTypeOther) {
        [self requestWithCollectionHead];
    }else{
        [self XTPageTypeOriginalHead];
    }
}
//添加手势
-(void)GestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushViewController)];
    [self.HeadImageView addGestureRecognizer:tap];
}
-(void)pushViewController{
    XTUserHomePageViewController *homePageVC = [[XTUserHomePageViewController alloc]init];
    homePageVC.type = XTUserHomePageTypeHis;
    if (self.type == XTPageTypeOriginal) {
            if ([self.pushId isEqualToString:[XTUserStore sharedManager].user.userID] ) {
            }else{
                homePageVC.userID = self.pushId;
                [self.navigationController pushViewController:homePageVC animated:YES];
            }
    }else{
        if (self.pid != [[XTUserStore sharedManager].user.userID integerValue]) {
            homePageVC.userID = [NSString stringWithFormat:@"%@",@(self.pid)];
            [self.navigationController pushViewController:homePageVC animated:YES];
        }
    }
}
-(void)loadWaterFallDataWithLoadMore:(BOOL)isloaddMore{
    //        瀑布流
    NSInteger temp = self.type == XTPageTypeOther?self.pictureId:self.photosId;
    NSInteger macId = isloaddMore == YES?self.maxId:0;
    XTSubStore *store = [[XTSubStore alloc]init];
        [store fetchAlbumPictureListWithAlbumID:temp maxID:macId sinceID:0 completionBlock:^(id albumDetail, NSError *error) {
            NSError *err = nil;
            NSArray *dataArray = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:albumDetail error:&err];
            XTImageInfo *lastModel = [dataArray lastObject];
            if (self.type == XTPageTypeOriginal) {
                XTImageInfo *firstModel = [dataArray firstObject];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:firstModel.url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    self.shareImage = image;
                }];
            }
            self.maxId = lastModel.id;
            if (dataArray.count<20) {
                [self.waterFallControl hidenTheFooterView:YES];
            }
            [self.waterFallControl stopWaterViewAnimating];
            if (isloaddMore) {
                [self.waterFallControl.dataArray addObjectsFromArray:[dataArray mutableCopy]];
            }else{
                self.waterFallControl.dataArray = [NSMutableArray arrayWithArray:dataArray];
            }
            [self.waterFallControl reloadCollectionViewData];
            [YYTHUD hideLoadingFrom:self.view];
        }];
}
- (void)refreshDataAfterTime
{
    [self performSelector:@selector(requestWithCollectionHead) withObject:nil afterDelay:2.0f];
}
//相册头部分
-(void)requestWithCollectionHead{
    [YYTHUD showLoadingAddedTo:self.view];
    [self addViewButton:self.lookButton];
    XTSubStore *subStore = [[XTSubStore alloc] init];
    __weak XTOriginalViewController *weakSelf = self;
    [subStore fetchAlbumDetailWithAlbumID:self.pictureId
                          completionBlock:^(id albumDetail, NSError *error) {
                              
                              if([albumDetail isKindOfClass:[NSNull class]]) {
                                  return ;
                              }
                              
                              XTAlbumInfo *albumInfo = [MTLJSONAdapter modelOfClass:[XTAlbumInfo class] fromJSONDictionary:albumDetail error:&error];
                              self.albumInfo = albumInfo;
                              XTUserInfo *infoModel = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:[albumDetail objectForKey:@"user"] error:&error];
                              XTPhotoHeadModel *headModel = [[XTPhotoHeadModel alloc]init];
                              [headModel setValuesForKeysWithDictionary:albumDetail];
                              weakSelf.title = headModel.title;
                              headModel.descrip = [albumDetail objectForKey:@"description"];
                              [weakSelf.HeadImageView an_setImageWithURL:infoModel.bigAvatar placeholderImage:nil];
                              weakSelf.pid = infoModel.uid;
                              self.photosId = headModel.id;
                              if ([[XTUserStore sharedManager].user.userID integerValue] == self.pid) {
                                  [weakSelf addButtonWithNavigationBar];
                              }
                              if (infoModel.vuser == 1) {
                                  weakSelf.vuserImageView.image = [UIImage imageNamed:@"HomePage_V"];
                              }else{
                                  weakSelf.vuserImageView.image = nil;
                              }
                              weakSelf.authorLable.text = [NSString stringWithFormat:@"%@",infoModel.nickName];
                              weakSelf.viewCountLabel.text = [NSString stringWithFormat:@"(%@)",@(headModel.picNum)];
                              weakSelf.likeLable.text = [NSString stringWithFormat:@"%@",@(headModel.commendCount)];
                              weakSelf.commentLable.text = [NSString stringWithFormat:@"%@",@(headModel.viewCount)];
                              weakSelf.contentLable.text = headModel.descrip;
                              [self addViewButton:self.lookButton];
                              UIFont *font = [UIFont systemFontOfSize:12];
                              weakSelf.contentLable.font = font;
                              CGSize size = [self.contentLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
                              self.lookButton.hidden = size.width<self.contentLable.frame.size.width?YES:NO;
                              if (size.width>self.contentLable.frame.size.width) {
                                  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addViewButton:)];
                                  [self.contentLable addGestureRecognizer:tapGesture];
                              }
                              [self loadWaterFallDataWithLoadMore:NO];
                          }];
}
//独家原创头部分
-(void)XTPageTypeOriginalHead{
    [YYTHUD showLoadingAddedTo:self.view];
    XTHomePageStore *homeStore = [[XTHomePageStore alloc]init];
    [homeStore fetchHomePageOriginalId:self.originalId andOffSet:0 andSize:24 CompletionBlock:^(id picList, NSError *error) {
        NSError *err = nil;
        NSMutableArray *piclistArray = [NSMutableArray arrayWithArray:picList];
        if (piclistArray) {
            XTPhotoHeadModel *headModel = [MTLJSONAdapter modelOfClass:[XTPhotoHeadModel class] fromJSONDictionary:[piclistArray objectAtIndex:0] error:&err];
            XTUserInfo *infoModel = [MTLJSONAdapter modelOfClass:[XTUserInfo class] fromJSONDictionary:[[piclistArray objectAtIndex:0] objectForKey:@"user"] error:&err];
            self.pushId = [NSString stringWithFormat:@"%ld",infoModel.uid];
            CLog(@"%@",[XTUserStore sharedManager].user.userID);
            XTHotLicksRecsInfo *hotLicksModel = [MTLJSONAdapter modelOfClass:[XTHotLicksRecsInfo class] fromJSONDictionary:[piclistArray objectAtIndex:1] error:&err];
            self.vuserImageView.image = infoModel.vuser == 1?[UIImage imageNamed:@"HomePage_V"]:nil;
            self.photosId = headModel.id;
            [self.HeadImageView an_setImageWithURL:infoModel.bigAvatar placeholderImage:nil];
            self.authorLable.text = [NSString stringWithFormat:@"%@",infoModel.nickName];
            self.viewCountLabel.text = [NSString stringWithFormat:@"%@",@(headModel.picNum)];
            self.likeLable.text = [NSString stringWithFormat:@"%@",@(headModel.commendCount)];
            self.contentLable.text = [NSString stringWithFormat:@"%@",headModel.descrip];
            self.shareMvDesc = headModel.descrip;
            UIFont *font = [UIFont systemFontOfSize:12];
            self.contentLable.font = font;
            CGSize size = [self.contentLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
            self.lookButton.hidden = size.width<self.contentLable.frame.size.width?YES:NO;
            if (self.lookButton.hidden == NO) {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addViewButton:)];
                [self.contentLable addGestureRecognizer:tapGesture];
            }
            self.commentLable.text = [NSString stringWithFormat:@"%@",@(headModel.viewCount)];
            self.contentLable.text = headModel.descrip;
            self.title = hotLicksModel.title;
            self.shareTitle = hotLicksModel.title;
            [self loadWaterFallDataWithLoadMore:NO];
        }
    }];
}
#pragma mark - waterFallDelegate
//下拉
- (void)pullToRefresh
{
    [self loadWaterFallDataWithLoadMore:NO];
}
//上提
- (void)infiniteScrolling;

{
    [self loadWaterFallDataWithLoadMore:YES];
}
- (void)clickCellIndexRow:(NSInteger)clickRow
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SeriesContent" bundle:nil];
    XTImgDetailViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"XTImgDetailViewController"];
    controller.pidArr = [self getAllIdArray];
    if (self.type == XTPageTypeOther) {
        
        
        if (self.pid ==[[XTUserStore sharedManager].user.userID integerValue]) {
            controller.fromType = XTImgDetailViewControllerTypeMine;
            controller.albumInfo = self.albumInfo;
            
        }else{
            controller.fromType = XTImgDetailViewControllerTypeDefault;
        }
    }
    
    controller.curIndex = clickRow;
    
    XTImageInfo *imageInfo = [self.waterFallControl.dataArray objectAtIndex:clickRow];
    controller.placeholderImageURL = imageInfo.url;
    self.needTranform = YES;
    [self tranformPushWithCollectionView:self.waterFallControl.collectionView imageSize:CGSizeMake(imageInfo.width, imageInfo.height) currentIndex:clickRow];
    [self.navigationController pushViewController:controller animated:YES];
}
- (NSMutableArray *)getAllIdArray
{
    NSMutableArray *mArray = [NSMutableArray array];
    for (XTImageInfo *imgInfo in self.waterFallControl.dataArray) {
        [mArray addObject:[NSString stringWithFormat:@"%@",@(imgInfo.id)]];
    }
    return mArray;
}

-(void)setLabelAtr{
    self.contentLable.preferredMaxLayoutWidth = 180;
    self.contentLable.userInteractionEnabled = YES;
    self.contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
}

-(void)addButtonWithNavigationBar{
    UIButton *button;
    if (self.type == 0) {
        SETIMAGEBTN(button, @"share_brown", @"share_brown");
    }else{
        if (self.pid ==[[XTUserStore sharedManager].user.userID integerValue]) {
            SETIMAGEBTN(button, @"set_brown", @"set_brown_sel");
        }else{
            SETIMAGEBTN(button,@"", @"" );
            button.userInteractionEnabled = NO;
        }
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 35, 35);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.title = self.albumInfo.title;
    
}
-(void)buttonClicked:(id)sender{
    if (self.type == 0) {
        //        独家原创分享
        [[XTShareManager sharedManager] shareWithTitle:self.shareTitle withMvDesc:self.shareMvDesc withImage:self.shareImage withShareModeType:XTShareModeTypePicShare withPid:self.originalId withShareSheetType:XTShareSheetItemNone withCompletionBlock:nil];
    }else{
        [YYTActionSheet showWithTitleArray:@[@"上传图片",@"编辑图册",@"批量操作图片"] withCompletionBlock:^(NSInteger index) {
            if (index == 1) {
                //上传图片
                if ([UIViewController tabBarController].isImageUploadComplete) {
                    [self composePicAdd];
                }else{
                    [YYTHUD showPromptAddedTo:self.view withText:@"当前有正在上传的图片" withCompletionBlock:nil];
                }
            }
            if (index == 2) {
                XTNewAlbumViewController *newAlbum = [[XTNewAlbumViewController alloc] init];
                newAlbum.type = XTAlbumChangeTypeEdit;
                newAlbum.albumInfo = self.albumInfo;
                
                [self.navigationController pushViewController:newAlbum animated:YES];
            }
            if (index == 3) {
                XTBatchSettingPicturesViewController *vc = [[XTBatchSettingPicturesViewController alloc] init];
                vc.albumId = self.albumInfo.id;
                vc.settingType = XTBatchSettingPictures;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
}
- (void)composePicAdd
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.type = XTUploadPhotoTypeSureAlbum;
    imagePickerController.albumInfo = self.albumInfo;
    imagePickerController.needPush = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source{
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addViewButton:(id)sender {
    sender = (UIButton *)[self.view viewWithTag:100];
    self.backGroundView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLable.translatesAutoresizingMaskIntoConstraints = NO;
    self.open = !self.open;
    if (self.open) {
        self.contentLable.numberOfLines = 0;
        [self.contentLable layoutIfNeeded];
        [sender setImage:[UIImage imageNamed:@"HotClicks_button"] forState:UIControlStateNormal];
    }else{
        self.contentLable.numberOfLines = 1;
        [self.contentLable layoutIfNeeded];
        [sender setImage:[UIImage imageNamed:@"HotClicks_button_sel"] forState:UIControlStateNormal];
    }
    CGRect headerFrame = self.backGroundView.frame;
    headerFrame.size.height = MAX(CGRectGetMaxY(self.HeadImageView.frame)+3, CGRectGetMaxY(self.contentLable.frame)+3);
    self.backGroundView.frame = headerFrame;
    
    [self.backGroundView updateConstraints];
    [self.waterFallControl reloadCollectionViewData];
}
@end
