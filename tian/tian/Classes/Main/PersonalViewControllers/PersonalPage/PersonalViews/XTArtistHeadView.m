//
//  XTArtistHeadView.m
//  tian
//
//  Created by 曹亚云 on 15-6-13.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTArtistHeadView.h"
@interface XTArtistHeadView()
@property (nonatomic, strong) UIImageView *headPortraitBgImageView;
@property (nonatomic, strong) UIImageView *headPortraitImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@end

@implementation XTArtistHeadView

- (id)init
{
    self = [super init];
    if (self) {
        self.headPortraitBgImageView = [UIImageView new];
        _headPortraitBgImageView.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        _headPortraitBgImageView.layer.cornerRadius = 49.5f;
        _headPortraitBgImageView.layer.masksToBounds = YES;
        [self addSubview:_headPortraitBgImageView];
        
        self.headPortraitImageView = [UIImageView new];
        _headPortraitImageView.image = [UIImage imageNamed:@"HomePage_headImage_default"];
        _headPortraitImageView.layer.cornerRadius = 47.5f;
        _headPortraitImageView.layer.masksToBounds = YES;
        [self addSubview:_headPortraitImageView];
        
        self.nickNameLabel = [UILabel new];
        //_nickNameLabel.backgroundColor = [UIColor blackColor];
        _nickNameLabel.text = @"流苏的旧时光";
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.numberOfLines = 1;
        _nickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nickNameLabel];
        
        self.manitoLabelAndBtnView = [XTLabelAndBtnView new];
        _manitoLabelAndBtnView.titleLabel.text = @"舔神:";
        _manitoLabelAndBtnView.contentLabel.text = @"545454";
        [_manitoLabelAndBtnView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_manitoLabelAndBtnView];
        
        self.fansLabelAndBtnView = [XTLabelAndBtnView new];
        _fansLabelAndBtnView.titleLabel.text = @"粉丝:";
        _fansLabelAndBtnView.contentLabel.text = @"545454";
        [_fansLabelAndBtnView.clickButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_fansLabelAndBtnView];
        
        [self.headPortraitBgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@72);
            make.centerX.equalTo(self.centerX);
            make.size.equalTo(CGSizeMake(99, 99));
        }];
        
        [self.headPortraitImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@74);
            make.centerX.equalTo(self.centerX);
            make.size.equalTo(CGSizeMake(95, 95));
        }];
        
        [self.nickNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headPortraitImageView.bottom).offset(@5);
            make.height.equalTo(@10);
            make.centerX.equalTo(self.centerX);
        }];
        
        [self.manitoLabelAndBtnView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nickNameLabel.bottom).offset(@5);
            make.right.equalTo(self.headPortraitImageView.centerX).offset(@-5);
            make.height.equalTo(@20);
        }];
        
        [self.fansLabelAndBtnView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.manitoLabelAndBtnView);
            make.left.equalTo(self.headPortraitImageView.centerX).offset(@5);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)clickButton:(UIButton *)btn{
    if (self.delegate) {
        [_delegate onClickBtn:btn];
    }
}

+ (CGFloat)calculateViewHeight{
    CGFloat height = 155.0 + 64.0;
    return height;
}

- (void)fillUesrInformation:(XTOrderArtist *)artistInfo{
    __weak XTArtistHeadView *wself = self;
    [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:artistInfo.bigAvatar]
                                  placeholderImage:[UIImage imageNamed:@"public_head_normal"]
                                           options:SDWebImageRetryFailed | SDWebImageLowPriority
                                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                              
                                          }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                              if (!error) {
                                                  [wself.headPortraitImageView setImage:image];
                                              }
                                          }];
    _nickNameLabel.text = artistInfo.artistName;
    _manitoLabelAndBtnView.contentLabel.text = [NSString stringWithFormat:@"%d",artistInfo.bigvNum];
    _fansLabelAndBtnView.contentLabel.text = [NSString stringWithFormat:@"%d",artistInfo.subNum];
}

@end
