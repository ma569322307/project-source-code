//
//  XTUserFilesViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-6.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSetUserFilesViewController.h"
#import "XTAddTagViewController.h"
#import "XTSetFootView.h"
#import "XTTabBarController.h"
#import "XTEditDesTableViewCell.h"
#import "XTHeadSetTableViewCell.h"
#import "XTUserStore.h"
#import "XTSubStore.h"
#import "XTUserFilesInfo.h"
#import "UIImage+rn_Blur.h"
#import "JKImagePickerController.h"
#import "XTUploadImageManage.h"
#import "XTEditUserInfoViewController.h"
#import "HZAreaPickerView.h"
#import "YYTHUD.h"

#define GenderPickerViewTag     10000
#define StarPickerViewTag       10001
#define EmotionPickerViewTag    10002

static NSString * const XTHeadSetTableViewCellIdentifier = @"XTHeadSetTableViewCell";
static NSString * const XTSetTableViewCellIdentifier = @"XTSetTableViewCell";

@interface XTSetUserFilesViewController ()<UITableViewDataSource, UITableViewDelegate, SetFootViewDelegate, JKImagePickerControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, HZAreaPickerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UITableView *setTableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *beiZhuArray;
@property (nonatomic, strong) XTUserFilesInfo *userFilesInfo;
@property (nonatomic, strong) UIImage *headerImage;

@property (nonatomic, strong) HZAreaPickerView *locatePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSArray *genderSourceArray;
@property (nonatomic, strong) NSArray *starSourceArray;
@property (nonatomic, strong) NSArray *emotionSourceArray;

@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSString *selectedArea;
@property (nonatomic, strong) NSString *areaValue, *cityValue;
@property (nonatomic, strong) NSDate *selectedBirthday;

@property (nonatomic, strong) NSURL *headURL;
@property (nonatomic, strong) UIImage *headImage;
@end

@implementation XTSetUserFilesViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshUI)
                                                     name:EditUserInfoNotification
                                                   object:nil];
        self.genderSourceArray = @[@"男",@"女",@"保密"];
        self.starSourceArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
        self.emotionSourceArray = @[@"一只单身狗",@"有主然并卵",@"同性相吸喵",@"不约，汪汪！",@"谜の存在"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"档案";
    
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(updateUserFilesData)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    
    [self setTableView];
    self.setTableView.tableFooterView = [self footView];
    
    [self.setTableView registerNib:[UINib nibWithNibName:@"XTHeadSetTableViewCell" bundle:nil] forCellReuseIdentifier:XTHeadSetTableViewCellIdentifier];
    
    [self loadUserFilesData];
}

- (NSString *)calculateAgeWithBirthday:(NSDate *)brithdayDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //当前日期
    NSDate *nowDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
    //生日
    NSDate *endDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:brithdayDate]];
    //得到相差秒数
    NSTimeInterval time = [nowDate timeIntervalSinceDate:endDate];
    int ages = ((int)time)/(3600*24*365);
    int days = ((int)time)%(3600*24*365)/(3600*24);
    /*
     int days = ((int)time)/(3600*24);
     int hours = ((int)time)%(3600*24)/3600;
     int minute = ((int)time)%(3600*24)%3600/60;*/
    
    NSString *dateContent = nil;
    if (ages <= 0) {
        if (days <= 0) {
            dateContent = @"0";
        }else{
            dateContent = @"1";
        }
    }else{
        if (days <= 0) {
            dateContent = [NSString stringWithFormat:@"%i",ages];
        }else{
            dateContent = [NSString stringWithFormat:@"%i",ages+1];
        }
    }
    CLog(@"%@",dateContent);
    return dateContent;
}

- (UITableView *)setTableView{
    if (!_setTableView) {
        _setTableView = [UITableView new];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _setTableView.backgroundColor = UIColorFromRGB(0xececec);
        [self.view addSubview:_setTableView];
        
        [_setTableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _setTableView;
}

- (XTSetFootView *)footView{
    XTSetFootView *footView = [[[NSBundle mainBundle] loadNibNamed:@"XTSetFootView" owner:self options:nil] objectAtIndex:0];
    footView.backgroundColor = UIColorFromRGB(0xececec);
    footView.delegate = self;
    [footView.logoutBtn setBackgroundImage:[UIImage imageNamed:@"set_remark"] forState:UIControlStateNormal];
    [footView.logoutBtn setBackgroundImage:[UIImage imageNamed:@"set_remark_sel"] forState:UIControlStateHighlighted];
    [footView.logoutBtn setTitle:@"添加个性化介绍" forState:UIControlStateNormal];
    [footView.logoutBtn setTitle:@"添加个性化介绍" forState:UIControlStateHighlighted];
    [footView.logoutBtn setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateNormal];
    [footView.logoutBtn setTitleColor:UIColorFromRGB(0x4f242b) forState:UIControlStateHighlighted];
    
    return footView;
}

- (UIPickerView *)createPickerView:(NSInteger)tag{
    UIPickerView *pickerView = nil;
    if (VERSION >= 8.0) {
        pickerView  = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_SIZE.width-16, 220)];
    }else {
        pickerView  = [[UIPickerView alloc]initWithFrame:CGRectMake(8, 5, SCREEN_SIZE.width-16, 220)];
    }
    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.tag = tag;
    return pickerView;
}

- (void)initDatePickView{
    if (VERSION >= 8.0) {
        self.datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 5, SCREEN_SIZE.width-16, 220);
    }else {
        self.datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(8, 5, SCREEN_SIZE.width-16, 220);
    }
    _datePicker.backgroundColor = [UIColor clearColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd"; //设置日期格式
    
    NSDate* minDate = [formatter dateFromString:@"1950-01-01"];
    NSDate* maxDate = [NSDate date];
    
    _datePicker.minimumDate = minDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.date = [formatter dateFromString:@"1990-01-01"];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    self.selectedBirthday = control.date;
    /*添加你自己响应代码*/
}

- (void)initLocatePicter{
    if (VERSION >= 8.0) {
        self.locatePicker = [[HZAreaPickerView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_SIZE.width-16, 220) style:HZAreaPickerWithStateAndCity delegate:self];
    }else {
        self.locatePicker = [[HZAreaPickerView alloc] initWithFrame:CGRectMake(8, 5, SCREEN_SIZE.width-16, 220) style:HZAreaPickerWithStateAndCity delegate:self];
    }
    self.locatePicker.backgroundColor = [UIColor clearColor];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if (picker.pickerStyle == HZAreaPickerWithStateAndCityAndDistrict) {
        self.areaValue = [NSString stringWithFormat:@"%@ %@ %@", picker.locate.state, picker.locate.city, picker.locate.district];
        NSLog(@"选择的用户位置信息：%@",self.areaValue);
    } else{
        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
        NSLog(@"选择的用户位置信息：%@",self.cityValue);
    }
}

- (void)showActionSheetAndPickerView:(NSInteger)row
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    self.selectedRow = row;
    switch (row) {
        case 1:{
            [actionSheet addSubview:[self createPickerView:GenderPickerViewTag]];
        }
            break;
        case 2:{
            if (!_datePicker) {
                [self initDatePickView];
            }
            [actionSheet addSubview:_datePicker];
        }
            break;
        case 3:{
            [actionSheet addSubview:[self createPickerView:StarPickerViewTag]];
        }
            break;
        case 4:{
            if (!_locatePicker) {
                [self initLocatePicter];
            }
            [actionSheet addSubview:_locatePicker];
        }
            break;
        case 5:{
            [actionSheet addSubview:[self createPickerView:EmotionPickerViewTag]];
        }
            break;
        default:
            break;
    }
    actionSheet.tag = 2001;
    [actionSheet showInView:self.view];
}

//转换为对应类型
- (NSString *)getSelectedStringType
{
    NSArray *theAreaArray = @[@"Boy",@"Girl",@"Secret"];
    NSInteger selectIncomponentone = [_pickerView selectedRowInComponent:0];
    return theAreaArray[selectIncomponentone];
}

#pragma mark -
#pragma mark pickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    self.pickerView = pickerView;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case GenderPickerViewTag:{
            return [self.genderSourceArray count];
        }
            break;
        case StarPickerViewTag:{
            return [self.starSourceArray count];
        }
            break;
        case EmotionPickerViewTag:{
            return [self.emotionSourceArray count];
        }
            break;
        default:{
            return 0;
        }
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case GenderPickerViewTag:{
            return [self.genderSourceArray objectAtIndex:row];
        }
            break;
        case StarPickerViewTag:{
            return [self.starSourceArray objectAtIndex:row];
        }
            break;
        case EmotionPickerViewTag:{
            return [self.emotionSourceArray objectAtIndex:row];
        }
            break;
        default:{
            return nil;
        }
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (void)addUIAlertController:(NSInteger)row {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"\n\n\n\n\n\n\n\n\n\n\n"// change UIAlertController height
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    self.selectedRow = row;
    switch (row) {
        case 1:{
            [alert.view addSubview:[self createPickerView:GenderPickerViewTag]];
        }
            break;
        case 2:{
            if (!_datePicker) {
                [self initDatePickView];
            }
            [alert.view addSubview:_datePicker];
        }
            break;
        case 3:{
            [alert.view addSubview:[self createPickerView:StarPickerViewTag]];
        }
            break;
        case 4:{
            if (!_locatePicker) {
                [self initLocatePicter];
            }
            [alert.view addSubview:_locatePicker];
        }
            break;
        case 5:{
            [alert.view addSubview:[self createPickerView:EmotionPickerViewTag]];
        }
            break;
        default:
            break;
    }
    
    UIToolbar *toolView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, alert.view.frame.size.width-16, 44)];
    toolView.layer.cornerRadius = 5;
    toolView.layer.masksToBounds = YES;
    toolView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *bbtSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bbtOK = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(OKWithPicker:)];
    bbtOK.width = 60.f;
    bbtOK.tag = row;
    UIBarButtonItem *bbtCancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelWithPicker)];
    bbtCancel.width = 60.f;
    toolView.items = [NSArray arrayWithObjects:bbtCancel,bbtSpace,bbtOK, nil];
    [alert.view addSubview:toolView];
    [self presentViewController:alert animated:YES completion:nil];
#endif
}

- (void)OKWithPicker:(UIBarButtonItem *)sender {
    switch (sender.tag) {
        case 1:{
            self.userFilesInfo.gender = [self.genderSourceArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
        }
            break;
        case 2:{
            self.userFilesInfo.age = [self calculateAgeWithBirthday:self.selectedBirthday];
        }
            break;
        case 3:{
            self.userFilesInfo.star = [self.starSourceArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
        }
            break;
        case 4:{
            self.userFilesInfo.province = self.locatePicker.locate.state;
            self.userFilesInfo.city = self.locatePicker.locate.city;
        }
            break;
        case 5:{
            self.userFilesInfo.qingGan = [self.emotionSourceArray objectAtIndex:[_pickerView selectedRowInComponent:0]];
        }
            break;
        default:
            break;
    }
    
    [self.setTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)CancelWithPicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseHeaderImage
{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.needSquareCrop = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    UIImage *image = assets.lastObject;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        self.isChangeUserPortrait = YES;
        XTHeadSetTableViewCell *cell = (XTHeadSetTableViewCell *)[self.setTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.headImageView.image = image;
        self.headerImage = image;
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)loadUserFilesData{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    NSString *userId = [[XTUserStore sharedManager] user].userID;
    [subStore fetchUserFilesWithUserId:[userId integerValue]
                       completionBlock:^(XTUserFilesInfo *userFilesInfo, NSError *error) {
                           if (!error) {
                               NSLog(@"userFilesInfo:%@",userFilesInfo);
                               self.userFilesInfo = userFilesInfo;
                               self.beiZhuArray = [NSMutableArray arrayWithArray:[self.userFilesInfo.beiZhu componentsSeparatedByString:@"↑↓"]];
                               NSLog(@"%@",self.userFilesInfo.beiZhu);
                               [self.setTableView reloadData];
                           }
                       }];
}

- (void)updateUserFilesData{
    if (_isChangeUserPortrait) {
        if (self.headerImage) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserFilesData:) name:UploadImageSucceedNotification object:nil];
            XTUploadImageManage *uploadManage = [XTUploadImageManage shareUploadImageManage];
            uploadManage.type = XTUploadImageTypeHeadPortrait;
            uploadManage.userFilesInfo = self.userFilesInfo;
            [uploadManage uploadImagePicker:self.headerImage];
        }
    }else{
        XTSubStore *subStore = [[XTSubStore alloc] init];
        [subStore editUserFilesWithUserFiles:self.userFilesInfo
                             completionBlock:^(BOOL isSucceed, NSError *error) {
                                 if (!error) {
                                     [YYTHUD showPromptAddedTo:[[UIApplication sharedApplication] keyWindow] withText:@"粉丝资料修改成功" withCompletionBlock:^{
                                         [self loadUserFilesData];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserFilesNotification" object:nil];
                                     }];
                                 }else{
                                     [YYTHUD showPromptAddedTo:[[UIApplication sharedApplication] keyWindow] withText:@"粉丝资料修改失败" withCompletionBlock:nil];
                                 }
                             }];
    }
}

- (void)refreshUserFilesData:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    [YYTHUD showPromptAddedTo:[[UIApplication sharedApplication] keyWindow] withText:[dic objectForKey:@"message"] withCompletionBlock:^{
        [self loadUserFilesData];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UploadImageSucceedNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserDetailNotifition" object:nil];
    }];
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
            return 7;
        }
            break;
        case 2:{
            return [self.beiZhuArray count];
        }
            break;
        default:{
            return 1;
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
            XTHeadSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XTHeadSetTableViewCellIdentifier forIndexPath:indexPath];
            [cell.headImageView an_setImageWithURL:_userFilesInfo.headImg];
            cell.headImageBtn.hidden = YES;
            cell.nameLabel.text = _userFilesInfo.nickName;
            return cell;
        }
            break;
        case 1:{
            XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];;
            cell.contentLabel.textColor = UIColorFromRGB(0x818181);
            switch (indexPath.row) {
                case 0:{
                    cell.titleLabel.text = @"呢称";
                    cell.contentLabel.text = _userFilesInfo.nickName;
                }
                    break;
                case 1:{
                    cell.titleLabel.text = @"性别";
                    cell.contentLabel.text = _userFilesInfo.gender;
                }
                    break;
                case 2:{
                    cell.titleLabel.text = @"年龄";
                    cell.contentLabel.text = _userFilesInfo.age;
                }
                    break;
                case 3:{
                    cell.titleLabel.text = @"星座";
                    cell.contentLabel.text = _userFilesInfo.star;
                }
                    break;
                case 4:{
                    cell.titleLabel.text = @"地址";
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@ %@", _userFilesInfo.province?_userFilesInfo.province:@"",_userFilesInfo.city?_userFilesInfo.city:@""];
                }
                    break;
                case 5:{
                    cell.titleLabel.text = @"情感";
                    cell.contentLabel.text = _userFilesInfo.qingGan;
                }
                    break;
                case 6:{
                    cell.titleLabel.text = @"签名";
                    cell.contentLabel.text = _userFilesInfo.brief;
                }
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 2:{
            XTEditDesTableViewCell *cell = [[XTEditDesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.contentLabel.textColor = UIColorFromRGB(0x818181);
            NSString *str = [self.beiZhuArray objectAtIndex:indexPath.row];
            NSRange range = [str rangeOfString:@"→←"];
            NSString *keyStr = [str substringToIndex:range.location];
            cell.titleLabel.text = keyStr;
            cell.contentLabel.text = [str substringFromIndex:range.location+2];
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
    if (indexPath.section == 0) {
        return 65;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            [self chooseHeaderImage];
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    XTEditUserInfoViewController *editInfoCtr = [[XTEditUserInfoViewController alloc] init];
                    editInfoCtr.title = @"昵称";
                    editInfoCtr.placeHolderText = self.userFilesInfo.nickName;
                    editInfoCtr.type = XTEditUserInfoTypeNickname;
                    editInfoCtr.userFilesInfo = self.userFilesInfo;
                    editInfoCtr.count = 15;
                    [self.navigationController pushViewController:editInfoCtr animated:YES];
                }
                    break;
                case 6:{
                    XTEditUserInfoViewController *editInfoCtr = [[XTEditUserInfoViewController alloc] init];
                    editInfoCtr.title = @"签名";
                    editInfoCtr.placeHolderText = self.userFilesInfo.brief;
                    editInfoCtr.type = XTEditUserInfoTypeBrief;
                    editInfoCtr.userFilesInfo = self.userFilesInfo;
                    editInfoCtr.count = 70;
                    [self.navigationController pushViewController:editInfoCtr animated:YES];
                }
                    break;
                default:{
                    [self clickEditCellWithRow:indexPath.row];
                }
                    break;
            }
        }
            break;
        case 2:{
            XTEditUserInfoViewController *editInfoCtr = [[XTEditUserInfoViewController alloc] init];
            NSString *str = [self.beiZhuArray objectAtIndex:indexPath.row];
            NSRange range = [str rangeOfString:@"→←"];
            NSString *keyStr = [str substringToIndex:range.location];
            editInfoCtr.title = keyStr;
            editInfoCtr.placeHolderText = [str substringFromIndex:range.location+2];
            editInfoCtr.type = XTEditUserInfoTypeBeiZhu;
            editInfoCtr.userFilesInfo = self.userFilesInfo;
            editInfoCtr.beiZhuArray = self.beiZhuArray;
            editInfoCtr.index = indexPath.row;
            editInfoCtr.count = 10;
            [self.navigationController pushViewController:editInfoCtr animated:YES];
        }
            break;
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [self.setTableView beginUpdates];
        [self.beiZhuArray removeObjectAtIndex:indexPath.row];
    
        self.userFilesInfo.beiZhu = [self uploadBeiZhuStr:self.beiZhuArray];
        [self.setTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.setTableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)clickEditCellWithRow:(NSInteger)row
{
    if (VERSION >= 8.0) {
        [self addUIAlertController:row];
    }else {
        [self showActionSheetAndPickerView:row];
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 1001:{
            
        }
            break;
        case 2001:{
            
        }
            break;
        default:
            break;
    }
}

- (void)refreshUI{
    [self.setTableView reloadData];
}

- (void)clickDeleteBtn:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserFilesBeiZhu:)
                                                 name:AddTagNotification
                                               object:nil];
    XTAddTagViewController *addTagViewCtr = [[XTAddTagViewController alloc] init];
    addTagViewCtr.type = XTAddTagTypeNoData;
    [self.navigationController pushViewController:addTagViewCtr animated:YES];
}

- (void)updateUserFilesBeiZhu:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddTagNotification object:nil];
    NSMutableArray *tags = [notification object];
    CLog(@"%@",tags);
    NSMutableArray *updateTags = [NSMutableArray arrayWithCapacity:0];
    for (int index = 0; index < [tags count]; index++) {
        NSString *str = [tags objectAtIndex:index];
        NSMutableString *updateStr = [NSMutableString stringWithCapacity:0];
        [updateStr appendString:[NSString stringWithFormat:@"%@→←",str]];
        [updateTags addObject:updateStr];
    }
    
    [self.beiZhuArray addObjectsFromArray:updateTags];
    [self refreshUI];
    self.userFilesInfo.beiZhu = [self uploadBeiZhuStr:self.beiZhuArray];
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
