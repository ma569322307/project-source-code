//
//  SearchIndexViewController.m
//  tian
//
//  Created by huhuan on 15/6/10.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTSearchIndexViewController.h"
#import "XTSearchIndexTableView.h"
#import "XTSearchIndexModel.h"
#import "XTHTTPRequestOperationManager.h"
#import "XTConfig.h"
#import "XTPickerView.h"
#import "XTSearchAllViewController.h"
#import "XTSearchUsersViewController.h"
#import "XTSearchTagViewController.h"
#import "XTSearchTopicViewController.h"
#import "XTTabBarController.h"
#import "XTSearchAssociateTableView.h"
#import "XTSearchImagesViewController.h"
#import <Mantle/EXTScope.h>

//左滑消失区域

@interface XTSearchIndexViewController () <UITextFieldDelegate>

@property (nonatomic, weak  ) IBOutlet UIView                       *searchBarView;
@property (nonatomic, weak  ) IBOutlet UIButton                     *dropdownButton;
@property (nonatomic, weak  ) IBOutlet UITextField                  *searchTextfield;
@property (nonatomic, weak  ) IBOutlet UIButton                     *clearButton;
@property (nonatomic, weak  ) IBOutlet UIView                       *contentView;

@property (nonatomic, strong) XTPickerView                 *picker;

@property (nonatomic, strong) XTSearchIndexTableView       *searchIndexTableView;
@property (nonatomic, strong) XTSearchAllViewController    *searchAllVC;
@property (nonatomic, strong) XTSearchUsersViewController  *searchUserVC;
@property (nonatomic, strong) XTSearchTagViewController    *searchTagVC;
@property (nonatomic, strong) XTSearchTopicViewController  *searchTopicVC;
@property (nonatomic, strong) XTSearchImagesViewController *searchImagesVC;

@property (nonatomic, strong) XTSearchAssociateTableView   *associateTableView;

@property (nonatomic, copy  ) NSString                     *searchType;

@end

@implementation XTSearchIndexViewController

static NSString *associateUrl = @"/search/suggest.json";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.titleView = self.searchBarView;
    
    self.searchBarView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, 44.);
    
    self.searchIndexTableView = [XTSearchIndexTableView searchIndexTableView];
    [self.contentView addSubview:self.searchIndexTableView];
    self.searchIndexTableView.hidden = YES;
    
    [self.searchIndexTableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
    }];
    
    self.picker = [XTPickerView pickerViewWithDataSource:@[
                                                           @{@"type" : @"all", @"text" : @"全部"},
                                                           @{@"type" : @"artist", @"text" : @"人"},
                                                           @{@"type" : @"topic", @"text" : @"话题"},
                                                           @{@"type" : @"tag", @"text" : @"标签"},
                                                           @{@"type" : @"pic", @"text" : @"图片"}
                                                           ]];
    self.picker.alwaysRefresh = YES;
    @weakify(self);
    self.picker.pickerSelectedBlock = ^(NSDictionary *typeDic){
        @strongify(self);
        [self.dropdownButton setTitle:typeDic[@"text"] forState:UIControlStateNormal];
        self.searchType = typeDic[@"type"];
        if([self.searchTextfield.text length] > 0) {
            [self switchSearchType:self.searchType];
        }
    };
    
    self.searchType = @"all";
    [self requestSearchIndexInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.leftBarButtonItem = spaceButtonItem;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar bringSubviewToFront:self.navigationItem.titleView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)dropDownButtonClick:(id)sender {
    [self.searchTextfield resignFirstResponder];
    [self.picker show];
}

- (IBAction)clearButtonClick:(id)sender {
    self.searchTextfield.text = @"";
    self.clearButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.associateTableView.associateArray = nil;
        [self.associateTableView reloadData];
        self.associateTableView.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
}

- (IBAction)closeButtonClick:(id)sender {
    [self.searchTextfield resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (XTSearchUsersViewController *)searchUserVC {
    if(!_searchUserVC) {
        _searchUserVC = [[XTSearchUsersViewController alloc] initWithNibName:@"XTSearchUsersViewController" bundle:nil];
        [self addChildViewController:_searchUserVC];
    }
    return _searchUserVC;
}

- (XTSearchAllViewController *)searchAllVC {
    if(!_searchAllVC) {
        _searchAllVC = [[XTSearchAllViewController alloc] initWithNibName:@"XTSearchAllViewController" bundle:nil];
        [self addChildViewController:_searchAllVC];
    }
    return _searchAllVC;
}

- (XTSearchTopicViewController *)searchTopicVC {
    if(!_searchTopicVC) {
        _searchTopicVC = [[XTSearchTopicViewController alloc] init];
        [self addChildViewController:_searchTopicVC];
    }
    return _searchTopicVC;
}

- (XTSearchTagViewController *)searchTagVC {
    if(!_searchTagVC) {
        _searchTagVC = [[XTSearchTagViewController alloc] init];
        [self addChildViewController:_searchTagVC];
    }
    return _searchTagVC;
}

- (XTSearchImagesViewController *)searchImagesVC {
    if(!_searchImagesVC) {
        _searchImagesVC = [[XTSearchImagesViewController alloc] initWithNibName:@"XTSearchImagesViewController" bundle:nil];
        [self addChildViewController:_searchImagesVC];
    }
    return _searchImagesVC;
}

- (XTSearchAssociateTableView *)associateTableView {
    if(!_associateTableView) {
        _associateTableView = [XTSearchAssociateTableView associateTableView];
        _associateTableView.alpha = 0.f;
        
        @weakify(self);
        _associateTableView.cellClick = ^(NSString *keyword) {
            @strongify(self);
            [self.searchTextfield resignFirstResponder];
            self.searchTextfield.text = keyword;
            [self switchSearchType:self.searchType];
            
            [UIView animateWithDuration:0.3 animations:^{
                self.associateTableView.associateArray = nil;
                [self.associateTableView reloadData];
                self.associateTableView.alpha = 0.f;
            } completion:^(BOOL finished) {
            }];
        };
        [self.view addSubview:_associateTableView];
        [_associateTableView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }
    return _associateTableView;
}

- (void)switchSearchType:(NSString *)type {

    [self.searchAllVC.view removeFromSuperview];
    [self.searchUserVC.view removeFromSuperview];
    [self.searchTopicVC.view removeFromSuperview];
    [self.searchTagVC.view removeFromSuperview];
    [self.searchImagesVC.view removeFromSuperview];
    [YYTBlankView hideFromView:self.view];
    
    self.searchType = type;
    if([type isEqualToString:@"all"]) {
        [self.contentView addSubview:self.searchAllVC.view];
        [self.searchAllVC didMoveToParentViewController:self];

        self.searchAllVC.keyword = self.searchTextfield.text;
        [self.searchAllVC refreshViewController];
        [self.searchAllVC.view remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }else if([type isEqualToString:@"artist"]) {
        [self.contentView addSubview:self.searchUserVC.view];
        [self.searchUserVC didMoveToParentViewController:self];
        
        self.searchUserVC.keyword = self.searchTextfield.text;
        [self.searchUserVC refreshViewController];
        [self.searchUserVC.view remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }else if([type isEqualToString:@"topic"]) {
        [self.contentView addSubview:self.searchTopicVC.view];
        [self.searchTopicVC didMoveToParentViewController:self];
        
        self.searchTopicVC.keyword = self.searchTextfield.text;
        [self.searchTopicVC refreshViewController];
        [self.searchTopicVC.view remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }else if([type isEqualToString:@"tag"]) {
        [self.contentView addSubview:self.searchTagVC.view];
        [self.searchTagVC didMoveToParentViewController:self];
        
        self.searchTagVC.keyword = self.searchTextfield.text;
        [self.searchTagVC refreshViewController];
        [self.searchTagVC.view remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }else if([type isEqualToString:@"pic"]) {
        [self.contentView addSubview:self.searchImagesVC.view];
        [self.searchImagesVC didMoveToParentViewController:self];
        
        self.searchImagesVC.keyword = self.searchTextfield.text;
        [self.searchImagesVC refreshViewController];
        [self.searchImagesVC.view remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }

}

- (void)requestSearchIndexInfo {
    
    [YYTHUD showLoadingAddedTo:[UIApplication sharedApplication].keyWindow];
    NSDictionary *requestDic = @{@"prefixAppid" : @"12334", @"deviceinfo" : [[XTConfig sharedManager] deviceInfo]};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:searchIndexUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [YYTBlankView hideFromView:self.view];
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        NSError *err = nil;
        XTSearchIndexModel *searchIndexInfo = [MTLJSONAdapter modelOfClass:[XTSearchIndexModel class] fromJSONDictionary:responseObject error:&err];
        self.searchIndexTableView.indexModel = searchIndexInfo;
        [self.searchIndexTableView configureSearchIndexTableView];
        [self.searchIndexTableView reloadData];
        self.searchIndexTableView.hidden = NO;
  
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YYTHUD hideLoadingFrom:[UIApplication sharedApplication].keyWindow];
        
        YYTBlankView *blankView = [YYTBlankView showBlankInView:self.view style:YYTBlankViewStyleNetworkError eventClick:^{
            [self requestSearchIndexInfo];
        }];
        blankView.error = error;
        blankView.needAutolayout = YES;
    }];

}

- (void)requestSearchAssociateInfo {
    
    NSString *searchText = [self.searchTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDictionary *requestDic = @{@"deviceinfo" : [[XTConfig sharedManager] deviceInfo], @"keyword" : searchText, @"soType" : self.searchType};
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    [manager GET:associateUrl parameters:requestDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.associateTableView.associateArray = responseObject[@"data"];
        [self.associateTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [YYTHUD showPromptAddedTo:self.view withText:[error xtErrorMessage] withCompletionBlock:nil];
//        [self.searchTextfield resignFirstResponder];
    }];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldTextDidChange:(NSNotification *)notification {
    if([self.searchTextfield.text length] > 0) {
        self.clearButton.hidden = NO;
        [self requestSearchAssociateInfo];
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }else {
        self.clearButton.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.associateArray = nil;
            [self.associateTableView reloadData];
            self.associateTableView.alpha = 0.f;
        } completion:^(BOOL finished) {
        }];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if([textField.text length] > 0) {
        self.clearButton.hidden = NO;
        [self requestSearchAssociateInfo];
        [UIView animateWithDuration:0.3 animations:^{
            self.associateTableView.alpha = 1.f;
        } completion:^(BOOL finished) {
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.clearButton.hidden = YES;
        self.associateTableView.associateArray = nil;
        [self.associateTableView reloadData];
        self.associateTableView.alpha = 0.f;
    } completion:^(BOOL finished) {
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *searchText = [self.searchTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([searchText length] == 0) {
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"搜索内容不能为空" withCompletionBlock:nil];
        return NO;
    }
    self.clearButton.hidden = YES;
    [self switchSearchType:self.searchType];
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(self.associateTableView.alpha < 1.f) {
        [self.searchTextfield resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
