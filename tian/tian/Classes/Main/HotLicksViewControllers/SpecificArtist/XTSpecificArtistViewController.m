//
//  XTSpecificArtistViewController.m
//  tian
//
//  Created by huhuan on 15/7/1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSpecificArtistViewController.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTHotLicksCommonArtistInfo.h"
#import "XTHoverSwitchHeaderView.h"
#import "XTHoverSwitchCollectionView.h"
#import "XTCommentsModel.h"
#import "XTInputView.h"
#import "XTShareManager.h"
#import "XTImageInfo.h"
#import "SDWebImagePrefetcher.h"

@interface XTSpecificArtistViewController () <XTInputViewDelegate>

@property (nonatomic, strong) XTHoverSwitchHeaderView     *headerView;
@property (nonatomic, strong) XTHoverSwitchCollectionView *switchCollectionView;
@property (nonatomic, strong) XTInputView                 *commentInputView;
@property (nonatomic, strong) XTHotLicksCommonArtistInfo  *artistInfo;
@property (nonatomic, strong) NSURL                       *specificFirstImageUrl;
@property (nonatomic, assign) NSInteger                   picOffset;
@property (nonatomic, assign) NSInteger                   commentOffset;
@property (nonatomic, copy  ) NSString                    *specificDesc;
@property (nonatomic, strong) UIImage *firstImage;

@end

@implementation XTSpecificArtistViewController

static NSString *specificArtistUrl = @"/operate/show/artist.json";
static NSString *commentUrl        = @"/operate/comment/list.json";
static NSString *addCommentUrl     = @"/operate/comment/create.json";
static NSString *specificPicUrl    = @"/operate/show/pic.json";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.recommendTitle length] > 0) {
        self.title = self.recommendTitle;
    }else {
        self.title = @"专属艺人";
    }
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, 40, 40);
    [shareButton setImage:[UIImage imageNamed:@"share_brown"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    
    [self.view addSubview:self.commentInputView];
    self.commentInputView.hidden = YES;
    [self.commentInputView updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(@0);
        make.height.equalTo(53.f);
    }];
    self.picOffset = 0;
    self.commentOffset = 0;
    [self requestSpecificArtistInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shareClick:(id)sender {
    [self.commentInputView resignFirstResponder];
    if(self.firstImage) {
        [[XTShareManager sharedManager] shareWithTitle:self.recommendTitle withMvDesc:self.specificDesc withImage:self.firstImage withShareModeType:XTShareModeTypeStar withPid:self.recommendId  withShareSheetType:XTShareSheetItemNone withCompletionBlock:nil];
    }else {
        [YYTHUD showPromptAddedTo:self.view withText:@"图片未下载成功，暂时不能分享" withCompletionBlock:nil];
    }
}

- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.size.height;  // 得到键盘弹出后的键盘视图所在y坐标
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [self.commentInputView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-keyBoardEndY);
        }];
        [self.commentInputView layoutIfNeeded];
        
    }];
    [self.view bringSubviewToFront:self.commentInputView];
}

-(void)keyboardWillDismiss:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [self.commentInputView updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
        [self.commentInputView layoutIfNeeded];
        
    }];
}

#pragma -mark XTInputViewDelegate
-(void)postBtnActionWith:(NSMutableDictionary *)info{
    
    if([self.commentInputView.text length] == 0) {
        [YYTHUD showPromptNoLockAddedTo:[UIApplication sharedApplication].keyWindow withText:@"评论不能为空" withCompletionBlock:nil];
        return;
    }
    
    [YYTHUD showLoadingNoLockAddedTo:[UIApplication sharedApplication].keyWindow];
    
    NSDictionary *requestDic = @{
                                 @"id" : @(self.recommendId),
                                 @"content" : self.commentInputView.text
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager POST:addCommentUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        self.commentOffset = 0;
        self.switchCollectionView.commentInfo.comments = nil;
        self.commentInputView.text = @"";
        [self.commentInputView xt_resignFirstResponder];
        [self requestCommentInfo];
        [YYTHUD showPromptNoLockAddedTo:[UIApplication sharedApplication].keyWindow withText:@"发表评论成功" withCompletionBlock:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        [YYTHUD showPromptNoLockAddedTo:[UIApplication sharedApplication].keyWindow withText:[error xtErrorMessage] withCompletionBlock:nil];
    }];
    
}

-(XTInputView *)commentInputView{
    if (!_commentInputView) {
        _commentInputView = [[NSBundle mainBundle] loadNibNamed:@"XTInputView" owner:self options:nil][0];
        _commentInputView.placeholderText = @"说点什么吧...";
        _commentInputView.delegate = self;
        
    }
    return _commentInputView;
}

-(void)textDidChange:(CGFloat)height{
    
    [self.commentInputView updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(height);
    }];
}

- (void)requestSpecificArtistInfo {
    
    [YYTHUD showLoadingAddedTo:self.view];
    
    NSDictionary *requestDic = @{@"id" : @(self.recommendId)};
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:specificArtistUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTBlankView hideFromView:self.view];
        NSError *err = nil;
        self.artistInfo = [MTLJSONAdapter modelOfClass:[XTHotLicksCommonArtistInfo class] fromJSONDictionary:responseObject error:&err];
        self.artistInfo.pictures = nil;
        self.specificDesc = self.artistInfo.basic.content;
        self.headerView = [XTHoverSwitchHeaderView hoverHeaderViewWithRecInfo:self.artistInfo.basic andHeaderStyle:XTHoverSwitchHeaderViewStyleSpecific];
        [self.view insertSubview:self.headerView belowSubview:self.commentInputView];
        
        self.specificFirstImageUrl = self.artistInfo.basic.bigCover;
        [self downloadFirstImage];
        
        self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headerView.headerHeight]];
        
        self.switchCollectionView = [XTHoverSwitchCollectionView hoverSwitchCollectionViewWithHeaderHeight:self.headerView.headerHeight andHeaderView:self.headerView];
        self.switchCollectionView.belongId = [NSString stringWithFormat:@"%@",@(self.recommendId)];
        self.switchCollectionView.artistInfo = self.artistInfo;
        
        //额外请求图片及评论
        [self requestPicInfo];
        [self requestCommentInfo];
        
        [self.view addSubview:self.switchCollectionView];
        [self.view bringSubviewToFront:self.commentInputView];
        [self.switchCollectionView configureSwitchCollectionView];
        
        self.switchCollectionView.headerOriginYConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        [self.view addConstraint:self.switchCollectionView.headerOriginYConstraint];
        
        @weakify(self);
        
        self.headerView.pageChangeBlock = ^(NSInteger index) {
            @strongify(self);
            [self.switchCollectionView switchCollectViewToIndex:index];
            if(index == 0) {
                self.commentInputView.hidden = YES;
            }else {
                self.commentInputView.hidden = NO;
            }
            [self.view endEditing:YES];
        };
        
        self.switchCollectionView.pageChangeBlock = ^(NSInteger index){
            @strongify(self);
            if(index == 0) {
                self.headerView.isIntroStatus = YES;
                self.commentInputView.hidden = YES;
            }else if (index == 1) {
                self.headerView.isIntroStatus = NO;
                self.commentInputView.hidden = NO;
            }
            [self.headerView switchHeaderViewStatus];
            [self.view endEditing:YES];
        };
        
        self.switchCollectionView.basicTableViewLoadMore = ^() {
            @strongify(self);
            [self requestPicInfo];
        };
        
        self.switchCollectionView.commentTableViewLoadMore = ^() {
            @strongify(self);
            [self requestCommentInfo];
        };
        
        [self.view bringSubviewToFront:self.headerView];
        [YYTHUD hideLoadingFrom:self.view];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:self.view];
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self requestSpecificArtistInfo];
        }];
        blankView.error = error;
    }];
    
}

- (void)requestPicInfo {
    NSDictionary *requestDic = @{
                                 @"id" : @(self.recommendId),
                                 @"offset" : @(self.picOffset),
                                 @"size" : @"24"
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:specificPicUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        NSArray *picInfo = [MTLJSONAdapter modelsOfClass:[XTImageInfo class] fromJSONArray:responseObject error:&err];

        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.switchCollectionView.artistInfo.pictures];
        
        [tempArray addObjectsFromArray:picInfo withCheckKey:@"id" completionBlockWithReturnValue:^(NSMutableArray *array) {

            self.switchCollectionView.artistInfo.pictures = array;
            
            if([picInfo count] == 0) {
                [self.switchCollectionView refreshBasicTableViewIsLastLoad:YES];
            }else {
                self.picOffset += 24;
                [self.switchCollectionView refreshBasicTableViewIsLastLoad:NO];
            }
        }];
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)requestCommentInfo {
    NSDictionary *requestDic = @{
                                 @"id" : @(self.recommendId),
                                 @"offset" : @(self.commentOffset),
                                 @"size" : @"24"
                                 };
    
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:commentUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *err = nil;
        XTCommentsModel *commentsInfo = [MTLJSONAdapter modelOfClass:[XTCommentsModel class] fromJSONDictionary:responseObject error:&err];
        
        if([self.switchCollectionView.commentInfo.comments count] == 0) {
            self.switchCollectionView.commentInfo = commentsInfo;
            [self.switchCollectionView configureSwitchCollectionView];
        }else {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.switchCollectionView.commentInfo.comments];
            
            //去重
            [tempArray addObjectsFromArray:commentsInfo.comments withCheckKey:@"itemID" completionBlockWithReturnValue:^(NSMutableArray *array) {
                self.switchCollectionView.commentInfo.comments = array;
            }];
        }
        
        if([commentsInfo.comments count] == 0) {
            [self.switchCollectionView refreshCommentTableViewIsLastLoad:YES];
        }else {
            self.commentOffset += 24;
            [self.switchCollectionView refreshCommentTableViewIsLastLoad:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)downloadFirstImage {
    UIImage *headerImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:self.specificFirstImageUrl.absoluteString];
    
    if(!headerImage) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:self.specificFirstImageUrl options:SDWebImageRetryFailed | SDWebImageLowPriority
          progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
              self.firstImage = image;
          }];
    }else {
        self.firstImage = headerImage;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
