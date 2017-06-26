//
//  XTVSpreadTableHeaderView.m
//  tian
//
//  Created by huhuan on 15/7/7.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTVSpreadTableViewHeader.h"
#import "XTUserInfo.h"
#import "XTHotLicksRecsInfo.h"
#import "JKUtil.h"
#import "NSString+TextSize.h"
#import "XTHTTPRequestOperationManager.h"

@interface XTVSpreadTableViewHeader ()

@property (nonatomic, weak  ) IBOutlet UIView       *bgView;
@property (nonatomic, weak  ) IBOutlet UIImageView  *headerImageView;
@property (nonatomic, weak  ) IBOutlet UIButton     *followButton;
@property (nonatomic, weak  ) IBOutlet UILabel      *descLabel;
@property (nonatomic, weak  ) IBOutlet UIScrollView *medalsScrollView;
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UILabel      *levelLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLineHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;

@property (nonatomic, strong) XTUserInfo *headerUserInfo;
@property (nonatomic, strong) XTHotLicksRecsInfo *recsInfo;

@end

@implementation XTVSpreadTableViewHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2.f;
    self.topLineHeightConstraint.constant = 0.5;
    self.bottomLineHeightConstraint.constant = 0.5;
}

+ (XTVSpreadTableViewHeader *)spreadTableViewHeader {
    XTVSpreadTableViewHeader *headerView = [[NSBundle mainBundle] loadNibNamed:@"XTVSpreadTableViewHeader" owner:self options:nil][0];
    headerView.frame = CGRectMake(0., 0., SCREEN_SIZE.width, 195);
    return headerView;
}

- (IBAction)followClick:(id)sender {
    if (self.headerUserInfo.follow) {
        //已关注则取消关注
        self.headerUserInfo.follow = NO;
        [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(self.headerUserInfo.uid)]
                        andRequestIdName:@"uid"
                           andApiAddress:@"friendships/delete.json"];
        
    } else {
        //未关注则关注
        self.headerUserInfo.follow = YES;
        [self requestFollowApiWithUserId:[NSString stringWithFormat:@"%@",@(self.headerUserInfo.uid)]
                        andRequestIdName:@"uid"
                           andApiAddress:@"friendships/create.json"];
    }
    [self adjustButtonStatus:self.headerUserInfo.follow];
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel                 = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font            = [UIFont systemFontOfSize:13.f];
        _nameLabel.textColor       = [JKUtil getColor:@"595959"];
        _nameLabel.lineBreakMode   = NSLineBreakByWordWrapping;

    }
    return _nameLabel;
}

- (UILabel *)levelLabel {
    if(!_levelLabel) {
        _levelLabel                     = [[UILabel alloc] init];
        _levelLabel.backgroundColor     = [JKUtil getColor:@"fee410"];
        _levelLabel.font                = [UIFont boldSystemFontOfSize:10.f];
        _levelLabel.textColor           = [JKUtil getColor:@"4f242b"];
        _levelLabel.textAlignment       = NSTextAlignmentCenter;
        _levelLabel.layer.masksToBounds = YES;
        _levelLabel.layer.cornerRadius  = 6.f;
        
    }
    return _levelLabel;
}

- (void)configureHeaderWithUserInfo:(XTUserInfo *)userInfo
                        andRecsInfo:(XTHotLicksRecsInfo *)recsInfo {

    self.headerUserInfo = userInfo;
    self.recsInfo = recsInfo;
    [self.headerImageView an_setImageWithURL:userInfo.bigAvatar];
    [self adjustButtonStatus:userInfo.follow];
    
    [self.bgView addSubview:self.nameLabel];
    [self.bgView addSubview:self.levelLabel];
    
    //配置姓名和等级Label
    self.nameLabel.text  = userInfo.nickName;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@",@(userInfo.level)];
    float nameWidth      = [userInfo.nickName textWidthWithFontSize:13 isBold:NO andHeight:16];
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(9);
        make.centerY.equalTo(self.headerImageView);
        make.width.equalTo(nameWidth);
        make.height.equalTo(16);
    }];
    
    [self.levelLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(2);
        make.centerY.equalTo(self.nameLabel);
        make.width.equalTo(25);
        make.height.equalTo(15);
    }];
    
    //配置详细描述Label
    [self.descLabel layoutIfNeeded];

    float descHeight = [recsInfo.content textHeightWithFontSize:13.f isBold:NO andWidth:self.descLabel.frame.size.width];
    
    self.descLabel.text = recsInfo.content;
    
    //配置奖章ScrollView
    [self.medalsScrollView layoutIfNeeded];
    float medalWidth = SCREEN_SIZE.width > 320 ? 35 : 31.9;
    float medalGap = 5;
    
    if([userInfo.medals count] > 0) {
        for(int i = 0; i < [userInfo.medals count]; i++) {
            
            NSDictionary *medal              = userInfo.medals[i];
            UIImageView *imageView           = [[UIImageView alloc]initWithFrame:CGRectMake(i*(medalWidth+medalGap), 0, medalWidth, medalWidth)];
            imageView.layer.masksToBounds    = YES;
            imageView.layer.cornerRadius     = imageView.frame.size.width/2;
            imageView.userInteractionEnabled = YES;
            imageView.tag                    = i+100;
            [imageView an_setImageWithURL:medal[@"imgUrl"] placeholderImage:nil];
            [self.medalsScrollView addSubview:imageView];
            
        }
    }
    
    self.frame = CGRectMake(0., 0., SCREEN_SIZE.width, 180 + descHeight);
    
}

- (void)adjustButtonStatus:(BOOL)isFollowed {
    if (isFollowed) {
        [self.followButton setBackgroundColor:UIColorFromRGB(0xc2c3c4)];
        [self.followButton setTitleColor:[UIColor whiteColor]
                                  forState:UIControlStateNormal];
        [self.followButton setTitle:@"取消关注"
                             forState:UIControlStateNormal];
    } else {
        [self.followButton setBackgroundColor:UIColorFromRGB(0xfbe510)];
        [self.followButton setTitleColor:UIColorFromRGB(0x4f242b)
                                  forState:UIControlStateNormal];
        [self.followButton setTitle:@"关注"
                             forState:UIControlStateNormal];
    }
}

- (void)requestFollowApiWithUserId:(NSString *)userId andRequestIdName:(NSString *)name  andApiAddress:(NSString *)apiAddress {
    
    NSDictionary *parameters = @{
                                 name: userId,
                                 };
    XTHTTPRequestOperationManager *manager = [XTHTTPRequestOperationManager sharedManager];
    
    [manager POST:apiAddress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
