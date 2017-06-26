//
//  XTSingleTopicDisplayController.m
//  tian
//
//  Created by Jiajun Zheng on 15/7/3.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSingleTopicDisplayController.h"
#import "XTHotLicksTopicsInfo.h"
#import "AddTagTableViewCell.h"
#import "XTTextNumberControlView.h"
#import "YYTHUD.h"
#import "XTMyTopicInputCell.h"
#import "XTAddTagViewController.h"
#import "XTUserStore.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTSubStore.h"
#import <Mantle/EXTScope.h>
#import "XTTapTableView.h"
@interface XTSingleTopicDisplayController ()<UITableViewDataSource,UITableViewDelegate,AddTagCellDelegate,XTTextNumberControlViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
// 创建话题按钮
@property (nonatomic, weak) UIButton *rightButton;
@property (nonatomic, weak) XTTextNumberControlView *titleView;
@property (nonatomic, weak) XTTextNumberControlView *descriptionView;
@property (nonatomic, assign,getter=isUserEnabled) BOOL userEnabled;
//原数据
@property (nonatomic, strong) NSArray *tags;
//原简介
@property (nonatomic, strong) NSString *oldDesc;
@end

@implementation XTSingleTopicDisplayController

static NSString * const reuseIdentifierTag = @"tagCell";
static NSString * const reuseIdentifierInput = @"inputCell";
static NSString * const reuseIdentifierImage = @"imageCell";
-(void)loadView{
    [super loadView];
    UITableView *tableView = [[XTTapTableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    tableView.showsVerticalScrollIndicator = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(6, 6, 6, 6));
    }];
}
// 点击其他部位结束编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isUserEnabled) {
        [self addRightButton];
    }
    // 注册cell
    [self.tableView registerClass:[AddTagTableViewCell class] forCellReuseIdentifier:reuseIdentifierTag];
    [self.tableView registerNib:[UINib nibWithNibName:@"XTMyTopicInputCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierInput];
    [self.tableView registerNib:[UINib nibWithNibName:@"XTMyTopicHeaderCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierImage];
    // 初始化tags
    self.tags = self.topicInfo.tags.copy;
    [self changeDictionaryTags:self.tags];
}
// 添加右边箭头
-(void)addRightButton{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:UIIMAGE(@"upload_ture") forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.rightButton = rightBtn;
    rightBtn.enabled = NO;
}
-(void)setTopicInfo:(XTHotLicksTopicsInfo *)topicInfo{
    _topicInfo = topicInfo;
    self.oldDesc = topicInfo.description;
    // 正常== 测试用!=
    if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        self.title = @"设置";
        self.userEnabled = YES;
    }else {
        self.title = @"话题资料";
        self.tableView.scrollEnabled = NO;
    }
}

-(void)clickRightBtn{
    //上传数据
    // 判断需要上传的内容
    [YYTHUD showLoadingAddedTo:self.view];
    self.rightButton.enabled = NO;
    // 上传话题
    [self.parameterDic setObject:@(self.topicInfo.id) forKey:@"id"];
    [self.parameterDic setObject:self.titleView.text forKey:@"title"];
    [self.parameterDic setObject:self.descriptionView.text forKey:@"description"];
    NSLog(@"更新之后的信息%@",self.parameterDic);
    XTSubStore *subStore = [[XTSubStore alloc] init];
    ///上传数据
    @weakify(self);
    [subStore updateTopic:self.parameterDic
                      completionBlock:^(BOOL isSucceed, NSError *error) {
                          @strongify(self);
                          [YYTHUD hideLoadingFrom:self.view];
                          if (!error && isSucceed) {
                              if (self.completionBlock) {
                                  self.completionBlock();
                              }
                              //话题更新成功
                              //通知其他界面更新数据
                              [self postNitifications];
                              [self.navigationController popViewControllerAnimated:YES];
                          }else{
                              NSString *result = [error xtErrorMessage];
                              // 提示上传失败
                              NSLog(@"上传图片失败:%@",result);
                              if ([[result substringToIndex:4] isEqualToString:@"网络错误"]) {
                                  result = @"网络错误,设置失败";
                              }else if(result == nil){
                                  result = @"设置失败";
                              }
                              [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:result withCompletionBlock:nil];
                              self.rightButton.enabled = YES;
                          }
                      }];
}
-(void)postNitifications{
    // 发送通知通知主页界面的参与话题信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserTopicNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification" object:nil];
}
// 更新标签
- (void)updateUploadImageTag:(NSNotification *)notification{
    NSMutableArray *tags = [notification object];
    self.tags = tags.copy;
    [self changeDictionaryTags:self.tags];
    
    AddTagTableViewCell *cell = (AddTagTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.placeholderLabel.hidden = YES;
    [cell.tagView removeAllTags];
    [cell.tagView addTags:tags];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self checkRightButton];
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
    [self.parameterDic setObject:@"" forKey:@"tags"];
}
// 判断可否点击
-(void)checkRightButton{
    // 文本无内容不能创建
    self.rightButton.enabled = self.titleView.text.length != 0 && self.descriptionView.text.length != 0;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark UITableView 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    // 判断哪一行
    switch (indexPath.row) {
        case 1:
        {
            // 标签
            AddTagTableViewCell *tagCell = [[AddTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifierTag andType:self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue] ? NO : YES];
            tagCell.titleLabel.text = self.isUserEnabled?@"":@"标签";
            [tagCell.addTagBtn updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(self.isUserEnabled?@35:@0);
            }];
            tagCell.delegate = self;
            tagCell.placeholderLabel.hidden = self.topicInfo.tags.count > 0;
            [tagCell.tagView addTags:self.topicInfo.tags];
            cell = tagCell;
        }
            break;
        case 0:
        {
            // 小文本
            XTMyTopicInputCell *inputCellS = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInput];
            inputCellS.big = NO;
            self.titleView = inputCellS.textView;
            inputCellS.textView.countDelegate = self;
            inputCellS.title = @"标题:";
            inputCellS.textView.text = self.topicInfo.title;
            inputCellS.textView.font = [UIFont boldSystemFontOfSize:13];
            inputCellS.textView.placeHolder = @"";
            cell = inputCellS;
            inputCellS.textView.textColor = UIColorFromRGB(0x595959);
            inputCellS.userInteractionEnabled = NO;
        }
            break;
        case 2:
        {
            // 大文本
            XTMyTopicInputCell *inputCellB = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInput];
            inputCellB.big = YES;
            self.descriptionView = inputCellB.textView;
            inputCellB.textView.countDelegate = self;
            inputCellB.title = @"简介:";
            inputCellB.textView.placeHolder = @"";
            inputCellB.textView.text = self.topicInfo.topicDescription;
            inputCellB.textView.textColor = UIColorFromRGB(0x595959);
            if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
                inputCellB.userInteractionEnabled = YES;
            }else {
                inputCellB.userInteractionEnabled = NO;
            }
            cell = inputCellB;
        }
            break;
    }
//    cell.userInteractionEnabled = self.isUserEnabled;
    return cell;
}
#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 判断哪一行
    switch (indexPath.row) {
        case 1:
        {
            // 标签
            return 53;
        }
            break;
            
        case 0:
        {
            // 小文本
            return 53;
        }
            break;
            
        default:
        {
            // 大文本
            return 200;
        }
            break;
    }
}
#pragma mark AddTagCell代理
-(void)clickAddTagBtn:(UIButton *)button{
    // 添加tag通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUploadImageTag:)
                                                 name:AddTagNotification
                                               object:nil];
    XTAddTagViewController *addTagViewCtr = [[XTAddTagViewController alloc] init];
    addTagViewCtr.oldTags = self.tags.mutableCopy;
    [self.navigationController pushViewController:addTagViewCtr animated:YES];
}
#pragma mark XTTextNumberControlViewDelegate
-(void)textNumberControlView:(XTTextNumberControlView *)textView numberOfText:(NSInteger)numberOfText{
    [self checkRightButton];
}
#pragma mark 懒加载
-(NSMutableDictionary *)parameterDic{
    if (_parameterDic == nil) {
        _parameterDic = [NSMutableDictionary dictionary];
    }
    return _parameterDic;
}

@end
