//
//  XTTopicIndexHeaderView.m
//  tian
//
//  Created by huhuan on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicIndexHeaderView.h"
#import "XTHotLicksTopicsInfo.h"
#import "NSString+TextSize.h"
#import "UIImage+rn_Blur.h"
#import "UIImage+Capture.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTUserStore.h"
#import "NSString+TextSize.h"
#import "UIImageView+Custom.h"
#import "JKUtil.h"

@interface XTTopicIndexHeaderView ()

@property (nonatomic, weak  ) IBOutlet UIImageView  *headerImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView  *vIconImageView;
@property (nonatomic, weak  ) IBOutlet UIView       *blurBgView;
@property (nonatomic, weak  ) IBOutlet UILabel      *nameLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *levelLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *statusLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *descLabel;
@property (nonatomic, weak  ) IBOutlet UIScrollView *favoriteUserScrollView;
@property (nonatomic, weak  ) IBOutlet UIButton     *collectButton;
@property (nonatomic, strong) UIImageView           *moreImageView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *statusLabelWidthConstraint;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;

@property (nonatomic, strong) XTHotLicksTopicsInfo *topicInfo;

@property (nonatomic, assign) CGFloat favoriteUserHeaderWidth;


@end

@implementation XTTopicIndexHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 6.f;
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    self.favoriteUserHeaderWidth = SCREEN_SIZE.width > 320 ? 35 : 31.9;
    self.bottomLineHeightConstraint.constant = 0.5f;
}

- (void)configureViewWithTopicInfo:(XTHotLicksTopicsInfo *)topicInfo {
    self.topicInfo = topicInfo;
    [self.headerImageView an_setImageWithURL:topicInfo.user.bigAvatar];
    [self.contentImageView layoutIfNeeded];
    
    [self.contentImageView sd_setImageWithURL:topicInfo.image placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UIImage *resizeImage = [image subImage:CGRectMake(0., 0., image.size.width, image.size.width-70)];
        [self.contentImageView setImage:resizeImage];
        
    }];
    
    if ([UIDevice currentDevice].systemVersion.doubleValue > 7.9 && [[self.blurBgView subviews] count] == 0) {
        
        UIView *blurBackView = [[UIView alloc] init];
        blurBackView.backgroundColor = [UIColor whiteColor];
        blurBackView.alpha = 0.2;
        [self.blurBgView addSubview:blurBackView];
        
        [blurBackView updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
        view.alpha = 0.7;
        [self.blurBgView addSubview:view];
        self.blurBgView.backgroundColor = [UIColor clearColor];
        self.blurBgView.alpha = 1.f;
        [view updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0., 0., 0., 0.));
        }];
    }

    self.nameLabel.text = topicInfo.user.nickName;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@",@(topicInfo.user.level)];

    NSString *statusString = [NSString stringWithFormat:@"浏览:%@ 讨论:%@ 收藏:%@",@(topicInfo.viewCount), @(topicInfo.postCount), @(topicInfo.favoritesCount)];
    
    NSRange viewerRange = [statusString rangeOfString:[@(topicInfo.viewCount) stringValue]];
    NSRange postRange = [statusString rangeOfString:[@(topicInfo.postCount) stringValue]];
    NSRange collectRange = [statusString rangeOfString:[@(topicInfo.favoritesCount) stringValue]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:statusString];
    NSDictionary *attributeDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:11]};
    
    [attributedString addAttributes:attributeDic range:viewerRange];
    [attributedString addAttributes:attributeDic range:postRange];
    [attributedString addAttributes:attributeDic range:collectRange];
    
    self.statusLabel.attributedText = attributedString;
    
    float statusWidth = [statusString textWidthWithFontSize:11 isBold:NO andHeight:12];
    self.statusLabelWidthConstraint.constant = statusWidth;
    
    self.descLabel.text = topicInfo.topicDescription;
    if(topicInfo.user.vuser) {
        self.vIconImageView.hidden = NO;
    }else {
        self.vIconImageView.hidden = YES;
    }
    
    [self layoutIfNeeded];
    [self.descLabel layoutIfNeeded];

    float nameWidth = [topicInfo.user.nickName textWidthWithFontSize:12 isBold:NO andHeight:self.nameLabel.frame.size.height];
    self.nameLabelWidthConstraint.constant = nameWidth+1;
    float textHeight = [topicInfo.topicDescription textHeightWithFontSize:12 isBold:NO andWidth:self.descLabel.frame.size.width];
    CGRect selfFrame = self.frame;
    selfFrame.size.height = 300 + textHeight-14;
    self.frame = selfFrame;
    
    [self adjustCollectButtonStatus];
    
    for(UIView *v in self.favoriteUserScrollView.subviews) {
        [v removeFromSuperview];
    }
    
    [self.favoriteUserScrollView layoutIfNeeded];

    self.favoriteUserHeaderWidth = SCREEN_SIZE.width > 320 ? 35 : 31.9;
//    float favoriteUserHeaderGap = ((SCREEN_SIZE.width-67)-(7*favoriteUserHeaderWidth))/6;
    
    if([topicInfo.favoriteUsers count] > 0) {
        for(int i = 0; i < [topicInfo.favoriteUsers count]; i++) {

            XTUserInfo *userInfo = topicInfo.favoriteUsers[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*(self.favoriteUserHeaderWidth+5), 0, self.favoriteUserHeaderWidth, self.favoriteUserHeaderWidth)];
//            imageView.layer.masksToBounds = YES;
//            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+100;
            [imageView showHeaderWithUrl:userInfo.bigAvatar];
            
            [self.favoriteUserScrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
            [imageView addGestureRecognizer:tap];
            
            if(i == 4) {
                break;
            }
        }
        
        if(topicInfo.favoritesCount >= 5) {
            self.moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake((4+1)*(self.favoriteUserHeaderWidth+5), (float)(self.favoriteUserHeaderWidth-27)/2.f, 31, 27)];
            [self.moreImageView setImage:[UIImage imageNamed:@"topic_count_bg"]];
            
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(3., 0., self.moreImageView.frame.size.width-3, self.moreImageView.frame.size.height)];
            countLabel.textAlignment = NSTextAlignmentCenter;
            countLabel.backgroundColor = [UIColor clearColor];
            countLabel.textColor = [JKUtil getColor:@"4f242b"];
            countLabel.font = [UIFont boldSystemFontOfSize:10.f];
            countLabel.text = [NSString stringWithFormat:@"%@",@(topicInfo.favoritesCount)];
            [self.moreImageView addSubview:countLabel];
            
            [self.favoriteUserScrollView addSubview:self.moreImageView];
        }else {
            if(self.moreImageView.superview) {
                [self.moreImageView removeFromSuperview];
            }
        }
    }
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];
    
    self.collectButton.userInteractionEnabled = YES;
    
}

- (void)headerDisappearAnimation:(UIView *)view completion:(void (^)())completion {

    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
        view.frame = CGRectMake(view.center.x, view.center.y, 0, 0);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        if(completion) {
            completion();
        }
    }];

}

- (void)headerAppearAnimation:(UIView *)view completion:(void (^)())completion{
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
        view.frame = CGRectMake(0, 0, self.favoriteUserHeaderWidth, self.favoriteUserHeaderWidth);
        
    } completion:^(BOOL finished) {
        if(completion) {
            completion();
        }
    }];
    
}

- (void)headerMoveAnimation:(NSInteger)moveIndex toLeft:(BOOL)left completion:(void (^)())completion {
    
    CGFloat orignalOffsetX = left ? -self.favoriteUserHeaderWidth-5 : self.favoriteUserHeaderWidth+5;
    for (NSUInteger i = moveIndex; i < (left ? self.topicInfo.favoriteUsers.count+1 : self.topicInfo.favoriteUsers.count); i++) {
        UIView *view_i = [self.favoriteUserScrollView viewWithTag:100+i];
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
            view_i.frame = CGRectMake(CGRectGetMinX(view_i.frame) + orignalOffsetX, CGRectGetMinY(view_i.frame), self.favoriteUserHeaderWidth, self.favoriteUserHeaderWidth);
        } completion:^(BOOL finished) {
            if(i == moveIndex && completion) {
                completion();
            }
        }];
    }
    
}

- (void)resetHeaderTag {
    for (int i = 0; i < [[self.favoriteUserScrollView subviews] count]; i++) {
        UIImageView *imageView = [self.favoriteUserScrollView subviews][i];
        imageView.tag = i+100;
    }
}

- (void)insertFavoriteUserWithAnimate:(NSInteger)index {
    
    self.collectButton.userInteractionEnabled = NO;
    
    XTUserInfo *userInfo = self.topicInfo.favoriteUsers[index];

    if([self.topicInfo.favoriteUsers count] > 5) {

        UIView *view = [self.favoriteUserScrollView viewWithTag:100+4];
        [view removeFromSuperview];
    }
    
    [self headerMoveAnimation:index toLeft:NO completion:^{
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.favoriteUserHeaderWidth/2, self.favoriteUserHeaderWidth/2, 0, 0)];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100;
        [imageView showHeaderWithUrl:userInfo.bigAvatar];
        [self.favoriteUserScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
        [imageView addGestureRecognizer:tap];
        
        [self headerAppearAnimation:imageView completion:^{
            [self configureViewWithTopicInfo:self.topicInfo];
        }];
        
    }];

}

- (void)removeFavoriteUserWithAnimateAtIndex:(NSInteger)index {
    
    self.collectButton.userInteractionEnabled = NO;
    
    UIView *removeView = [self.favoriteUserScrollView viewWithTag:100+index];
    
    if([self.topicInfo.favoriteUsers count] == 5) {
        XTUserInfo *userInfo = [self.topicInfo.favoriteUsers lastObject];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5*(self.favoriteUserHeaderWidth+5), 0, self.favoriteUserHeaderWidth, self.favoriteUserHeaderWidth)];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100+5;
        [imageView showHeaderWithUrl:userInfo.bigAvatar];
        [self.favoriteUserScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
        [imageView addGestureRecognizer:tap];

    }
    
    [self headerDisappearAnimation:removeView completion:^{
        [self headerMoveAnimation:index+1 toLeft:YES completion:^{
             [self configureViewWithTopicInfo:self.topicInfo];
        }];
    }];

}

- (void)adjustCollectButtonStatus {
    if(self.topicInfo.favorited) {
        [self.collectButton setImage:[UIImage imageNamed:@"HotLicks_collect_sel"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"HotLicks_collect_white"] forState:UIControlStateHighlighted];
    }else {
        [self.collectButton setImage:[UIImage imageNamed:@"HotLicks_collect_white"] forState:UIControlStateNormal];
        [self.collectButton setImage:[UIImage imageNamed:@"HotLicks_collect_sel"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)collectionClick:(id)sender {
    self.collectButton.enabled = NO;
    if(self.topicInfo.favorited) {
        self.topicInfo.favorited = NO;
        [self adjustCollectButtonStatus];
        [self removeCollectCount];
    }else {
        self.topicInfo.favorited = YES;
        [self adjustCollectButtonStatus];
        [self addCollectCount];
    }
    if(self.collectClickBlock) {
        self.collectClickBlock(self.topicInfo.favorited);
    }
}

- (void)addCollectCount {
    self.topicInfo.favoritesCount += 1;
    NSMutableArray *tempUserArray = [self.topicInfo.favoriteUsers mutableCopy];
    XTUserInfo *userInfo = [[XTUserInfo alloc] init];
    userInfo.uid = [[XTUserStore sharedManager].user.userID longLongValue];
    userInfo.bigAvatar = [XTUserStore sharedManager].user.smallAvatarURL;
    [tempUserArray insertObject:userInfo atIndex:0];
    self.topicInfo.favoriteUsers = [tempUserArray copy];
    [self insertFavoriteUserWithAnimate:0];
//    [self configureViewWithTopicInfo:self.topicInfo];
    
}

- (void)removeCollectCount {
    self.topicInfo.favoritesCount -= 1;
    NSMutableArray *tempUserArray = [self.topicInfo.favoriteUsers mutableCopy];
    NSInteger index = 0;
    for(XTUserInfo *userInfo in tempUserArray) {
        if(userInfo.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
            [tempUserArray removeObject:userInfo];
            break;
        }
        index ++;
    }
    self.topicInfo.favoriteUsers = [tempUserArray copy];
    [self removeFavoriteUserWithAnimateAtIndex:index];
//    [self configureViewWithTopicInfo:self.topicInfo];
}

- (void)resetCollectStatusWithResponse:(BOOL)isSuccess collectMode:(BOOL)needCollect {
    self.collectButton.enabled = YES;
    if(!isSuccess) {
        if(needCollect) {
            self.topicInfo.favorited = YES;
            [self adjustCollectButtonStatus];
            [self addCollectCount];
        }else {
            self.topicInfo.favorited = NO;
            [self adjustCollectButtonStatus];
            [self removeCollectCount];
        }
    }

}

- (void)handleSingleTap:(id)sender {
    if(self.topicInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.topicInfo.user.uid)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)clickImageView:(UITapGestureRecognizer *)gesture {
    UIImageView *headerImageView = (UIImageView *)gesture.view;
    XTUserInfo *userInfo = self.topicInfo.favoriteUsers[headerImageView.tag-100];
    
    if(userInfo.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(userInfo.uid)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

@end
