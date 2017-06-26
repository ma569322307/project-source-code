//
//  XTHeadPortraitView.m
//  tian
//
//  Created by 曹亚云 on 15-5-14.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHeadPortraitView.h"
#import "XTNoHighLightedButton.h"
@interface XTHeadPortraitView ()
@property (nonatomic, strong) UIImageView *headPortraitBgImageView;
@property (nonatomic, strong) UIImageView *VImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@end

@implementation XTHeadPortraitView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
        _headPortraitImageView.image = [UIImage imageNamed:@""];
        _headPortraitImageView.layer.cornerRadius = 47.5f;
        _headPortraitImageView.layer.masksToBounds = YES;
        [self addSubview:_headPortraitImageView];
        
        self.headPortraitButton = [XTNoHighLightedButton new];
        _headPortraitButton.backgroundColor = [UIColor clearColor];
        _headPortraitButton.layer.cornerRadius = 49.5f;
        _headPortraitButton.layer.masksToBounds = YES;
        [_headPortraitButton addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_headPortraitButton];
        
        self.VImageView = [UIImageView new];
        _VImageView.image = [UIImage imageNamed:@"HomePage_V"];
        _VImageView.hidden = YES;
        [self addSubview:_VImageView];
        
        self.nickNameLabel = [UILabel new];
        //_nickNameLabel.backgroundColor = [UIColor blackColor];
        _nickNameLabel.text = @"流苏的旧时光";
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.numberOfLines = 1;
        _nickNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nickNameLabel];
        
        self.levelLabel = [UILabel new];
        _levelLabel.backgroundColor = UIColorFromRGB(0xffe707);
        _levelLabel.layer.cornerRadius = 5.0f;
        _levelLabel.layer.masksToBounds = YES;
        _levelLabel.text = @"lv7";
        _levelLabel.textColor = UIColorFromRGB(0x4f242b);
        _levelLabel.textAlignment = NSTextAlignmentCenter;
        _levelLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_levelLabel];
        
        [self.headPortraitBgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.centerX.equalTo(self.centerX);
            make.size.equalTo(CGSizeMake(99, 99));
        }];
        
        [self.headPortraitImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.centerX.equalTo(self.centerX);
            make.size.equalTo(CGSizeMake(95, 95));
        }];
        
        [self.headPortraitButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@8);
            make.centerX.equalTo(self.centerX);
            make.size.equalTo(CGSizeMake(99, 99));
        }];
        
        [self.VImageView makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(18, 18));
            make.bottom.equalTo(self.headPortraitImageView);
            make.right.equalTo(self.headPortraitImageView).offset(@-5);
        }];
        
        [self.nickNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headPortraitImageView.bottom).offset(@5);
            make.centerX.equalTo(self.centerX);
        }];
        
        [self.levelLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nickNameLabel.centerY);
            make.left.equalTo(self.nickNameLabel.right).offset(@5);
            make.size.equalTo(CGSizeMake(30, 10));
        }];
    }
    return self;
}

- (void)fillUesrInformation:(XTUserAccountInfo *)user{
    __weak XTHeadPortraitView *wself = self;
    [self.headPortraitImageView sd_setImageWithURL:user.smallAvatarURL
                                  placeholderImage:[UIImage imageNamed:@"public_head_normal"]
                                           options:SDWebImageRetryFailed | SDWebImageLowPriority
                                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                          
                                      }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                          if (!error) {
                                              [wself.headPortraitImageView setImage:image];
                                              if (user.type == XTAccountFans) {
                                                  wself.VImageView.hidden = NO;
                                              }
                                          }
                                      }];
    self.nickNameLabel.text = user.nickname;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@",user.level];
}
-(void)headClick{
    NSLog(@"头像点击");
    // 点击头像发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userHomePageUpdateHeadImage" object:self.headPortraitButton];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    // for multiline UILabel's you need set the preferredMaxLayoutWidth
    // you need to do this after [super layoutSubviews] as the frames will have a value from Auto Layout at this point
    
    // stay tuned for new easier way todo this coming soon to Masonry
    
    
    // need to layoutSubviews again as frames need to recalculated with preferredLayoutWidth
}

@end
