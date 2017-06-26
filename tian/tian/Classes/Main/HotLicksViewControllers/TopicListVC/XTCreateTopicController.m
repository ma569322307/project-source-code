//
//  XTCreateTopicController.m
//  tian
//
//  Created by Jiajun Zheng on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCreateTopicController.h"
#import "AddTagTableViewCell.h"
#import "XTAddTagViewController.h"
#import "XTMyTopicInputCell.h"
#import "XTMyTopicHeaderCell.h"
#import "JKImagePickerController.h"
#import "XTUploadImageManage.h"
#import "XTTextNumberControlView.h"
#import "YYTHUD.h"
#import <Mantle/EXTScope.h>
#import "XTTapTableView.h"

@interface XTCreateTopicController ()<UITableViewDataSource,UITableViewDelegate,AddTagCellDelegate,JKImagePickerControllerDelegate,XTTextNumberControlViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
// 创建话题按钮
@property (nonatomic, strong) UIButton *createButton;
// 头像图片
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, weak) XTTextNumberControlView *titleView;
@property (nonatomic, weak) XTTextNumberControlView *descriptionView;
//原数据
@property (nonatomic, strong) NSArray *tags;
@end

@implementation XTCreateTopicController
static NSString * const reuseIdentifierTag = @"tagCell";
static NSString * const reuseIdentifierInput = @"inputCell";
static NSString * const reuseIdentifierImage = @"imageCell";
-(void)loadView{
    [super loadView];
    UITableView *tableView = [[XTTapTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
//    tableView.scrollEnabled = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    [self.view addSubview:self.createButton];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).insets(UIEdgeInsetsMake(0, 6, 6, 6));
    }];
    tableView.contentInset = UIEdgeInsetsMake(6, 0, 75, 0);
}
// 点击其他部位结束编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    NSLog(@"%@",self.createButton);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 修改标题
    self.title = @"创建话题";
    // 注册cell
    [self.tableView registerClass:[AddTagTableViewCell class] forCellReuseIdentifier:reuseIdentifierTag];
    [self.tableView registerNib:[UINib nibWithNibName:@"XTMyTopicInputCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierInput];
    [self.tableView registerNib:[UINib nibWithNibName:@"XTMyTopicHeaderCell" bundle:nil] forCellReuseIdentifier:reuseIdentifierImage];
    // 注册通知
    [self addNotifications];
    
    // 添加约束
    [self addConstraints];
}
-(void)uploadTopic{
    if ([[XTHTTPRequestOperationManager sharedManager] reachable] == NO) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow
                         withText:@"网络未连接"
              withCompletionBlock:nil];
        return;
    }
    // 判断需要上传的内容
    [self changeDictionaryTags:self.tags];
    [YYTHUD showLoadingAddedTo:self.view];
    // 上传话题
    [self.parameterDic setObject:self.titleView.text forKey:@"title"];
    [self.parameterDic setObject:self.descriptionView.text forKey:@"description"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadResult:) name:UploadImageSucceedNotification object:nil];
    NSLog(@"%@",self.parameterDic);
    XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
    uploadManage.type = XTUploadImageTypeHeadTopic;
    uploadManage.topicParameterDic = self.parameterDic;
    [uploadManage uploadImagePicker:self.headerImage];
}
// 上传结果
-(void)uploadResult:(NSNotification *)note{
    NSString *result = [note.object objectForKey:@"message"];
    [YYTHUD hideLoadingFrom:self.view];
    if ([result isEqualToString:@"照片上传成功"]) {
        @weakify(self);
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"创建成功" withCompletionBlock:^{
            @strongify(self);
            // 上传完成回调
            if (self.completionBlock) {
                self.completionBlock();
            }
            [self postNitifications];
            // 弹出
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        
        // 提示上传失败
        NSLog(@"上传图片失败:%@",result);
        if ([[result substringToIndex:4] isEqualToString:@"网络错误"]) {
            result = @"网络错误,发布失败";
        }else if(result == nil){
            result = @"发布失败";
        }
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:result withCompletionBlock:nil];
    }
}
-(void)postNitifications{
    // 发送通知通知主页界面的参与话题信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserTopicNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification" object:nil];
}
/// 添加约束
-(void)addConstraints{
    @weakify(self);
    [self.createButton makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.view).offset(@-5);
        make.left.equalTo(self.view).offset(@5);
        make.right.equalTo(self.view).offset(@-5);
        make.height.equalTo(@50);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addNotifications{
    // 选择头像通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseHeaderImage) name:kHeaderClickNotification object:nil];
}
// 去相册添加头像
-(void)chooseHeaderImage{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = NO;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    imagePickerController.needSquareCrop = YES;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
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
        return;
    }
    [self.parameterDic setObject:@"" forKey:@"tags"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark UITableView 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    // 判断哪一行
    switch (indexPath.row) {
        case 0:
        {
            // 头像
            XTMyTopicHeaderCell *imageCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImage];
            imageCell.headerImage = self.headerImage;
            cell = imageCell;
        }
            break;
        case 1:
        {
            // 标签
            AddTagTableViewCell *tagCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTag];
            tagCell.titleLabel.text = @"";
            tagCell.delegate = self;
            cell = tagCell;
        }
            break;
        case 2:
        {
            // 小文本
            XTMyTopicInputCell *inputCellS = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInput];
            inputCellS.big = NO;
            self.titleView = inputCellS.textView;
            inputCellS.textView.countDelegate = self;
            inputCellS.title = @"";
            cell = inputCellS;
        }
            break;
        case 3:
        {
            // 大文本
            XTMyTopicInputCell *inputCellB = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierInput];
            inputCellB.big = YES;
            self.descriptionView = inputCellB.textView;
            inputCellB.textView.countDelegate = self;
            inputCellB.title = @"";
            cell = inputCellB;
        }
            break;
    }
    return cell;
}
#pragma mark UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 判断哪一行
    switch (indexPath.row) {
        case 0:
        {
            // 头像
            return 164;
        }
            break;
            
        case 1:
        {
            // 标签
            return 53;
        }
            break;
            
        case 2:
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
-(void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    // 无内容不能创建
    self.createButton.enabled = self.titleView.text.length != 0 && self.descriptionView.text.length != 0 && self.headerImage != nil;
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
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    UIImage *image = assets.lastObject;
    self.headerImage = image;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    return;
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark XTTextNumberControlViewDelegate
-(void)textNumberControlView:(XTTextNumberControlView *)textView numberOfText:(NSInteger)numberOfText{
    // 文本无内容不能创建
    self.createButton.enabled = self.titleView.text.length != 0 && self.descriptionView.text.length != 0 && self.headerImage != nil;
}
#pragma mark 懒加载
-(UIButton *)createButton{
    if (_createButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.enabled = NO;
        // 监听事件
        [btn addTarget:self action:@selector(uploadTopic) forControlEvents:UIControlEventTouchUpInside];
        // 设置外观
        [btn setImage:[UIImage imageNamed:@"na_add"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"na_add_sel"] forState:UIControlStateHighlighted];
        [btn setTitle:@"发布话题" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"Tabbar_nav_title"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"Tabbar_nav_title"] forState:UIControlStateHighlighted];
        _createButton = btn;
    }
    return _createButton;
}
-(NSMutableDictionary *)parameterDic{
    if (_parameterDic == nil) {
        _parameterDic = [NSMutableDictionary dictionary];
    }
    return _parameterDic;
}
@end
