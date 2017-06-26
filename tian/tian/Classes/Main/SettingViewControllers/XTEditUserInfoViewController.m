//
//  XTEditUserInfoViewController.m
//  tian
//
//  Created by 曹亚云 on 15-7-1.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTEditUserInfoViewController.h"
#import "XTUserStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "YYTAlertView.h"
#import "NSString+TextSize.h"
static NSString *string = @"http://papi.yinyuetai.com/account/user/update.json";
@interface XTEditUserInfoViewController ()<XTTextNumberControlViewDelegate>
@property (nonatomic, strong) UIView *lineView;
@end

@implementation XTEditUserInfoViewController
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
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    UIView *statusAndNavigationBarBgView = [UIView new];
    statusAndNavigationBarBgView.backgroundColor = UIColorFromRGB(0xececec);
    [self.view addSubview:statusAndNavigationBarBgView];
    [statusAndNavigationBarBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@-64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    
    [self textView];
    [self lineView];
    [self.textView becomeFirstResponder];
    [self countLabel];
}

- (XTTextNumberControlView *)textView {
    if (!_textView) {
        _textView = [[XTTextNumberControlView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.text = self.placeHolderText;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.count = self.count;
        _textView.countDelegate = self;
        [self.view addSubview:_textView];
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(@8);
            make.left.equalTo(self.view).offset(@5);
            make.right.equalTo(self.view).offset(@-5);
            make.height.equalTo(@170);
        }];
    }
    return _textView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.view addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.right.bottom.equalTo(_textView);
        }];
    }
    return _lineView;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.text = [NSString stringWithFormat:@"%zd/%zd", self.placeHolderText?[self.placeHolderText lengthOfBytesUsingChineseCheck]:0, _textView.count];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_countLabel];
        
        [_countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textView.bottom).offset(@5);
            make.right.equalTo(_textView);
            make.height.equalTo(@10);
        }];
    }
    return _countLabel;
}

- (void)submit{
    switch (self.type) {
        case XTEditUserInfoTypeNickname:{
            XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
            NSDictionary *paramDic = @{@"nickName":_textView.text};
            [manager POST:@"http://papi.yinyuetai.com/account/user/update.json" parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                self.userFilesInfo.nickName = _textView.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                YYTAlertView *alertView = [[YYTAlertView alloc]initWithTitle:@"提示" message:[error xtErrorMessage] delegate:self cancelButtonTitle:@"取消" verifyButtonTitle:@"确定"];
                [alertView show];
            }];
        }
            break;
        case XTEditUserInfoTypeBrief:{
        
            self.userFilesInfo.brief = _textView.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case XTEditUserInfoTypeBeiZhu:{
            NSString *str = [self.beiZhuArray objectAtIndex:_index];
            NSRange range = [str rangeOfString:@"→←"];
            NSString *keyStr = [str substringToIndex:range.location];
            NSString *replaceStr = [NSString stringWithFormat:@"%@→←%@",keyStr,_textView.text];
            [self.beiZhuArray replaceObjectAtIndex:_index withObject:replaceStr];
            self.userFilesInfo.beiZhu = [self uploadBeiZhuStr:self.beiZhuArray];
            [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case XTEditAlbumTypeDes:{
            NSDictionary *strDic = @{@"albumDes":_textView.text};
            [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification
                                                                object:strDic];
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;
        case XTEditAlbumTypeName:{
            NSDictionary *strDic = @{@"albumName":_textView.text};
            [[NSNotificationCenter defaultCenter] postNotificationName:EditUserInfoNotification
                                                                object:strDic];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (NSMutableString *)uploadBeiZhuStr:(NSMutableArray *)beiZhuArray
{
    NSMutableString *updateStr = [NSMutableString stringWithCapacity:0];
    for (int index = 0; index < [beiZhuArray count]; index++) {
        NSString *str = [beiZhuArray objectAtIndex:index];
        if (index == [beiZhuArray count] - 1) {
            [updateStr appendString:str];
        }else{
            [updateStr appendString:[NSString stringWithFormat:@"%@↑↓",str]];
        }
    }
    
    return updateStr;
}

-(void)textNumberControlView:(XTTextNumberControlView *)textView
                numberOfText:(NSInteger)numberOfText
{
    self.countLabel.text = [NSString stringWithFormat:@"%zd/%zd", numberOfText, _textView.count];
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
