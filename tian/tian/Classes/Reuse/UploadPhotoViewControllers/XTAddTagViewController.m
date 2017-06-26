//
//  XTAddTagViewController.m
//  tian
//
//  Created by 曹亚云 on 15-6-16.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTAddTagViewController.h"
#import "YYTBarButtonItem.h"
#import "XTTabBarController.h"
#import "HKKTagWriteView.h"
#import "XTSubStore.h"
@interface XTAddTagViewController()
@property (nonatomic, strong) UIView *firstTagView;
@property (nonatomic, strong) UILabel *firstTagTitleLabel;
@property (nonatomic, strong) HKKTagWriteView *firstTagWriteView;

@property (nonatomic, strong) UIView *secondTagView;
@property (nonatomic, strong) UILabel *secondTagTitleLabel;
@property (nonatomic, strong) HKKTagWriteView *secondTagWriteView;

@property (nonatomic, assign) CGFloat tagScrollViewHeight;
@property (nonatomic, strong) YYTBarButtonItem *rightBarButtonItem;

@end

@implementation XTAddTagViewController
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
    // Do any additional setup after loading the view.
    /*
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    UIView *statusAndNavigationBarBgView = [UIView new];
    statusAndNavigationBarBgView.backgroundColor = UIColorFromRGB(0xececec);
    [self.view addSubview:statusAndNavigationBarBgView];
    [statusAndNavigationBarBgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(@-64);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];*/
    self.navigationItem.title = @"添加标签";
    YYTBarButtonItem *rightBaritem = [YYTBarButtonItem barItemWithImageName:@"upload_ture" target:self action:@selector(addTagWithUploadImage)];
    if (self.oldTags == nil) {
        rightBaritem.enabled = NO;
    }
    self.rightBarButtonItem = rightBaritem;
    self.navigationItem.rightBarButtonItem = rightBaritem;
    
    [self tagDisplayView];
    [self addTagView];
    
    if (self.type == XTAddTagTypeDefault) {
        [self tagScrollView];
        [self getTagData];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.oldTags == nil) {
        return;
    }
    for (NSString *tag in self.oldTags) {
        [self.tagWriteView addTagToLast:tag animated:YES];
    }
}
- (UIView *)tagDisplayView{
    if (!_tagDisplayView) {
        _tagDisplayView = [UIView new];
        _tagDisplayView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_tagDisplayView];
        
        [_tagDisplayView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(@8);
            make.left.equalTo(self.view).offset(@5);
            make.right.equalTo(self.view).offset(@-5);
            make.height.equalTo(@105);
        }];
        [self tagWriteView];
        [self tagCountLabel];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [_tagDisplayView addSubview:lineView];
        
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.right.bottom.equalTo(_tagDisplayView);
        }];
        
    }
    return _tagDisplayView;
}

- (HKKTagWriteView *)tagWriteView{
    if (!_tagWriteView) {
        _tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectZero withTagType:XTTagTypeVerticalText];
        _tagWriteView.backgroundColor = [UIColor clearColor];
        _tagWriteView.tagBackgroundColor = [UIColor clearColor];
        _tagWriteView.delegate = self;
        [_tagDisplayView addSubview:_tagWriteView];
        
        [_tagWriteView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_tagDisplayView).insets(UIEdgeInsetsMake(5, 5, 20, 5));
        }];
    }
    return _tagWriteView;
}

- (UILabel *)tagCountLabel{
    if (!_tagCountLabel) {
        _tagCountLabel = [UILabel new];
        _tagCountLabel.text = @"0/5";
        _tagCountLabel.font = [UIFont systemFontOfSize:10];
        _tagCountLabel.backgroundColor = [UIColor clearColor];
        _tagCountLabel.textColor = UIColorFromRGB(0x595959);
        [_tagDisplayView addSubview:_tagCountLabel];
        
        [_tagCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tagWriteView.bottom).offset(@5);
            make.right.equalTo(_tagWriteView);
            make.height.equalTo(@10);
        }];
    }
    return _tagCountLabel;
}

- (XTAddTagView *)addTagView{
    if (!_addTagView) {
        _addTagView = [XTAddTagView new];
        _addTagView.delegate = self;
        _addTagView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_addTagView];
        
        [_addTagView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tagDisplayView.bottom).offset(@0);
            make.left.equalTo(self.view).offset(@5);
            make.right.equalTo(self.view).offset(@-5);
            make.height.equalTo(@50);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColorFromRGB(0xececec);
        [_addTagView addSubview:lineView];
        
        [lineView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.right.bottom.equalTo(_addTagView);
        }];
    }
    return _addTagView;
}

- (UIScrollView *)tagScrollView{
    if (!_tagScrollView) {
        _tagScrollView = [UIScrollView new];
        _tagScrollView.backgroundColor = [UIColor clearColor];
        _tagScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tagScrollView];
        
        [_tagScrollView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addTagView.bottom).offset(@5);
            make.left.right.equalTo(_addTagView);
            make.bottom.equalTo(self.view).offset(@-5);
        }];
        [self firstTagView];
        [self secondTagView];
    }
    return _tagScrollView;
}

- (UIView *)firstTagView{
    if (!_firstTagView) {
        _firstTagView = [UIView new];
        [_tagScrollView addSubview:_firstTagView];
        [self firstTagTitleLabel];
        [self firstTagWriteView];
        
        [_firstTagView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tagScrollView);
            make.left.equalTo(@0);
            make.width.equalTo(SCREEN_SIZE.width-10);
            make.bottom.equalTo(_firstTagWriteView);
        }];
        
    }
    return _firstTagView;
}

- (UILabel *)firstTagTitleLabel{
    if (!_firstTagTitleLabel) {
        _firstTagTitleLabel = [UILabel new];
        _firstTagTitleLabel.backgroundColor = [UIColor clearColor];
        _firstTagTitleLabel.font = [UIFont systemFontOfSize:11];
        _firstTagTitleLabel.textColor = UIColorFromRGB(0x595959);
        _firstTagTitleLabel.text = @"热门标签";
        [_firstTagView addSubview:_firstTagTitleLabel];
        
        [_firstTagTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_firstTagView);
            make.height.equalTo(@20);
        }];
    }
    return _firstTagTitleLabel;
}

- (HKKTagWriteView *)firstTagWriteView{
    if (!_firstTagWriteView) {
        _firstTagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectZero withTagType:XTTagTypeClick];
        _firstTagWriteView.backgroundColor = [UIColor whiteColor];
        _firstTagWriteView.delegate = self;
        [_firstTagView addSubview:_firstTagWriteView];
        
        [_firstTagWriteView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstTagTitleLabel.bottom);
            make.left.right.equalTo(_firstTagView);
            make.height.equalTo(@0);
        }];
    }
    return _firstTagWriteView;
}

- (UIView *)secondTagView{
    if (!_secondTagView) {
        _secondTagView = [UIView new];
        [_tagScrollView addSubview:_secondTagView];
        [self secondTagTitleLabel];
        [self secondTagWriteView];
        
        [_secondTagView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstTagView.bottom);
            make.left.equalTo(@0);
            make.width.equalTo(SCREEN_SIZE.width-10);
            make.bottom.equalTo(_secondTagWriteView);
        }];
    }
    return _secondTagView;
}

- (UILabel *)secondTagTitleLabel{
    if (!_secondTagTitleLabel) {
        _secondTagTitleLabel = [UILabel new];
        _secondTagTitleLabel.backgroundColor = [UIColor clearColor];
        _secondTagTitleLabel.font = [UIFont systemFontOfSize:11];
        _secondTagTitleLabel.textColor = UIColorFromRGB(0x595959);
        _secondTagTitleLabel.text = @"常用标签";
        [_secondTagView addSubview:_secondTagTitleLabel];
        
        [_secondTagTitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_secondTagView);
            make.height.equalTo(@20);
        }];
    }
    return _secondTagTitleLabel;
}

- (HKKTagWriteView *)secondTagWriteView{
    if (!_secondTagWriteView) {
        _secondTagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectZero withTagType:XTTagTypeClick];
        _secondTagWriteView.backgroundColor = [UIColor whiteColor];
        _secondTagWriteView.delegate = self;
        [_secondTagView addSubview:_secondTagWriteView];
        
        [_secondTagWriteView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secondTagTitleLabel.bottom);
            make.left.right.equalTo(_secondTagView);
            make.height.equalTo(@0);
        }];
    }
    return _secondTagWriteView;
}

- (void)onClickAddTag:(UIButton *)addTagBtn{
    if ([_tagWriteView.tags count] < 5) {
        if (![_addTagView.tagTextField.text isEqualToString:@""]) {
            [_tagWriteView addTagToLast:_addTagView.tagTextField.text animated:YES];
            _tagCountLabel.text = [NSString stringWithFormat:@"%ld/5",[_tagWriteView.tags count]];
            _addTagView.tagTextField.text = @"";
            self.rightBarButtonItem.enabled = YES;
        }
    }else{
        [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"您最多可以添加5个标签" withCompletionBlock:nil];
    }
}

- (void)giveSearchKey:(NSString *)KeyStr{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    [subStore fetchTagWithKeyword:KeyStr
                             type:@"artist"
                  completionBlock:^(NSDictionary *tagItems, NSError *error) {
                      if (!error) {
                          _firstTagTitleLabel.text = @"搜索结果";
                          [_firstTagWriteView removeAllTags];
                          [_firstTagWriteView addTags:[tagItems objectForKey:@"data"]];
                          
                          _secondTagView.hidden = YES;
                      }
                  }];
}

- (void)giveDefaultTag{
    _secondTagView.hidden = NO;
    [self getTagData];
}

- (void)getTagData
{
    XTSubStore *subStore = [[XTSubStore alloc] init];
    [subStore fetchHotTagsWithCompletionBlock:^(NSArray *tagItems, NSError *error) {
        if (!error) {
            _firstTagTitleLabel.text = @"热门标签";
            [_firstTagWriteView removeAllTags];
            [_firstTagWriteView addTags:tagItems];
        }
    }];
    
    [subStore fetchUsedTagsWithCompletionBlock:^(NSArray *tagItems, NSError *error) {
        if (!error) {
            [_secondTagWriteView removeAllTags];
            [_secondTagWriteView addTags:tagItems];
        }
    }];
}

#pragma mark - HKKTagWriteViewDelegate
- (void)tagWriteViewDidEndEditing:(HKKTagWriteView *)view
{
    if (view == _firstTagWriteView) {
        [_firstTagWriteView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_firstTagTitleLabel.bottom);
            make.left.right.equalTo(_firstTagView);
            make.height.equalTo(_firstTagWriteView.tagHeight);
        }];
    }else if (view == _secondTagWriteView) {
        [_secondTagWriteView updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_secondTagTitleLabel.bottom);
            make.left.right.equalTo(_secondTagView);
            make.height.equalTo(_secondTagWriteView.tagHeight);
        }];
    }
    self.tagScrollViewHeight = _firstTagTitleLabel.xtheight+_firstTagWriteView.tagHeight+_secondTagTitleLabel.xtheight+ _secondTagWriteView.tagHeight;
    CGSize contentSize = self.tagScrollView.contentSize;
    contentSize.height = self.tagScrollViewHeight;
    self.tagScrollView.contentSize = contentSize;
    [self.tagScrollView layoutIfNeeded];
}

- (void)tagWriteView:(HKKTagWriteView *)view didMakeTag:(NSString *)tag
{
    NSLog(@"added tag = %@", tag);
    if (view == _tagWriteView) {
        self.rightBarButtonItem.enabled = YES;
        _tagCountLabel.text = [NSString stringWithFormat:@"%ld/5",[_tagWriteView.tags count]];
    }
}

- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag
{
    NSLog(@"removed tag = %@", tag);
    if (view == _tagWriteView) {
        _tagCountLabel.text = [NSString stringWithFormat:@"%ld/5",[_tagWriteView.tags count]];
        if ([_tagWriteView.tags count] == 0) {
            self.rightBarButtonItem.enabled = NO;
        }
    }
}

- (void)tagWriteView:(HKKTagWriteView *)view didSelectTag:(NSString *)tag
{
    if (view == _firstTagWriteView || view == _secondTagWriteView) {
        if ([_tagWriteView.tags count] < 5) {
            [_tagWriteView addTagToLast:tag animated:YES];
            _tagCountLabel.text = [NSString stringWithFormat:@"%ld/5",[_tagWriteView.tags count]];
            self.rightBarButtonItem.enabled = YES;
        }else{
            [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"您最多可以添加5个标签" withCompletionBlock:nil];
        }
    }
}

- (void)addTagWithUploadImage{
    NSMutableArray *tagsArray = [NSMutableArray arrayWithArray:_tagWriteView.tags];
    [[NSNotificationCenter defaultCenter] postNotificationName:AddTagNotification
                                                        object:tagsArray];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
