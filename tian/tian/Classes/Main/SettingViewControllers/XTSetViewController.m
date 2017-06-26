//
//  XTSetViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSetViewController.h"
#import "XTEditDesTableViewCell.h"
#import "XTSetAlbumTableViewCell.h"
#import "XTSetTableViewCell.h"
#import "XTMessageSetTableViewCell.h"
#import "XTSetFootView.h"
#import "XTUserStore.h"
#import "YYTUICommon.h"
#import "XTTabBarController.h"
#import "XTSetUserFilesViewController.h"
#import "XTcheckBoundPhoneViewController.h"
#import "XTAboutOursViewController.h"
#import "XTRuleViewController.h"
#import "XTChangePassWViewController.h"
#import "AppDelegate.h"
#import "XTGuideManage.h"
#import "XTRongCloudManager.h"
#import "XTShareManager.h"
#import "YYTAlertView.h"
#import "UMFeedback.h"
#import "XTBindApnsStore.h"
#import "IQKeyboardManager.h"
#define filePath  [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"]
#define APP_ID 973879340

static NSString * const XTMessageSetTableViewCellIdentifier = @"XTMessageSetTableViewCell";
static NSString * const XTSetTableViewCellIdentifier = @"XTSetTableViewCell";

@interface XTSetViewController ()<UITableViewDataSource, UITableViewDelegate, SetFootViewDelegate>
@property (nonatomic, strong)UITableView *configureTableView;
@property (nonatomic, strong)NSString *sizeString;
@property (nonatomic, strong) UISwitch *messageSwith;
@end

@implementation XTSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    CLog(@"%@",self.navigationItem);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.configureTableView = tableView;
    self.configureTableView.delegate = self;
    self.configureTableView.dataSource = self;
    self.configureTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.configureTableView.backgroundColor = UIColorFromRGB(0xececec);
    [self.view addSubview:_configureTableView];
    
    [self.configureTableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    XTSetFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"XTSetFootView" owner:self options:nil] objectAtIndex:0];
    footView.delegate = self;
    footView.backgroundColor = UIColorFromRGB(0xececec);
    self.configureTableView.tableFooterView = footView;
    
    // Do any additional setup after loading the view from its nib.
    [self.configureTableView registerNib:[UINib nibWithNibName:@"XTMessageSetTableViewCell" bundle:nil] forCellReuseIdentifier:XTMessageSetTableViewCellIdentifier];
    [self.configureTableView registerNib:[UINib nibWithNibName:@"XTSetTableViewCell" bundle:nil] forCellReuseIdentifier:XTSetTableViewCellIdentifier];
}

- (void)clickNaBackBtn:(UIButton *)sender
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isShowTabBar",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isShowTabBarNotification" object:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:{
            return 1;
        }
            break;
        case 2:{
            return 5;
        }
            break;
        default:{
            return 4;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 16.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 16.0;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.xtwidth, 16)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.xtwidth, 16)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSArray *titleArray = [NSArray arrayWithObjects:@"账号绑定", @"修改密码", @"修改粉丝资料", @"声望值/等级/积分规则",nil];
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            if (indexPath.row == 3) {
                cell.buttomLineView.hidden = YES;
            }
            return cell;
        }
            break;
        case 1:{
            XTSetAlbumTableViewCell *cell = [[XTSetAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            self.messageSwith = cell.messageSwitch;
            NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:@"messageClose"];
            if (value == nil) {
                [[NSUserDefaults standardUserDefaults] setInteger:YES forKey:@"messageClose"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            cell.messageSwitch.on = [[NSUserDefaults standardUserDefaults] integerForKey:@"messageClose"];
            NSArray *titleArray = [NSArray arrayWithObjects:@"消息提醒", @"启动音效",@"相互关注好友互发私信",nil];
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                cell.buttomLineView.hidden = YES;
            }
            @weakify(cell);
            cell.switchBlock = ^(){
                @strongify(cell);
                CLog(@"点击了消息提醒");
                NSString *token = [XTBindApnsStore sharedManager].apnsToken;
                if (token == nil) {
                    [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"设置失败"withCompletionBlock:^{
                        [cell.messageSwitch setOn:!cell.messageSwitch.isOn animated:YES];
                    }];
                    return;
                }
                [[XTUserStore sharedManager] setNotifiesPush:[XTBindApnsStore sharedManager].apnsToken
                                                       allow:YES
                                             completionBlock:^(BOOL success, NSError *error) {
                                                 if (success) {
                                                     [[NSUserDefaults standardUserDefaults] setInteger:cell.messageSwitch.isOn forKey:@"messageClose"];
                                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                                 }else{
                                                     NSString *result = [error xtErrorMessage];
                                                     // 提示设置失败
                                                     NSLog(@"设置失败:%@",result);
                                                     if ([[result substringToIndex:4] isEqualToString:@"网络错误"]) {
                                                         result = @"网络错误,设置失败";
                                                     }else if(result == nil){
                                                         result = @"设置失败";
                                                     }
                                                     [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:result withCompletionBlock:^{
                                                         [cell.messageSwitch setOn:!cell.messageSwitch.isOn animated:YES];
                                                     }];
                                                 }
                                                 
                                             }];
            };
            return cell;
        }
            break;
        case 2:{
            XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSArray *titleArray = [NSArray arrayWithObjects:@"清理缓存", @"给我们打分", @"意见反馈", @"把舔推荐给朋友", @"关于舔",nil];
            cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
            if (indexPath.row == 4) {
                cell.buttomLineView.hidden = YES;
            }
            if (indexPath.row == 0) {
                cell.contentLabel.text = [NSString stringWithFormat:@"%@MB",[self getCacheDateSize]];
                cell.contentLabel.textColor = [UIColor redColor];
            }
            if (indexPath.row == 3) {
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSString *label = [NSString stringWithFormat:@"%@ v%@", name, version];
                cell.contentLabel.text = label;
//                cell.contentLabel.textColor = UIColorFromRGB(0xececec);
                cell.contentLabel.textColor = UIColorFromRGB(0xffe707);

            }
            return cell;
        }
            break;
        default:{
            XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];;
            return cell;
        }
            break;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    CLog(@"点击了账号绑定");
                    XTcheckBoundPhoneViewController *boundiphoneVC = [[XTcheckBoundPhoneViewController alloc]initWithNibName:@"XTboundiphoneViewController" bundle:nil];
                    [self.navigationController pushViewController:boundiphoneVC animated:YES];
                }
                    break;
                case 1:{
                    CLog(@"点击了修改密码");
                    XTChangePassWViewController *ChangeVC = [[XTChangePassWViewController alloc]initWithNibName:@"XTChangePassWViewController" bundle:nil];
                    [self.navigationController pushViewController:ChangeVC animated:YES];
                }
                    break;
                case 2:{
                    CLog(@"点击了修改粉丝资料");
                    XTSetUserFilesViewController *setCtr = [[XTSetUserFilesViewController alloc] initWithNibName:@"XTSetUserFilesViewController" bundle:nil];
                    [self.navigationController pushViewController:setCtr animated:YES];
                }
                    break;
                case 3:{
                    CLog(@"点击了声望值，等级");
                    /*
                    XTWebViewController *web = [[XTWebViewController alloc] initWithNibName:@"XTWebViewController" bundle:nil];
                    [web loadRequestWithURL:[NSURL URLWithString:@"http://m.yinyuetai.com/tian/rule"]];
                    [self.navigationController pushViewController:web animated:YES];*/

                    XTRuleViewController *RuleVC = [[XTRuleViewController alloc]initWithNibName:@"XTRuleViewController" bundle:nil];
                    [self.navigationController pushViewController:RuleVC animated:YES];
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
                    break;
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    CLog(@"点击了清除缓存");
                    [YYTAlertView showFullTypeAlertViewWithTitle:@"温馨提示" message:@"是否清除缓存数据？" completaionBlock:^(NSInteger index) {
                        if (index == 1){
                            [self clearCacheData];
                            [self.configureTableView reloadData];
                        }
                    }];
                }
                    break;
                case 1:{
                    CLog(@"点击了给我们打分");
                    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",APP_ID];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                    break;
                case 2:{
                    CLog(@"点击了意见反馈");
                    UIButton *backBtn = nil;
                    SETIMAGEBTN(backBtn, @"na_back_brown", @"na_back_brown");
                    backBtn.frame = CGRectMake(0, 0, 35, 35);
                    [[UMFeedback sharedInstance] setBackButton:backBtn];
                    [UMFeedback feedbackViewController].hidesBottomBarWhenPushed = YES;
                    // 无法获取友盟统计的控制器，所以添加一个标记
                    [UMFeedback feedbackViewController].view.tag = 56700;
                    [self.navigationController pushViewController:[UMFeedback feedbackViewController]
                                                         animated:YES];
                }
                    break;
                case 3:{
                    CLog(@"把舔推荐给好友");
                    [[XTShareManager sharedManager] shareWithMvDesc:nil withImage:nil withShareModeType:XTShareModeTypeAtlas withPid:0 withShareSheetType:0 withCompletionBlock:nil];
                }
                    break;
                default:{
                    CLog(@"关于舔");
                    XTAboutOursViewController *AboutOurVC = [[XTAboutOursViewController alloc]init];
                    [self.navigationController pushViewController:AboutOurVC animated:YES];
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1001:{
            if (buttonIndex == 1){
                [self clearCacheData];
                [self.configureTableView reloadData];
            }
        }
            break;
        case 2001:{
            if (buttonIndex == 1){
                [[XTUserStore sharedManager] logoutWithBlock:^(BOOL isSuccess, NSError *error) {
                    if (!error) {
                        [self.navigationController popViewControllerAnimated:YES];
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        delegate.window.rootViewController = [XTGuideManage createDispayViewController];
                        [[XTRongCloudManager shareInstance] rongCloudLogout];
                    }
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)clearCacheData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager removeItemAtPath:filePath error:&error] == NO)//表示此路径是目录
    {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] cleanDisk];
        
        NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
        for (NSString *fileName in fileEnumerator){
            NSString *filePathString = [filePath stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:filePathString error:nil];
        }
    }
    
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:nil] != YES)
    {
        [YYTHUD showPromptAddedTo:self.view withText:@"清理完毕!" withCompletionBlock:nil];
    }
    self.sizeString = @"";
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
}

-(NSString*)getCacheDateSize
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.sizeString.length == 0) {
            double size = 0.0;
            NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:filePath];
            for (NSString *fileName in fileEnumerator)
            {
                NSString *filePathString = [filePath stringByAppendingPathComponent:fileName];
                NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePathString error:nil];
                size += [attrs fileSize];
            }
            NSString *str = [NSString stringWithFormat:@"%lf", size/1048576];
            NSRange range = [str rangeOfString:@"." options:NSCaseInsensitiveSearch];
            self.sizeString = [str substringToIndex:range.location+2];
            [self performSelectorOnMainThread:@selector(refreshUI) withObject:nil waitUntilDone:NO];
        }
    });
    return self.sizeString;
}

- (void)refreshUI{
    [self.configureTableView reloadData];
}

- (void)clickDeleteBtn:(UIButton *)button{
    [YYTAlertView showFullTypeAlertViewWithTitle:@"温馨提示" message:@"记得再来翻小奴家的牌子哟!" completaionBlock:^(NSInteger index) {
        if (index == 1){
            [[XTUserStore sharedManager] logoutWithBlock:^(BOOL isSuccess, NSError *error) {
                if (!error) {
                    //融云退出登录
                    [[RCIM sharedRCIM] logout];
                    [self.navigationController popViewControllerAnimated:YES];
                    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    delegate.window.rootViewController = [XTGuideManage createDispayViewController];
                    [[XTRongCloudManager shareInstance] rongCloudLogout];
                }
            }];
        }
    }];
}

- (void)dealloc {
    self.configureTableView.delegate = nil;
    self.configureTableView.dataSource = nil;
    NSLog(@"setting release");
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

@end
