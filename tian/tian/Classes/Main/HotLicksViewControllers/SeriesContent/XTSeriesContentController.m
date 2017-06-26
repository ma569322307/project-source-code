//
//  XTSeriesContentController.m
//  tian
//
//  Created by loong on 15/6/25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSeriesContentController.h"
#import "XTSeriesContentStore.h"
#import "Define.h"
#import "XTMapImageSetViewModel.h"
#import "XTMapImageSetView.h"
#import "XTMapImageViewModel.h"
#import "XTInputView.h"
#import <MJRefresh.h>
#import "XTCommentsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XTCommentsModel.h"
#import "YYTHUD.h"
#import "XTCommentItemModel.h"
#import "XTMapImagesView.h"
#import "XTOriginalViewController.h"
#import "XTShareManager.h"
#import "YYTBlankView.h"
@interface XTSeriesContentController()<UITableViewDataSource,UITableViewDelegate,XTInputViewDelegate,XTMapImagesViewDelegate,XTCommentsCellDelegate>


@property(weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)XTMapImageSetView *imgSetView;

@property(nonatomic,strong) XTInputView *inputView;

@property(nonatomic,strong) NSLayoutConstraint *bottomConstraint;

@property(nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,strong) XTMapImageSetViewModel *imgSetViewModel;

@property(nonatomic)NSInteger curPage;

@property(nonatomic,strong)UIButton *shareBtn;


@end


@implementation XTSeriesContentController

static NSString *cellID = @"XTCommentsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    footerView.backgroundColor = UIColorFromRGB(0xefeff4);
    self.tableView.tableFooterView = footerView;
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.curPage = 0;
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.shareBtn.frame = CGRectMake(0, 0, 40, 40);
    
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"share_brown"] forState:UIControlStateNormal];
    //[sharBtn setBackgroundImage:[UIImage imageNamed:@"share_h.png"] forState:UIControlStateHighlighted];
    self.shareBtn.enabled = NO;
    [self.shareBtn addTarget:self action:@selector(sharBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XTCommentsCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:self.inputView];
    
    [self.view addConstraint:self.bottomConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:53];
    
    self.inputView.heightConstraint= heightConstraint;
    
    self.tableView.footer = [XTGifFooter footerWithRefreshingBlock:^{
        [self commentsListRequset];
    }];
    
    
    [self mapImageSetRequest];
    [self commentsListRequset];
}



-(IBAction)sharBtnClick:(UIButton *)sender{
    
    [self.inputView xt_resignFirstResponder];
    
    //NSString *shareText = [self.imgSetViewModel.title stringByAppendingString:self.imgSetViewModel.content];
    
    [[XTShareManager sharedManager] shareWithTitle:self.imgSetViewModel.title withMvDesc:self.imgSetViewModel.content withImage:[self.imgSetView getImageForShare] withShareModeType:XTShareModeTypeSeries withPid:[self.itemID integerValue] withShareSheetType:XTShareSheetItemNone withCompletionBlock:^(NSInteger index) {
        
    }];
    
    
//    [[XTShareManager sharedManager] shareWithMvDesc:shareText withImage:[self.imgSetView getImageForShare] withShareModeType:XTShareModeTypeSeries withPid:[self.itemID integerValue] withShareSheetType:XTShareSheetItemNone withCompletionBlock:^(NSInteger index) {
//        //[YYTHUD showPromptAddedTo:self.view withText:@"分享成功" withCompletionBlock:nil];
//    }];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    //self.tableView.hidden = YES;
    [self.inputView xt_resignFirstResponder];
    
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
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:[duration floatValue] animations:^{
        self.bottomConstraint.constant = 0;
        [self.inputView layoutIfNeeded];
        
    }];
}



-(NSLayoutConstraint *)bottomConstraint{
    if (!_bottomConstraint) {
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }
    return _bottomConstraint;
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataSource;
}

-(XTInputView *)inputView{
    if (!_inputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTInputView" owner:self options:nil];
        
        _inputView = nib[0];
        _inputView.delegate = self;
        _inputView.placeholderText = @"说点什么吧...";
        _inputView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _inputView;
}



-(XTMapImageSetView *)imgSetView{
    if (!_imgSetView) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTMapImageSetView" owner:self options:nil];
        
        _imgSetView  = nib[0];
        
        _imgSetView.delegate = self;
    }
    return _imgSetView;
}

-(void)mapImageSetRequest{
    NSString *url = [XT_API stringByAppendingString:XT_SERIESCONTENT_MAPIMAGESET];
    NSLog(@"url === %@",url);
    
    NSDictionary *parameters = @{@"id":self.itemID};
    
    [XTSeriesContentStore fatchMapImageSetWithUrl:url andParameters:parameters successBlock:^(id responseObject) {
        [YYTBlankView hideFromView:self.view];
        self.tableView.hidden = NO;
        self.imgSetViewModel = responseObject;
        
        self.title = self.imgSetViewModel.title;
        
        self.imgSetView.model = self.imgSetViewModel;
        
        //self.imgSetView.commentNum = @(self.imgSetViewModel.albumCount);
        
        CGSize size = [self.imgSetView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        
        self.imgSetView.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.tableView.tableHeaderView = self.imgSetView;

    } failureBlock:^(NSError *error) {
        self.tableView.hidden = YES;
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self mapImageSetRequest];
        }];
        
        blankView.error = error;
    }];
}


-(void)commentsListRequset{
    NSString *url = [XT_API stringByAppendingString:XT_COMMENTLIST];
    NSLog(@"url ==== %@",url);
    
    NSDictionary *parameters = @{@"id":self.itemID,@"offset":@(self.curPage * 10),@"size":@10};
    
    [XTSeriesContentStore fatchOperateCommentListWithUrl:url andParameters:parameters successBlock:^(id responseObject) {
        self.curPage += 1;
        NSLog(@"responseObjdect%@",responseObject);
        [self.tableView.footer endRefreshing];
        XTCommentsModel *model = responseObject;
        NSArray *arr = model.comments;
        if (arr.count == 0) {
            [self.tableView.footer setHidden:YES];
            return ;
        }
        
        self.imgSetView.commentNum = @([model.totalCount integerValue] + [self.imgSetView.commentNum integerValue]);
        
         @weakify(self);
        [self.dataSource addObjectsFromArray:arr withCheckKey:@"itemID" completionBlock:^{
            @strongify(self);
            [self.tableView reloadData];
        }];

        //NSInteger commentCount = [model.totalCount integerValue] + [self.imgSetView.commentNum integerValue];
        
        
    } failureBlock:^(NSError *error) {

    }];
}



-(void)postBtnActionWith:(NSMutableDictionary *)info{
    NSLog(@"inof === %@",info);
    
    NSString *text = info[@"text"];
    
    if (text.length > 140) {
        [YYTHUD showPromptAddedTo:self.view withText:@"评论不能超过140个字符" withCompletionBlock:nil];
        return;
    }
    
    [self.inputView xt_resignFirstResponder];
    
    NSString *url = [XT_API stringByAppendingString:XT_OPERATECOMMENTCREAT];
    
    NSDictionary *dic = @{@"id":self.itemID,@"content":self.inputView.text};
    
    
    [XTSeriesContentStore operateCommentCreateWithUrl:url andParameters:dic successBlock:^(id responseObjdect) {
        
        
        [self.dataSource insertObject:responseObjdect atIndex:0];
        [self.tableView reloadData];
        [YYTHUD showPromptAddedTo:self.view withText:@"评论成功" withCompletionBlock:nil];
        self.inputView.text = @"";
        [self.inputView xt_resignFirstResponder];
        self.imgSetView.commentNum = @([self.imgSetView.commentNum integerValue] + 1);
        
    } failureBlock:^(NSError *error) {
        [YYTHUD showPromptAddedTo:self.view withText:@"评论失败" withCompletionBlock:nil];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.index = indexPath.row;
    cell.controllerDelegate = self;
    cell.delegate = self;
    [cell congfigurateDataWithSeriesContentModel:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell congfigurateDataWithSeriesContentModel:self.dataSource[indexPath.row]];
    }];
}


#pragma -mark XTMapImagesViewDelegate

-(void)mapImageViewTapActionWith:(NSInteger)index{
    NSLog(@"tag === %zd",index);
    XTMapImageViewModel *model = self.imgSetViewModel.albums[index];
    
    XTOriginalViewController *controller = [[XTOriginalViewController alloc]  initWithNibName:@"XTOriginalViewController" bundle:nil];
    controller.pictureId = [model.itemID integerValue];
    
    controller.type = XTPageTypeOther;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)firstImageLoadFinish{
    self.shareBtn.enabled = YES;
}



#pragma -mark XTCommentsCellDelegate

-(void)commentCommendActionWith:(NSInteger)index{
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.totalSupports integerValue];
    model.totalSupports = @(commendCount + 1);
    model.supported = YES;
    
    NSString *url = [XT_API stringByAppendingString:XT_OPERATECOMMENTSUPPORT];
    NSLog(@"url === %@",url);
    NSDictionary *dic = @{@"commentId":model.itemID,@"belongId":self.itemID};
    
    [XTSeriesContentStore operateCommentSupportWithUrl:url andParameters:dic successBlock:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)cancelCommentCommendActionWith:(NSInteger)index{
    
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.totalSupports integerValue];
    model.totalSupports = @(commendCount - 1);
    model.supported = NO;
    
    NSString *url = [XT_API stringByAppendingString:XT_OPERATECOMMENTCANCELSUPPORT];
    NSDictionary *dic = @{@"commentId":model.itemID,@"belongId":self.itemID};
    [XTSeriesContentStore operateCommentSupportWithUrl:url andParameters:dic successBlock:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } failureBlock:^(NSError *error) {
        
    }];

}

-(void)tapAvatarImgViewActionWith:(NSNumber *)userInfo{
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [userInfo stringValue];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
