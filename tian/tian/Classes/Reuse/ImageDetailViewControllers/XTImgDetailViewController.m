//
//  XTImgSetViewController.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgDetailViewController.h"
#import "XTSeriesContentStore.h"
#import "Define.h"
#import "XTPicDetailCell.h"
#import "XTImgShowModel.h"
#import "XTCommentsModel.h"
#import "XTImgDetailLogic.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTImgDetailView.h"
#import "XTBigImageViewController.h"
#import "XTBigImgPresentAnimation.h"
#import "XTBigImgDismissAnimation.h"
#import "XTInputView.h"
#import "XTCommentItemModel.h"
#import "XTUserInfo.h"
#import "XTImgDetailRightItemsView.h"
#import "XTImgDetailTitleView.h"
#import "XTCommendsView.h"
#import "XTAlbumsOfPicView.h"
#import "XTUserHomePageViewController.h"
#import "XTOriginalViewController.h"
#import "XTAlbumModel.h"
#import "YYTHUD.h"
#import "XTShareManager.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "XTUploadAlbumListViewController.h"
#import "YYTAlertView.h"
#import "XTTagsView.h"
#import "XTTagInfo.h"
#import "XTPhotosListViewController.h"
#import "XTCommentsCell.h"
#import "XHTransitionProtocol.h"
#import "UICollectionView+XHIndexPath.h"
#import "XTAlbumInfo.h"
#import "NSString+TextSize.h"
@interface XTImgDetailViewController ()<XHTransitionProtocol, XHHorizontalPageViewControllerProtocol, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XTImgDetailViewDelegate,UIViewControllerTransitioningDelegate,XTBigImageViewControllerDelegate,XTPicDetailCellDelegate,XTInputViewDelegate,UIScrollViewDelegate,XTImgDetailRightItemViewDelegate,XTCommendsViewDelegate,XTAlbumsOfPicViewDelegate,XTTagsViewDelegate,XTCommentsCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)XTImgShowModel *imgShowModel;

//@property(nonatomic,strong)NSArray *dataSource;

@property (nonatomic, assign) CGPoint pullOffset;

@property(nonatomic,strong)XTCommentsModel *commentsModel;

@property(nonatomic,strong)XTImgDetailLogic *detailLogic;

@property(nonatomic,strong)XTBigImgPresentAnimation *bigImgPresentAnimation;

@property(nonatomic,strong)XTBigImgDismissAnimation *bigImgDismissAnimation;

@property(nonatomic,strong)XTInputView *inputView;

@property(nonatomic,strong)NSLayoutConstraint *bottomConstraint;

@property(nonatomic,strong)XTImgDetailRightItemsView *rightView;

@property(nonatomic)BOOL isEdit;
@end

@implementation XTImgDetailViewController

static NSString *cellID = @"XTPicDetailCell";

-(void)awakeFromNib{
    NSLog(@"awakeFromNib");
    self.fromType = XTImgDetailViewControllerTypeDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.pidArr = @[@"123853388"];
    
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGesture:)];
//    [self.view addGestureRecognizer:viewTap];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightView];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    //self.navigationItem.titleView = self.titleView;
    
    [self addKeyBoardNotification];
    
    self.pullOffset = CGPointZero;
//    self.extendedLayoutIncludesOpaqueBars = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XTPicDetailCell" bundle:nil] forCellWithReuseIdentifier:cellID];

    self.inputView.hidden = YES;
    [self.view addSubview:self.inputView];
    
    [self.view addConstraint:self.bottomConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:53];
    
    self.inputView.heightConstraint = heightConstraint;
    
    self.collectionView.contentSize = CGSizeMake(self.pidArr.count * SCREEN_SIZE.width, SCREEN_SIZE.height - 64 - 53);
    
    self.collectionView.contentOffset = CGPointMake(self.curIndex * SCREEN_SIZE.width, 0);
    
    [self.collectionView setCurrentIndexPath:[NSIndexPath indexPathForItem:self.curIndex inSection:0]];
    
}

//-(void)viewTapGesture:(UITapGestureRecognizer *)tap{
//    
//    [self.inputView xt_resignFirstResponder];
//}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.commentInfo = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.inputView.hidden = NO;
    
    if (self.commentInfo) {
        [self.inputView xt_becomeFirstResponder];
    }
}

-(void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

-(XTImgDetailRightItemsView *)rightView{
    if (!_rightView) {
        NSArray *nib_r = [[NSBundle mainBundle] loadNibNamed:@"XTImgDetailRightItemsView" owner:self options:nil];
        _rightView = nib_r[0];
        _rightView.delegate = self;
    }
    return _rightView;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.size.height;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.bottomConstraint.constant = -keyBoardEndY;
        [self.inputView layoutIfNeeded];
        
    }];
}

-(void)keyboardWillDismiss:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.bottomConstraint.constant = 0;
        [self.inputView layoutIfNeeded];
        
    }];
}

-(XTBigImgPresentAnimation *)bigImgPresentAnimation{
    if (!_bigImgPresentAnimation) {
        _bigImgPresentAnimation = [XTBigImgPresentAnimation new];
    }
    return _bigImgPresentAnimation;
}

-(XTBigImgDismissAnimation *)bigImgDismissAnimation{
    if (!_bigImgDismissAnimation) {
        _bigImgDismissAnimation = [XTBigImgDismissAnimation new];
    }
    return _bigImgDismissAnimation;
}

-(XTImgDetailLogic *)detailLogic{
    if (!_detailLogic) {
        _detailLogic = [[XTImgDetailLogic alloc] initWithPidArr:self.pidArr];
    }
    return _detailLogic;
}


-(NSLayoutConstraint *)bottomConstraint{
    
    if (!_bottomConstraint) {
        
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }
    return _bottomConstraint;
}

-(XTInputView *)inputView{
    if (!_inputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTInputView" owner:self options:nil];
        
        _inputView = nib[0];
        _inputView.delegate = self;
        _inputView.placeholderText = @"说点什么吧";
        _inputView.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
    return _inputView;
}


-(void)setPidArr:(NSArray *)aPidArr{
    _pidArr = aPidArr;
}


-(void)setCommentInfo:(NSDictionary *)aCommentInfo{
    _commentInfo = aCommentInfo;
    if (!_commentInfo) {
        return;
    }
    //[self.inputView xt_becomeFirstResponder];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_commentInfo[@"cid"] forKeyedSubscript:@"cid"];
    [dic setObject:[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]] forKeyedSubscript:@"pid"];
    XTUserInfo *userInfo = _commentInfo[@"userInfo"];
    self.inputView.placeholderText = [NSString stringWithFormat:@"回复:%@",userInfo.nickName];
    self.inputView.postCommentsInfo = dic;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pidArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XTPicDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    cell.pullDownAction = ^(CGPoint offset) {
        weakSelf.pullOffset = offset;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [cell setNeedsDisplay];
    
    cell.placeholderImageURL = self.placeholderImageURL;
    
    @weakify(self);
    [self.detailLogic fatchLogicModelWith:indexPath.row fatchSuccess1:^(id obj1) {
        
        @strongify(self);
        self.imgShowModel = obj1;
        
        //cell.model = self.imgShowModel;
        
        [cell configureDataWithModel:self.imgShowModel];
        self.placeholderImageURL = nil;
        self.rightView.favorited = self.imgShowModel.favorited;
        
    } fatchSuccess2:^(id obj2) {
        XTCommentsModel *model = obj2;
        cell.dataSource = model.comments;
    } andFailure:^(NSError *error) {
        //@strongify(self);
        self.collectionView.hidden = YES;
        
        if (error.code == 30126 || self.fromType == XTImgDetailViewControllerTypeMine) {
            
            [YYTHUD showPromptAddedTo:self.view withText:error.userInfo[NSLocalizedDescriptionKey] withCompletionBlock:^{
                
                [[[XTSubStore alloc] init] deleteAlbumPicturesWithAlbumID:self.albumInfo.id pids:[NSSet setWithObject:self.pidArr[self.curIndex]] completionBlock:^(id results, NSError *error) {
                    @strongify(self);
                    if (error != nil) {
                        //NSLog(@"%@",error);
                        return;
                    }
                    self.isEdit = YES;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
            
            
        }else{
            YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
                self.collectionView.hidden = NO;
                [YYTBlankView hideFromView:self.view];
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            
            blankView.error = error;
        }
        //@weakify(self);
    }];
    cell.delegate = self;
    
    cell.index = indexPath.row;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_SIZE.width, SCREEN_SIZE.height - 53 - 64);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.curIndex = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
}

-(void)tapImgActionWith:(NSInteger )index andRect:(NSValue *)rect andImage:(UIImage *)image{
    if ([self.inputView xt_isFirstResponder]) {
        [self.inputView xt_resignFirstResponder];
        return;
    }
    
    NSDictionary *info = @{@"index":[NSNumber numberWithInteger:index],@"rect":rect};
    
    self.bigImgPresentAnimation.animationInfo = info;
    
    self.bigImgDismissAnimation.animationInfo = info;
    
    XTBigImageViewController *controller = [[XTBigImageViewController alloc] initWithNibName:@"XTBigImageViewController" bundle:nil];
    controller.curIndex = index;
    controller.delegate = self;
    controller.pidArr = self.pidArr;
    controller.transitioningDelegate = self;
    controller.placeholderImage = image;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

#pragma -mark XTBigImageViewControllerDelegate
-(void) bigImageViewControllerDidClickedDismissButton:(XTBigImageViewController *)viewController{
    NSLog(@"viewController ==== %@",viewController);
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark XTInputViewDelegate
-(void)postBtnActionWith:(NSMutableDictionary *)info{
    
    NSString *text = info[@"text"];
    
    if ([text lengthOfBytesUsingChineseCheck] > 140) {
        [YYTHUD showPromptAddedTo:self.view withText:@"评论不能超过140个字符" withCompletionBlock:nil];
        return;
    }
    
    
    [self.inputView xt_resignFirstResponder];
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENTSPOST];
    NSLog(@"url ==== %@",url);

    if (!info[@"pid"]) {
        [info setObject:[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]] forKeyedSubscript:@"pid"];
    }
    
    if (!info[@"cid"]) {
        [info setObject:@0 forKeyedSubscript:@"cid"];
    }
    
    [XTSeriesContentStore commentsPostWithUrl:url andParameters:info successBlock:^(id responseObject) {
        
        if ([info[@"cid"] integerValue] == 0) {
            [YYTHUD showPromptAddedTo:self.view withText:@"评论成功" withCompletionBlock:nil];
        }else{
            [YYTHUD showPromptAddedTo:self.view withText:@"回复成功" withCompletionBlock:nil];
        }
        
        self.inputView.text = @"";
        [self.inputView xt_resignFirstResponder];
        self.inputView.postCommentsInfo = nil;
        [self.detailLogic insertCommentDataSourceWithPid:self.pidArr[self.curIndex] andModel:responseObject];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.curIndex inSection:0]]];
        
    } failureBlock:^(NSError *error) {
        [YYTHUD showPromptAddedTo:self.view withText:error.userInfo[NSLocalizedDescriptionKey] withCompletionBlock:nil];
    }];
    
    
}

//-(void)textDidChange:(CGFloat)height{
//    
//    self.heightConstraint.constant = height;
//}

-(void)scrollViewDidEndDeceleratingWith:(NSInteger)index{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
}

#pragma -mark XTPicDetailCellDelegate
-(void)tableViewDidSelectedWithCommentsInfo:(XTCommentItemModel *)info{
    if([self.inputView xt_isFirstResponder]) {
        [self.inputView xt_resignFirstResponder];
//        self.inputView.placeholderText = @"说点什么吧";
        
    }else{
        [self.inputView xt_becomeFirstResponder];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:info.itemID forKeyedSubscript:@"cid"];
        [dic setObject:[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]] forKeyedSubscript:@"pid"];
        
        self.inputView.placeholderText = [NSString stringWithFormat:@"回复:%@",info.user.nickName];
        self.inputView.postCommentsInfo = dic;
    }
}

-(void)imgLoadFinish:(UIImage *)image{
    NSLog(@"wancheng");
    self.rightView.downLoadEnabled = YES;
    self.rightView.image = image;

}

-(void)fatchNextPageFinsih:(NSArray *)arr{
    [self.detailLogic addNextPageCommnetDataSourceWithPid:self.pidArr[self.curIndex] andArray:arr];
}

-(void)imgDetailViewTapAction{
    [self.inputView xt_resignFirstResponder];
}


#pragma -makr XTImgDetailRightItemViewDelegate

-(void)downLoadAction:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)collectAction:(BOOL)selected{
    if (selected) {
        NSString *url = [XT_API stringByAppendingString:XT_PICFAVORITESDELETE];
        NSLog(@"favoritesUrl ==== %@",url);
        NSDictionary *dic = @{@"pid":[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]]};
        
        [XTSeriesContentStore picfavoritesDeleteWithUrl:url andParameters:dic successBlock:^{
            [YYTHUD showPromptAddedTo:self.view withText:@"取消收藏成功" withCompletionBlock:nil];
            self.isEdit = YES;
            

        } failureBlock:^(NSError *error) {
            
        }];
    }else{
        NSString *url = [XT_API stringByAppendingString:XT_PICFAVORITESADD];
        NSLog(@"favoritesUrl ==== %@",url);
        
        NSDictionary *dic = @{@"pid":[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]]};
        
        [XTSeriesContentStore picFavoritesAddWithUrl:url andParameters:dic successBlock:^{
            [YYTHUD showPromptAddedTo:self.view withText:@"收藏成功" withCompletionBlock:nil];
            self.isEdit = YES;
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

-(void)addAction{
    
    XTUploadAlbumListViewController *albumListController = [[XTUploadAlbumListViewController alloc] init];
    albumListController.title = @"添加到图册";
    albumListController.type = XTAlbumListTypeMove;
    [self.navigationController pushViewController:albumListController animated:YES];
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewAlbumID:) name:@"updateSelectedAlbumNotification" object:nil];
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        // 保存失败
        [YYTHUD showPromptAddedTo:self.view withText:@"下载失败" withCompletionBlock:nil];
        //[MBProgressHUD showError:@"保存失败"];
    }else{
        // 保存成功
        //[MBProgressHUD showSuccess:@"保存成功"];
        [YYTHUD showPromptAddedTo:self.view withText:@"下载成功" withCompletionBlock:nil];
        
    }
}


#pragma -mark XTCommendsViewDelegate

-(void)tapActionWith:(XTUserInfo*)userInfo{
    NSLog(@"uid ==== %@",userInfo);
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)commendActionWith:(XTCommendsView *)commendView{
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMEND];
    NSDictionary *dic = @{@"pid":[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]]};
    
    [XTSeriesContentStore pictureCommendWithUrl:url andParameters:dic successBlock:^{
        NSArray *arr = [commendView commendSuccess];
        
        [self.detailLogic modifyCommendUsersWithPid:self.pidArr[self.curIndex] andArray:arr];
        self.isEdit = YES;
    } failureBlock:^(NSError *error) {
        
    }];
    
}

-(void)cancelCommendActionWith:(XTCommendsView *)commendView{
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMMENDCANCEL];
    NSDictionary *dic = @{@"pid":[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]]};
    
    [XTSeriesContentStore pictureCommendCancelWithUrl:url andParameters:dic successBlock:^{
        [commendView cancelCommendSuccess];
        self.isEdit = YES;
    } failureBlock:^(NSError *error) {
        
    }];
}


#pragma -mark XTTagsViewDelegate

-(void)tagViewTapActionWith:(XTTagInfo *)tagInfo{
    if (tagInfo.tagType == XTTagArtist) {
        XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
        controller.userID = [NSString stringWithFormat:@"%ld",tagInfo.tagId];
        controller.type = XTUserHomePageTypeArtist;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (tagInfo.tagType == XTTagNormal){
        XTPhotosListViewController *controller = [[XTPhotosListViewController alloc] init];
        controller.titleString = tagInfo.tag;
        controller.type = XTphotosListLabelType;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma -mark XTAlbumsOfPicViewDelegate

-(void)tapAction:(XTAlbumModel *)model{
    
//    NSArray *controllers = self.navigationController.viewControllers;
//    
//    for (UIViewController *controller in controllers) {
//        if ([controller isKindOfClass:[XTOriginalViewController class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//            return;
//        }
//    }
    
    //NSLog(@"**********^^^^^^^^^^^&&&&&&&&&&&&^^^^^^^^^^^^^************");
    
    XTOriginalViewController *controller = [[XTOriginalViewController alloc] initWithNibName:@"XTOriginalViewController" bundle:nil];
    controller.pictureId = [model.itemID integerValue];
    controller.type = XTPageTypeOther;
    [self.navigationController pushViewController:controller animated:YES];
    
    
}

#pragma -mark XTCommentsCellDelegate

-(void)tapAvatarImgViewActionWith:(XTUserInfo *)userInfo{
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSDictionary *dic = sender;
//    
//    XTBigImageViewController *controller = segue.destinationViewController;
}

#pragma -mark XTImgDetailViewDelegate

-(void)avatarImgViewTapAction:(XTUserInfo *)userInfo{
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)shareBtnAction:(UIImage *)image andModel:(XTImgShowModel *)model{
    [self.inputView xt_resignFirstResponder];
    
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    if (self.fromType == XTImgDetailViewControllerTypeMine || (self.fromType == XTImgDetailViewControllerTypeDefault && [userAccountInfo.userID integerValue] == model.user.uid)) {
        [[XTShareManager sharedManager] shareWithTitle:nil withMvDesc:self.imgShowModel.text withImage:image withShareModeType:XTShareModeTypePicture withPid:[self.imgShowModel.itemID integerValue] withShareSheetType:XTShareSheetItemMove|XTShareSheetItemDelete withCompletionBlock:^(NSInteger index){
            NSLog(@"%zd",index);
            if (index == 1) {
                ///跳转界面选择图册
                XTUploadAlbumListViewController *albumListController = [[XTUploadAlbumListViewController alloc] init];
                albumListController.title = @"移动到图册";
                albumListController.type = XTAlbumListTypeMove;
                [self.navigationController pushViewController:albumListController animated:YES];
                //监听通知
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectNewAlbumID:) name:@"updateSelectedAlbumNotification" object:nil];
            }else if (index == 2){
                ///删除处理提示
                @weakify(self);
                [YYTAlertView showFullTypeAlertViewWithTitle:@"提示" message:@"是否删除选择的图片" completaionBlock:^(NSInteger index) {
                    @strongify(self);
                    if (index == 1) {
                        NSInteger albumID = self.albumInfo ? self.albumInfo.id : [self.imgShowModel.album.itemID integerValue];
                        [self deleteActionWithAlbulID:albumID];
                    }
                }];
            }
            
        }];
    }else{
        [[XTShareManager sharedManager] shareWithMvDesc:model.text withImage:image withShareModeType:XTShareModeTypePicture withPid:[model.itemID integerValue] withShareSheetType:XTShareSheetItemTips|XTShareSheetItemWarning withCompletionBlock:^(NSInteger index) {
            NSLog(@"%zd",index);
            if (index == 1) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [YYTAlertView showTipsAlertViewWithCompletaionBlock:^(NSInteger index, NSInteger number) {
                    NSLog(@"index === %zd number === %zd",index,number);
                    if (index == 1) {
                        //打赏
                        [self picAwardRequestWith:[NSNumber numberWithInteger:number]];
                    }
                    [self addKeyBoardNotification];
                }];
            }else if (index == 2){
                [self picComplaintRequest];
            }
        }];
    }
}

- (void)deleteActionWithAlbulID:(NSInteger)albumID{
    [YYTHUD showLoadingAddedTo:self.view];
    
    
    ///删除操作
    @weakify(self);
    [[[XTSubStore alloc] init] deleteAlbumPicturesWithAlbumID:albumID pids:[NSSet setWithObject:self.pidArr[self.curIndex]] completionBlock:^(id results, NSError *error) {
        @strongify(self);
        [YYTHUD hideLoadingFrom:self.view];
        if (error != nil) {
            NSLog(@"%@",error);
            [YYTHUD showPromptAddedTo:self.view withText:@"删除失败" withCompletionBlock:nil];
            return;
        }
        //@weakify(self);
        [YYTHUD showPromptAddedTo:self.view withText:@"删除成功" withCompletionBlock:^{
            //@strongify(self);
            self.isEdit = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    
}

- (void)selectNewAlbumID:(NSNotification *)note{
    NSNumber *newAlbumID = note.object[@"albumID"];
    [self movingAction:newAlbumID.integerValue];
}

-(void)addNewAlbumID:(NSNotification *)note{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSelectedAlbumNotification" object:nil];
    
    NSNumber *newAlbumID = note.object[@"albumID"];
    
    NSNumber *picId = [NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]];
    
    NSString *url = [XT_API stringByAppendingString:XT_PICADD];
    
    NSDictionary *dic = @{@"pid":picId,@"albumId":newAlbumID};
    
    
    [XTSeriesContentStore pictureAddWithUrl:url andParameters:dic successBlock:^{
        [YYTHUD showPromptAddedTo:self.view withText:@"已收录图册" withCompletionBlock:nil];
        return;
    } failureBlock:^(NSError *error) {
        [YYTHUD showPromptAddedTo:self.view withText:error.userInfo[NSLocalizedDescriptionKey] withCompletionBlock:nil];
    }];
}


- (void)movingAction:(NSInteger)newAlbumID{
    //销毁监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateSelectedAlbumNotification" object:nil];
    ///移动处理
    [YYTHUD showLoadingAddedTo:self.view];
    ///移动操作
    @weakify(self);
    NSSet *set = [NSSet setWithObject:self.pidArr[self.curIndex]];
    [[[XTSubStore alloc] init] movePicturesFromAlbumID:[self.imgShowModel.album.itemID integerValue]  toAlbumID:newAlbumID pids:set completionBlock:^(id results, NSError *error) {
        @strongify(self);
        [YYTHUD hideLoadingFrom:self.view];
        if (error != nil) {
            NSLog(@"%@",error);
            [YYTHUD showPromptAddedTo:self.view withText:@"移动失败" withCompletionBlock:nil];
            return;
        }
        @weakify(self);
        
        [YYTHUD showPromptAddedTo:self.view withText:@"移动成功" withCompletionBlock:^{
//            @strongify(self);
            
        }];
        
    }];
}

//打赏请求
-(void)picAwardRequestWith:(NSNumber *)award{
    if ([award integerValue] > 3000) {
        [YYTHUD showPromptAddedTo:self.view withText:@"最多打赏3000!" withCompletionBlock:nil];
        return;
    }else if ([award integerValue] == 0){
        [YYTHUD showPromptAddedTo:self.view withText:@"打赏积分不能为空!" withCompletionBlock:nil];
        return;
    }
    
    NSString *url = [XT_API stringByAppendingString:XT_PICAWARD];
    NSDictionary *dic = @{@"pid":[NSNumber numberWithInteger:[self.pidArr[self.curIndex] integerValue]],@"n":award};
    
    [XTSeriesContentStore pictureAwardWithUrl:url andParameters:dic successBlock:^{
        [YYTHUD showPromptAddedTo:self.view withText:@"打赏成功了" withCompletionBlock:^{
            self.isEdit = YES;
        }];
    } failureBlock:^(NSError *error) {
        NSLog(@"error === %@",error);
        NSString *des = error.localizedDescription;
        [YYTHUD showPromptAddedTo:self.view withText:des withCompletionBlock:nil];
    }];
}

//图片举报
-(void)picComplaintRequest{
    NSString *url = [XT_API stringByAppendingString:XT_PICCOMPLAINT];
    NSDictionary *dic = @{@"pid":@([self.pidArr[self.curIndex] integerValue])};
    
    [XTSeriesContentStore pictureComplaintWithUrl:url andParameters:dic successBlock:^{
        [YYTHUD showPromptAddedTo:self.view withText:@"举报成功" withCompletionBlock:nil];
    } failureBlock:^(NSError *error) {
        NSString *des = error.localizedDescription;
        [YYTHUD showPromptAddedTo:self.view withText:des withCompletionBlock:nil];
    }];
}


- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return self.bigImgPresentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    //return self.dismissAnimation;
    return self.bigImgDismissAnimation;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    //return self.transitionController.interacting ? self.transitionController : nil;
    return nil;
}

#pragma mark - XHTransitionProtocol

- (CGPoint)pageViewCellScrollViewContentOffset {
    return self.pullOffset;
}

- (UICollectionView *)transitionCollectionView {
    return self.collectionView;
}

-(void)dealloc{
    NSLog(@"XTImgDetailViewController >>>>>> dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.isEdit && self.fromType == XTImgDetailViewControllerTypeMine) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumDetailNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumListNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAlbumHeadNotification" object:nil];
        
    }else if (self.isEdit && self.fromType == XTImgDetailViewControllerTypeDefault){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
    }
    
}
@end
