//
//  XTChatViewController.m
//  tian
//
//  Created by cc on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTChatViewController.h"
#import "NSString+TimeReversal.h"
#import "XTPrivateMessageSetViewController.h"
#import "XTUserHomePageViewController.h"
#import "XTUserStore.h"
@interface XTChatViewController ()

@end

@implementation XTChatViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self addBackNavigationItem];
    //TODO: 此版本不要此功能了！
  //  [self addSetNavigationItem];
    self.enableSaveNewPhotoToLocalSystem = YES;
     [self notifyUpdateUnreadMessageCount];
    
//    [self.chatSessionInputBarControl.additionalButton setBackgroundImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
    

    
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER];
    self.chatSessionInputBarControl.inputContainerView.backgroundColor = UIColorFromRGB(0xffe707);
   // [self.chatSessionInputBarControl.emojiButton setImage:[UIImage imageNamed:@"comment_normal"] forState:UIControlStateNormal];
//    self.chatSessionInputBarControl.inputTextView.;
//    self.chatSessionInputBarControl.additionalButton.hidden = YES;
    // Do any additional setup after loading the view.
    
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, CGRectGetWidth(self.conversationMessageCollectionView.frame), CGRectGetHeight(self.conversationMessageCollectionView.frame));
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // [self addBackNavigationItem];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBackNavigationItem
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 35, 35);
    [backBtn setImage:[UIImage imageNamed:@"na_back_brown"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(clickNaBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
- (void)addSetNavigationItem
{
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 35, 35);
    [setBtn setImage:[UIImage imageNamed:@"set_brown"] forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:@"set_brown_sel"] forState:UIControlStateHighlighted];
    
    [setBtn addTarget:self action:@selector(clickSetBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
}
- (void)clickNaBackBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)clickSetBtn:(UIButton *)sender
{
    XTPrivateMessageSetViewController *setVC = [[XTPrivateMessageSetViewController alloc]init];
    [self.navigationController pushViewController:setVC animated:YES];
}
//点击头像
- (void)didTapCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:[XTUserStore sharedManager].user.userID]) {
        return;
    }else if ([userId isEqualToString:@""]||userId == nil||userId.length==0)
    {
        return;
    }
    XTUserHomePageViewController *userHomePagevC = [[XTUserHomePageViewController alloc]init];
    userHomePagevC.type = XTUserHomePageTypeHis;
    userHomePagevC.userID = userId;
    userHomePagevC.userType = XTAccountCommon;
    [self.navigationController pushViewController:userHomePagevC animated:YES];
}
/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
//    __weak typeof(&*self) __weakself = self;
//    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
//                                                                @(ConversationType_PRIVATE),
//                                                                @(ConversationType_DISCUSSION),
//                                                                @(ConversationType_APPSERVICE),
//                                                                @(ConversationType_PUBLICSERVICE),
//                                                                @(ConversationType_GROUP)
//                                                                ]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *backString = nil;
//        if (count > 0 && count < 1000) {
//            backString = [NSString stringWithFormat:@"返回(%d)", count];
//        } else if (count >= 1000) {
//            backString = @"返回(...)";
//        } else {
//            backString = @"返回";
//        }
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(0, 6, 67, 23);
//        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
//        backImg.frame = CGRectMake(-10, 0, 22, 22);
//        [backBtn addSubview:backImg];
//        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
//        backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
//        backText.font = [UIFont systemFontOfSize:15];
//        [backText setBackgroundColor:[UIColor clearColor]];
//        [backText setTextColor:[UIColor whiteColor]];
//        [backBtn addSubview:backText];
//        [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
//    });
}

/**
 *  打开大图。开发者可以重写，自己下载并且展示图片。默认使用内置controller
 *
 *  @param imageMessageContent 图片消息内容
 */
- (void)presentImagePreviewController:(RCMessageModel *)model;
{
    RCImagePreviewController *_imagePreviewVC =
    [[RCImagePreviewController alloc] init];
    _imagePreviewVC.messageModel = model;
    _imagePreviewVC.title = @"图片预览";
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:_imagePreviewVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//    RCMessageCell
}

- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    [super didLongTouchMessageCell:model inView:view];
    NSLog(@"%s", __FUNCTION__);
}
/**
 *  发送新拍照的图片成功之后，如果需要保存到本地系统，则重写该方法
 *
 *  @param newImage 待保存的图片
 */
- (void)saveNewPhotoToLocalSystemAfterSendingSuccess:(UIImage *)newImage
{
    //保存图片
    UIImage *image = newImage;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
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
