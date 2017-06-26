//
//  PhotoListTableViewCell.m
//  tian
//
//  Created by 曹亚云 on 15-5-25.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "PhotoListTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XTTextNumberControlView.h"
#import "XTLocalImageStoreManage.h"
@interface PhotoListTableViewCell()<UITextViewDelegate, XTTextNumberControlViewDelegate>
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *photoCountImageView;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation PhotoListTableViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Create a image view
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self photoImageView];
        [self lineView];
        [self photoDesTextView];
        [self countLabel];
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewEditChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:_photoDesTextView];*/
    }
    return self;
}

/*
- (void)click:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([_delegate respondsToSelector:@selector(clickPhotoAssetsViewCell:)]) {
        [_delegate clickPhotoAssetsViewCell:self];
    }
}*/

- (void)setAsset:(JKAssets *)asset {
    if (_asset != asset) {
        _asset = asset;
        
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                self.photoImageView.image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)setModel:(XTLocalPhotoModel *)model{
    if (_model != model) {
        _model = model;
        
        self.photoImageView.image = [[XTLocalImageStoreManage sharedLocalImageStoreManage] photoImageWithName:model.smallName];
        [self.photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.photoImageView setClipsToBounds:YES];
    }
}

- (void)setPhotoCount:(NSString *)photoCount{
    self.photoCountLabel.text = photoCount;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.backgroundColor = [UIColor clearColor];
        _photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImageView];
        
        [_photoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(@5);
            make.width.height.equalTo(@68);
        }];
        
        _photoCountImageView = [[UIImageView alloc] init];;
        _photoCountImageView.image = [UIImage imageNamed:@"upload_photoCount_bg"];

        [self.contentView addSubview:_photoCountImageView];
        [_photoCountImageView makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.width.equalTo(@26);
            make.right.equalTo(_photoImageView).offset(-2);
            make.bottom.equalTo(_photoImageView).offset(-2);
        }];
        
        _photoCountLabel = [UILabel new];
        _photoCountLabel.font = [UIFont systemFontOfSize:10];
        _photoCountLabel.backgroundColor = [UIColor clearColor];
        _photoCountLabel.textColor = UIColorFromRGB(0xffe707);
        _photoCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_photoCountLabel];
        
        [_photoCountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_photoCountImageView);
        }];
    }
    return _photoImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = UIColorFromRGB(0xececec);
        [self.contentView addSubview:_lineView];
        
        [_lineView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _lineView;
}

- (XTTextNumberControlView *)photoDesTextView {
    if (!_photoDesTextView) {
        _photoDesTextView = [[XTTextNumberControlView alloc] init];
        _photoDesTextView.backgroundColor = [UIColor clearColor];
        _photoDesTextView.returnKeyType = UIReturnKeyDone;
        _photoDesTextView.font = [UIFont systemFontOfSize:12];
        _photoDesTextView.placeHolder = @"在饭圈儿，描述和图图更配哦！";
        _photoDesTextView.count = 140;
        _photoDesTextView.countDelegate = self;
        [self.contentView addSubview:_photoDesTextView];
        [_photoDesTextView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(@5);
            make.right.equalTo(self).offset(@-5);
            make.left.equalTo(_photoImageView.right).offset(@5);
            make.height.equalTo(@53);
        }];
    }
    return _photoDesTextView;
}

- (UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.text = @"0/140";
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = UIColorFromRGB(0x595959);
        [self.contentView addSubview:_countLabel];
        
        [_countLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_photoDesTextView.bottom).offset(@5);
            make.right.equalTo(_photoDesTextView);
            make.height.equalTo(@10);
        }];
    }
    return _countLabel;
}

-(void)textNumberControlView:(XTTextNumberControlView *)textView
                numberOfText:(NSInteger)numberOfText
{
    _countLabel.text = [NSString stringWithFormat:@"%ld/140",numberOfText];
}

/*
// 监听文本改变
-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    NSString *toBeString = textView.text;
    
    for (UITextInputMode *mode in [UITextInputMode activeInputModes]) {
        NSLog(@"[UITextInputMode activeInputModes]:%@",[UITextInputMode activeInputModes]);
        NSLog(@"UITextInputMode:%@",[mode primaryLanguage]);
        NSString *lang = [mode primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            // 获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 140) {
                    textView.text = [toBeString substringToIndex:140];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                NSLog(@"输入的英文还没有转化为汉字的状态");
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > 140) {
                textView.text = [toBeString substringToIndex:140];
            }
        }
    }
    _countLabel.text = [NSString stringWithFormat:@"%ld/140",[textView.text length]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *new = [textView.text stringByReplacingCharactersInRange:range
                                                           withString:text];
    if ([text isEqualToString:@" "])
    {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return YES;
    }
    
    if (new.length > 140)
    {
        return  NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"removed tag = %@", textView);
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}*/

@end
