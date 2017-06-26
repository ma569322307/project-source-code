//
//  XTTopicDetailViewController.m
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicDetailViewController.h"
#import "Define.h"
#import "XTSeriesContentStore.h"
#import "XTTopicDetailView.h"
#import "XTCommendsView.h"
#import "XTUserHomePageViewController.h"
#import "XTUserInfo.h"

//#import "XTSpecificCommentTableViewCell.h"
#import "XTCommentsCell.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "XTInputView.h"
#import "XTCommentItemModel.h"
#import "XTImgSetView.h"
#import "XTBigImageViewController.h"
#import "XTBigImgPresentAnimation.h"
#import "XTBigImgDismissAnimation.h"

#import "XTTopicDetailModel.h"
#import "XTImgsModel.h"

#import "XTShareManager.h"

@interface XTTopicDetailViewController ()<XTCommendsViewDelegate,UITableViewDataSource,UITableViewDelegate,XTInputViewDelegate,XTTopicDetailViewDelegate,XTCommentsCellDelegate,XTImgSetViewDelegate,UIViewControllerTransitioningDelegate,XTBigImageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)XTTopicDetailView *detailView;

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NSLayoutConstraint *bottomConstraint;

@property(nonatomic,strong)XTInputView *inputView;

@property(nonatomic,strong)XTTopicDetailModel *topicDetailModel;

@property(nonatomic,strong)XTBigImgPresentAnimation *bigImgPresentAnimation;

@property(nonatomic,strong)XTBigImgDismissAnimation *bigImgDismissAnimation;

@property(nonatomic)BOOL isEdit;

@end

//static NSString *cellID = @"XTSpecificCommentTableViewCell";
static NSString *cellID = @"XTCommentsCell";

@implementation XTTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"话题详情";
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    footerView.backgroundColor = UIColorFromRGB(0xefeff4);
    self.tableView.tableFooterView = footerView;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
    
    
    //[self.tableView registerNib:[UINib nibWithNibName:@"XTSpecificCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"XTCommentsCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:self.inputView];
    
    [self.view addConstraint:self.bottomConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    
    //[self.inputView addConstraint:[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:53]];
    
    self.inputView.heightConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:53];
    
    self.tableView.footer = [XTGifFooter footerWithRefreshingBlock:^{
        [self topicCommentRequest];
    }];

    
    
    [self topicDetailRequest];
    [self topicCommentRequest];
}


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


-(XTTopicDetailView *)detailView{
    if (!_detailView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTTopicDetailView" owner:self options:nil];
        
        _detailView = nib[0];
        _detailView.delegate = self;
    }
    return _detailView;
}


-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(XTInputView *)inputView{
    if (!_inputView) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XTInputView" owner:self options:nil];
        
        _inputView = nib[0];
        _inputView.placeholderText = @"说点什么吧...";
        //_inputView.backgroundColor = [UIColor yellowColor];
        _inputView.translatesAutoresizingMaskIntoConstraints = NO;
        _inputView.delegate = self;
        
    }
    return _inputView;
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



-(void)setCommentInfo:(NSDictionary *)aCommentInfo{
    _commentInfo = aCommentInfo;

    if (!_commentInfo) {
        return;
    }
    [self.inputView xt_becomeFirstResponder];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_commentInfo[@"cid"] forKeyedSubscript:@"commentId"];
    [dic setObject:@([self.topicID integerValue]) forKeyedSubscript:@"postId"];
    XTUserInfo *userInfo = _commentInfo[@"userInfo"];
    self.inputView.placeholderText = [NSString stringWithFormat:@"回复:%@",userInfo.nickName];
    self.inputView.postCommentsInfo = dic;
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


-(NSLayoutConstraint *)bottomConstraint{
    if (!_bottomConstraint) {
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    }
    return _bottomConstraint;
}

-(void)topicDetailRequest{
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTSHOW];
    NSLog(@"url === %@",url);
    
    NSDictionary *dic = @{@"id":self.topicID};
    
    [XTSeriesContentStore topicDetailWithUrl:url andParameters:dic successBlock:^(id responseObject) {
        self.tableView.hidden = NO;
        NSLog(@"responseObjdect ===== %@",responseObject);
        self.topicDetailModel = responseObject;
        
        self.detailView.model = self.topicDetailModel;
        
        CGSize size = [self.detailView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        self.detailView.frame = CGRectMake(0, 0, size.width, size.height);
        
        self.tableView.tableHeaderView = self.detailView;
        
    } failureBlock:^(NSError *error) {
        self.tableView.hidden = !self.tableView.hidden;
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            
        }];
        
        blankView.error = error;
    }];
}


-(void)topicCommentRequest{
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTCOMMENTLIST];
    NSLog(@"url === %@",url);
    
    XTCommentItemModel *model = [self.dataSource lastObject];
    
    NSNumber *maxID = model.itemID ? model.itemID : @0;
    
    NSDictionary *dic = @{@"postId":self.topicID,@"maxId":maxID,@"size":@10};
    
    [XTSeriesContentStore topicCommentListWithUrl:url andParameters:dic successBlock:^(id responseObject) {
        [self.tableView.footer endRefreshing];
        NSArray *arr = responseObject;
        if (arr.count == 0) {
            [self.tableView.footer setHidden:YES];
            return ;
        }
        
        [self.dataSource addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        //self.tableView.hidden = YES;
//        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
//            
//        }];
//        
//        blankView.error = error;
    }];
}



-(void)commendActionWith:(XTCommendsView *)commendView{
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTCOMMEND];
    NSLog(@"url ==== %@",url);
    
    NSDictionary *dic = @{@"postId":self.topicID};
    
    [XTSeriesContentStore topicPostCommendWithUrl:url andParameters:dic successBlock:^{
        //NSLog(@"responseObjdect ==== %@",responseObject);
        [commendView commendSuccess];
        self.isEdit = YES;
    } failureBlock:^(NSError *error) {
        NSLog(@"error ==== %@",error);
    }];
}


-(void)cancelCommendActionWith:(XTCommendsView *)commendView{
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPSOTCOMMENDCANCEL];
    
    NSLog(@"url === %@",url);
    
    NSDictionary *dic = @{@"postId":self.topicID};
    
    [XTSeriesContentStore topicPostCancelCommentWithUrl:url andParameters:dic successBlock:^{
        //NSLog(@"responseObjdect ==== %@",responseObject);
        [commendView cancelCommendSuccess];
        self.isEdit = YES;
    } failureBlock:^(NSError *error) {
        NSLog(@"error ==== %@",error);
    }];
}


-(void)tapActionWith:(XTUserInfo*)userInfo{
    NSLog(@"uid ==== %@",userInfo);
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XTCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.index = indexPath.row;
    cell.controllerDelegate = self;
    cell.delegate = self;
    [cell congfigurateDataWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:cellID cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell congfigurateDataWithModel:self.dataSource[indexPath.row]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.inputView xt_isFirstResponder]) {
        [self.inputView xt_resignFirstResponder];
        
    }else {
        [self.inputView xt_becomeFirstResponder];
        XTCommentItemModel *model = self.dataSource[indexPath.row];
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:self.topicID forKeyedSubscript:@"postId"];
        [info setObject:model.itemID forKeyedSubscript:@"commentId"];
        
        self.inputView.placeholderText = [NSString stringWithFormat:@"回复:%@",model.user.nickName];
        self.inputView.postCommentsInfo = info;
    }
}


#pragma -mark XTInputViewDelegate

-(void)postBtnActionWith:(NSMutableDictionary *)info{
    NSString *text = info[@"text"];
    
    if (text.length > 140) {
        [YYTHUD showPromptAddedTo:self.view withText:@"评论不能超过140个字符" withCompletionBlock:nil];
        return;
    }
    
    [self.inputView xt_resignFirstResponder];
    
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTSCOMMENTS];
    
    //NSDictionary *dic = @{@"postId":self.topicID,@"commentId":@0,@"text":self.inputView.text};
    
    if (!info[@"postId"]) {
        [info setObject:[NSNumber numberWithInteger:[self.topicID integerValue]] forKeyedSubscript:@"postId"];
    }
    
    if (!info[@"commentId"]) {
        [info setObject:@0 forKeyedSubscript:@"commentId"];
    }
    
    [XTSeriesContentStore topicPostCommentsWithUrl:url andParameters:info successBlock:^(id respobseObjdect) {
        
        if ([info[@"commentID"] integerValue] == 0) {
            [YYTHUD showPromptAddedTo:self.view withText:@"评论成功" withCompletionBlock:nil];
        }else{
            [YYTHUD showPromptAddedTo:self.view withText:@"回复成功" withCompletionBlock:nil];
        }
        self.inputView.text = @"";
        [self.inputView xt_resignFirstResponder];
        self.inputView.postCommentsInfo = nil;

        [self.dataSource insertObject:respobseObjdect atIndex:0];
        [self.tableView reloadData];
        
        NSInteger commentCount = [self.topicDetailModel.commentCount integerValue] + 1;
        
        self.detailView.commentCount = commentCount;
        
        self.topicDetailModel.commentCount = [NSNumber numberWithInteger:commentCount];
        
        //self.detailView
        
        self.isEdit = YES;
        
    } failureBlock:^(NSError *error) {
        
    }];
}


#pragma -mark XTTopicDetailViewDelegate

-(void)tapAction{
    [self.inputView xt_resignFirstResponder];
}


-(void)topicDetailViewShareBtnAction:(XTTopicDetailModel *)model andImg:(UIImage *)image{
    [self.inputView xt_resignFirstResponder];
    
    [[XTShareManager sharedManager] shareWithTitle:model.title withMvDesc:model.des withImage:image withShareModeType:XTShareModeTypeTopicDetails withPid:[self.topicID integerValue] withShareSheetType:XTShareSheetItemNone withCompletionBlock:nil];
    
//    [[XTShareManager sharedManager] shareWithMvDesc:model.des withImage:image withShareModeType:XTShareModeTypeTopicDetails withPid:[self.topicID integerValue] withShareSheetType:XTShareSheetItemNone withCompletionBlock:^(NSInteger index) {
//    }];
}


-(void)topicDetailViewAvatarViewTapActionWith:(XTUserInfo *)userInfo{

    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma -mark XTCommentsCellDelegate

-(void)commentCommendActionWith:(NSInteger)index{
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.commendCount integerValue];
    model.commendCount = [NSNumber numberWithInteger:commendCount + 1];
    model.supported = YES;
    
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTCOMMENTSCOMMEND];
        
    NSDictionary *dic = @{@"cid":model.itemID};
    
    [XTSeriesContentStore topicPostCommentCommendWithUrl:url andParameters:dic successBlock:^{
         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)cancelCommentCommendActionWith:(NSInteger)index{
    
    XTCommentItemModel *model = self.dataSource[index];
    NSInteger commendCount = [model.commendCount integerValue];
    model.commendCount = [NSNumber numberWithInteger:commendCount - 1];
    model.supported = NO;
    
    NSString *url = [XT_API stringByAppendingString:XT_TOPICPOSTCOMMENTSCOMMENDCANCEL];
    
    NSDictionary *dic = @{@"cid":model.itemID};
    
    [XTSeriesContentStore topicPostsCommentsCommendCancelWithUrl:url andParameters:dic successBlock:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)tapAvatarImgViewActionWith:(XTUserInfo *)userInfo{
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%ld",userInfo.uid];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [self.navigationController pushViewController:controller animated:YES];

}



#pragma -mark XTImgSetViewDelegate

-(void)imgSetViewTapActionWith:(NSInteger)index andRect:(NSValue *)rectValue;{
    NSLog(@"index ===== %zd",index);
    //self.topicDetailModel
    if ([self.inputView xt_isFirstResponder]) {
        [self.inputView xt_resignFirstResponder];
    }else{
        NSDictionary *info = @{@"index":[NSNumber numberWithInteger:index],@"rect":rectValue};
        
        self.bigImgPresentAnimation.animationInfo = info;
        
        self.bigImgDismissAnimation.animationInfo = info;
        
        XTBigImageViewController *controller = [[XTBigImageViewController alloc] initWithNibName:@"XTBigImageViewController" bundle:nil];
        controller.delegate = self;
        //controller.pidArr = [self getPidArrWithImages:self.topicDetailModel.images];
        controller.topicID = self.topicID;
        controller.transitioningDelegate = self;
        controller.curIndex = index;
        [self presentViewController:controller animated:YES completion:^{
            controller.curIndex = index;
        }];
    }
}


#pragma -mark XTBigImageViewControllerDelegate
-(void)bigImageViewControllerDidClickedDismissButton:(XTBigImageViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(NSArray *)getPidArrWithImages:(NSArray *)images{
    
    NSMutableArray *arr_m = [NSMutableArray arrayWithCapacity:images.count];
    for (XTImgsModel *model in images) {
        NSNumber *itemID = model.itemID;
        
        NSString *itemID_str = [itemID stringValue];
        
        [arr_m addObject:itemID_str];
    }
    return arr_m;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.isEdit) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PostListRefreshNotification" object:nil];

    }
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
