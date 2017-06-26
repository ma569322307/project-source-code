//
//  XTPostTableViewCell.m
//  tian
//
//  Created by huhuan on 15/7/2.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTPostTableViewCell.h"
#import "XTPostInfo.h"
#import "XTImageInfo.h"
#import "NSString+TextSize.h"
#import "UIImage+Capture.h"
#import "NSString+TimeReversal.h"
#import "UIImage+Size.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTBigImageViewController.h"
#import "XTBigImgPresentAnimation.h"
#import "XTBigImgDismissAnimation.h"
#import "XTUserStore.h"
#import "XTTopicIndexViewController.h"
#import "SDWebImageManager.h"

@interface XTPostTableViewCell () <XTBigImageViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, weak  ) IBOutlet UIView       *bgView;
@property (nonatomic, weak  ) IBOutlet UIImageView  *headerImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView  *vIconImageView;
@property (nonatomic, weak  ) IBOutlet UILabel      *nameLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *levelLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *statusLabel;
@property (nonatomic, weak  ) IBOutlet UILabel      *statusTopicLabel;
@property (nonatomic, weak  ) IBOutlet UIImageView  *topImageView;
@property (nonatomic, weak  ) IBOutlet UILabel      *timeLabel;
@property (nonatomic, weak  ) IBOutlet UIImageView  *contentImageView;
@property (nonatomic, weak  ) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) IBOutlet UIImageView  *contentGifIconImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView  *commentIconImageView;
@property (nonatomic, weak  ) IBOutlet UILabel      *commentLabel;
@property (nonatomic, weak  ) IBOutlet UIImageView  *likeIconImageView;
@property (nonatomic, weak  ) IBOutlet UILabel      *likeLabel;
@property (nonatomic, weak  ) IBOutlet UIButton     *moreButton;
@property (nonatomic, weak  ) IBOutlet UIView       *seperatorLine;

@property (nonatomic, strong) XTBigImgPresentAnimation *bigImgPresentAnimation;

@property (nonatomic, strong) XTBigImgDismissAnimation *bigImgDismissAnimation;

@property (nonatomic, strong) XTPostInfo *postInfo;

@end

@implementation XTPostTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    
    [self layoutCell];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    
    self.levelLabel.layer.masksToBounds = YES;
    self.levelLabel.layer.cornerRadius = 6.f;
    
    self.statusTopicLabel.layer.masksToBounds = YES;
    self.statusTopicLabel.layer.cornerRadius = 7.f;
}

-(XTBigImgPresentAnimation *)bigImgPresentAnimation{
    if (!_bigImgPresentAnimation) {
        _bigImgPresentAnimation = [XTBigImgPresentAnimation new];
    }
    return _bigImgPresentAnimation;
}

-(XTBigImgDismissAnimation *)bigImgDismissAnimation{
    if (!_bigImgDismissAnimation) {
        _bigImgDismissAnimation = [XTBigImgDismissAnimation new];
    }
    return _bigImgDismissAnimation;
}

- (void)configureCell:(XTPostInfo *)postModel andCellStyle:(XTTopicTableViewCellStyle)cellStyle {
    
    self.postInfo = postModel;
    
    [self.headerImageView an_setImageWithURL:postModel.user.bigAvatar];
    self.nameLabel.text = postModel.user.nickName;
    self.levelLabel.text = [NSString stringWithFormat:@"lv%@", @(postModel.user.level)];
    
    NSString *createTime = [NSString diffTimestamp:postModel.created];
    self.timeLabel.text = createTime;
    
    if(postModel.user.vuser) {
        self.vIconImageView.hidden = NO;
    }else {
        self.vIconImageView.hidden = YES;
    }
    
    self.statusLabel.text =postModel.postDescription;
    if(postModel.top) {
        self.topImageView.hidden = NO;
    }else {
        self.topImageView.hidden = YES;
    }
    self.commentLabel.text = [NSString stringWithFormat:@"%@", @(postModel.commentCount)];
    self.likeLabel.text = [NSString stringWithFormat:@"%@", @(postModel.commendCount)];
    
    float nameWidth = [postModel.user.nickName textWidthWithFontSize:12 isBold:YES andHeight:16];
    float timeWidth = [createTime textWidthWithFontSize:11 isBold:NO andHeight:12];
    
    float imageAreaWidth = 0.f;
    float imageAreaHeight = 0.f;
    float statusWidth = 0.f;
    
    self.statusTopicLabel.hidden = YES;
    if([postModel.type length] > 0) {
        NSString *descStr = postModel.postDescription;
        if ([postModel.type isEqualToString:@"favorite"]) {
            descStr = @"收藏了图片";
        }else if ([postModel.type isEqualToString:@"post"]) {
            
            descStr = @"参与了话题";
            self.statusTopicLabel.text = [NSString stringWithFormat:@"#%@#",postModel.topic.title];
            self.statusTopicLabel.hidden = NO;
            statusWidth = 60.f;
            
            float statusTopicTitleWidth = [self.statusTopicLabel.text textWidthWithFontSize:14.f isBold:NO andHeight:15.f];
            [self.statusTopicLabel updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(statusTopicTitleWidth);
            }];
            
        }else if ([postModel.type isEqualToString:@"pic"]) {
            descStr = @"上传了";
        }else if ([postModel.type isEqualToString:@"status"]) {
            if(postModel.picCount > 1 || [postModel.images count] > 1) {
                descStr = [NSString stringWithFormat:@"上传了（%@张）",@(postModel.picCount > 1 ? : [postModel.images count])];
            }else {
                descStr = @"上传了";
            }
            
        }
        self.statusLabel.text = descStr;
        
    }
    
    //分别隐藏控件
    if(cellStyle == XTTopicTableViewCellStyleIndexFollow) {
        self.moreButton.hidden = YES;
        
        self.commentIconImageView.hidden = YES;
        self.commentLabel.hidden = YES;
        self.likeIconImageView.hidden = YES;
        self.likeLabel.hidden = YES;

        [self.statusLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(@2);
            make.height.equalTo(@15);
            if(statusWidth > 0) {
                make.width.equalTo(statusWidth);
            }else {
                make.right.offset(-10);
            }
        }];
        
    }else if(cellStyle == XTTopicTableViewCellStyleHotlick) {
        self.moreButton.hidden = NO;
        
        self.commentIconImageView.hidden = NO;
        self.commentLabel.hidden = NO;
        self.likeIconImageView.hidden = NO;
        self.likeLabel.hidden = NO;

        [self.statusLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(@2);
            make.height.equalTo(@15);
            if(statusWidth > 0) {
                make.width.equalTo(statusWidth);
            }else {
                make.right.offset(-10);
            }
        }];
        
    }else if(cellStyle == XTTopicTableViewCellStyleOwn) {
        self.moreButton.hidden = YES;
        
        self.commentIconImageView.hidden = YES;
        self.commentLabel.hidden = YES;
        self.likeIconImageView.hidden = YES;
        self.likeLabel.hidden = YES;
        
        [self.statusLabel remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(@2);
            make.height.equalTo(@15);
            if(statusWidth > 0) {
                make.width.equalTo(statusWidth);
            }else {
                make.right.offset(-10);
            }
        }];
        
    }

    if([postModel.images count] == 0) {
        imageAreaWidth = 0;
        imageAreaHeight = 0;
        self.contentImageView.hidden = YES;
        self.contentScrollView.hidden = YES;
        
        [self.contentImageView remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.contentScrollView remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
    }else if([postModel.images count] == 1) {
        self.contentImageView.hidden = NO;
        self.contentScrollView.hidden = YES;
        
        XTImageInfo *imageInfo = postModel.images[0];
        
        CGFloat maxWidth = ((SCREEN_SIZE.width - 17 - 6*2 - 55)/3.0f)*2+6;
        CGFloat maxHeight = 200.f;
        
        if(imageInfo.width >= imageInfo.height) {
            imageAreaWidth = maxWidth;
            imageAreaHeight = imageInfo.height/imageInfo.width*imageAreaWidth;
        }else if (imageInfo.width < imageInfo.height) {
            imageAreaHeight = maxHeight;
            imageAreaWidth = imageInfo.width/imageInfo.height*imageAreaHeight;;
        }
        
        int i = arc4random() % 6+1 ;
        NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%@",@(i)];
        
        if([imageInfo.url.absoluteString hasSuffix:@".gif"]) {
            self.contentGifIconImageView.hidden = NO;
        }else {
            self.contentGifIconImageView.hidden = YES;
        }
        [self.contentImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentImageView setClipsToBounds:YES];
        [self.contentImageView an_setImageWithURL:imageInfo.url placeholderImage:[UIImage imageNamed:placeholderImageName] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        
//        if ([[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:imageInfo.url.absoluteString]) {
//            
//            [self.contentImageView setImage:[[[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imageInfo.url.absoluteString] scaleImageWithsize:CGSizeMake(imageAreaWidth*2, imageAreaHeight*2)]];
//        }else {
//            [self.contentImageView sd_setImageWithURL:imageInfo.url placeholderImage:[UIImage imageNamed:placeholderImageName] options:SDWebImageLowPriority | SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                if(image) {
//                    [self.contentImageView setImage:[image scaleImageWithsize:CGSizeMake(imageAreaWidth*2, imageAreaHeight*2)]];
//                    
//                    [self.contentImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
//                    [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
//                    [self.contentImageView setClipsToBounds:YES];
//                    self.contentImageView.alpha = 0.0;
//                    [UIView animateWithDuration:1.0f
//                                          delay:0
//                                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction
//                                     animations:^{
//                                         self.contentImageView.alpha = 1.0;
//                                     }
//                                     completion:nil];
//                }
//            }];
//        }
        
        UIView *view = nil;
        if(cellStyle == XTTopicTableViewCellStyleHotlick) {
            view = self.headerImageView;
        }else {
            view = self.statusLabel;
        }
        
        [self.contentImageView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).offset(@1);
            make.top.equalTo(view.mas_bottom).offset(@5);
            make.width.equalTo(imageAreaWidth);
            make.height.equalTo(imageAreaHeight);
        }];
        
        [self.contentScrollView remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        self.contentImageView.tag = 100;
        self.contentImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
        [self.contentImageView addGestureRecognizer:tap];
        
    }else if([postModel.images count] > 1) {
        self.contentImageView.hidden = YES;
        self.contentScrollView.hidden = NO;
        for(UIView *v in [self.contentScrollView subviews]) {
            [v removeFromSuperview];
        }
        
        float imageWidth = (SCREEN_SIZE.width - 17 - 6*2 - 55)/3.0f;
        
        imageAreaHeight = (([postModel.images count]-1)/3+1)*imageWidth+(([postModel.images count]-1)/3)*6;
        
        for (int i = 0; i < postModel.images.count; i++) {
            if(i >= 9) {
                break;
            }
            NSString *placeholderImageName = [NSString stringWithFormat:@"placeholderImage%@",@(i%6+1)];
            XTImageInfo *imageInfo = postModel.images[i];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i%3*(imageWidth+6), i/3*(imageWidth+6), imageWidth, imageWidth)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i+100;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;

            [imageView an_setImageWithURL:imageInfo.url
                         placeholderImage:[UIImage imageNamed:placeholderImageName]
                                  options:SDWebImageLowPriority | SDWebImageRetryFailed];
            [self.contentScrollView addSubview:imageView];
            
            
            if([imageInfo.url.absoluteString hasSuffix:@".gif"]) {
                UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth-21.f, imageWidth-15.f, 21.f, 15.f)];
                [gifImageView setImage:[UIImage imageNamed:@"gifIcon"]];
                [imageView addSubview:gifImageView];

            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImageView:)];
            [imageView addGestureRecognizer:tap];
        }
        
        UIView *view = nil;
        if(cellStyle == XTTopicTableViewCellStyleHotlick) {
            view = self.headerImageView;
        }else {
            view = self.statusLabel;
        }
        
        [self.contentScrollView remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerImageView.mas_right).offset(@1);
            make.top.equalTo(view.mas_bottom).offset(@5);
            make.right.offset(@-8);
            make.height.equalTo(imageAreaHeight);
        }];
        
        [self.contentImageView remakeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
    }
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nameWidth);
    }];
    
    [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(timeWidth);
    }];
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *headerSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleHeaderSingleTap:)];
    headerSingleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:headerSingleTap];
    
    self.statusTopicLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *statusTopicSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTopicSingleTap:)];
    headerSingleTap.numberOfTapsRequired = 1;
    [self.statusTopicLabel addGestureRecognizer:statusTopicSingleTap];
    
    if(cellStyle == XTTopicTableViewCellStyleHotlick) {
        self.contentImageView.userInteractionEnabled = YES;
        self.contentScrollView.userInteractionEnabled = YES;
    }else {
        self.contentImageView.userInteractionEnabled = NO;
        self.contentScrollView.userInteractionEnabled = NO;
    }
    
}

- (void)handleHeaderSingleTap:(id)sender {
    if(self.postInfo.user.uid == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.postInfo.user.uid)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)handleTopicSingleTap:(id)sender {

    XTTopicIndexViewController *controller = [[XTTopicIndexViewController alloc] init];
    controller.topicId = self.postInfo.topic.topicId;
    controller.topicTitle = self.postInfo.topic.title;

    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (CGFloat)heightForIndexPath:(XTPostInfo *)postModel andCellStyle:(XTTopicTableViewCellStyle)cellStyle{

    float cellHeight = 0.f;
    if([postModel.images count] == 0) {
        cellHeight = 109.f;
    }else if([postModel.images count] == 1) {
        XTImageInfo *imageInfo = postModel.images[0];
        
        float imageAreaWidth = 0;
        float imageAreaHeight = 0;
        
        CGFloat maxWidth = ((SCREEN_SIZE.width - 17 - 6*2 - 55)/3.0f)*2+6;
        CGFloat maxHeight = 200.f;
        
        if(imageInfo.width >= imageInfo.height) {
            imageAreaWidth = maxWidth;
            imageAreaHeight = imageInfo.height/imageInfo.width*imageAreaWidth;
        }else if (imageInfo.width < imageInfo.height) {
            imageAreaHeight = maxHeight;
            imageAreaWidth = imageInfo.width/imageInfo.height*imageAreaHeight;;
        }
        cellHeight = 109+imageAreaHeight;
    }else if([postModel.images count] > 1) {
        float imageWidth = (SCREEN_SIZE.width - 17 - 6*2 - 55)/3.0f;
        NSInteger imageCount = 0;
        if([postModel.images count] >= 9) {
            imageCount = 9;
        }else {
            imageCount = [postModel.images count];
        }
        cellHeight = 109+((imageCount-1)/3+1)*imageWidth + ((imageCount-1)/3)*6;
    }
    
    if(cellStyle != XTTopicTableViewCellStyleHotlick) {
        cellHeight -= 25;
    }
    
    return cellHeight-18;
}

- (void)clickImageView:(UITapGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    NSMutableArray *pidArray = [NSMutableArray array];
    
    if(!(imageView.image)) {
        return;
    }

    for(int i = 0; i < [self.postInfo.images count]; i++) {
        XTImageInfo *imageInfo = self.postInfo.images[i];
        [pidArray addObject:[NSString stringWithFormat:@"%@",@(imageInfo.id)]];
    }
    
    NSDictionary *info = @{
                           @"index" : [NSNumber numberWithInteger:imageView.tag - 100],
                           @"image" : imageView.image,
                           @"rect"  : [NSValue valueWithCGRect:imageView.frame]
                           };
    
    self.bigImgPresentAnimation.animationInfo = info;
    
    self.bigImgDismissAnimation.animationInfo = info;
    
    XTBigImageViewController *controller = [[XTBigImageViewController alloc] initWithNibName:@"XTBigImageViewController" bundle:nil];
    controller.delegate = self;
    controller.topicID = [NSNumber numberWithDouble:self.postInfo.postId];
    controller.transitioningDelegate = self;
    controller.curIndex = imageView.tag - 100;
//    controller.animationInfo = info;
    [[UIViewController topViewController] presentViewController:controller animated:YES completion:^{

    }];

}

- (void)updateCellLayout {
    
    
}

- (void)layoutCell {
    [self.bgView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(10., 7., 0., 7.));
    }];
    
    [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(@0);
        make.width.height.equalTo(@45);
    }];
    
    [self.vIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerImageView.mas_right);
        make.bottom.equalTo(self.headerImageView.mas_bottom);
        make.width.height.equalTo(@18);
    }];
    
    [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@8);
        make.centerY.equalTo(self.headerImageView.mas_centerY).offset(-10);
        make.height.equalTo(@16);
        make.width.equalTo(@20);
    }];
    
    [self.levelLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(@5);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@12);
        make.width.equalTo(@28);
    }];
    
    [self.topImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeLabel.mas_left).offset(-1);
        make.centerY.equalTo(self.nameLabel);
        make.width.equalTo(@29);
        make.height.equalTo(@13);
    }];
    
    [self.timeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(@-8);
        make.centerY.equalTo(self.nameLabel);
        make.height.equalTo(@12);
        make.width.equalTo(@30);
    }];
    
    [self.statusLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(@2);
        make.height.equalTo(@15);
        make.right.offset(-10);
    }];
    
    [self.statusTopicLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right).offset(@2);
        make.top.equalTo(self.statusLabel);
        make.height.equalTo(@15);
        make.width.equalTo(@5);
//        make.right.lessThanOrEqualTo(@-10);
    }];
    
    [self.contentImageView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@1);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(@5);
        make.height.equalTo(@100);
        make.width.equalTo(@175);
    }];
    
    [self.contentScrollView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@1);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(@5);
        make.right.offset(@-8);
        make.height.equalTo(@100);
    }];
    
    [self.commentIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(@1);
        make.bottom.offset(-8);
        make.height.width.equalTo(@15);
    }];
    
    [self.commentLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentIconImageView.mas_right).offset(@2);
        make.centerY.equalTo(self.commentIconImageView);
        make.height.equalTo(@12);
        make.width.equalTo(@25);
    }];
    
    [self.likeIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentLabel.mas_right).offset(@6);
        make.centerY.equalTo(self.commentIconImageView);
        make.height.width.equalTo(@15);
    }];
    
    [self.likeLabel updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeIconImageView.mas_right).offset(@2);
        make.centerY.equalTo(self.likeIconImageView);
        make.height.equalTo(@12);
        make.width.equalTo(@25);
    }];
    
    [self.moreButton updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(@-8);
        make.centerY.equalTo(self.likeLabel);
        make.height.width.equalTo(@40);
    }];
    
    self.contentGifIconImageView = [[UIImageView alloc] init];
    [self.contentGifIconImageView setImage:[UIImage imageNamed:@"gifIcon"]];
    [self.contentImageView addSubview:self.contentGifIconImageView];
    
    self.contentGifIconImageView.hidden = YES;
    [self.contentGifIconImageView updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentImageView.mas_right).offset(-5);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
        make.width.equalTo(@21);
        make.height.equalTo(@15);
    }];
    
    [self.seperatorLine updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(-7);
        make.right.offset(7);
        make.bottom.offset(@0);
        make.height.equalTo(@0.5);
    }];
    
}

- (IBAction)moreClick:(id)sender {
    UIImage *shareImage = nil;
    if([self.postInfo.images count] == 1) {
        shareImage = self.contentImageView.image;
    }else if([self.postInfo.images count] > 1) {
        UIImageView *scrollViewFirstImageView = (UIImageView *)[self.contentScrollView viewWithTag:100];
        shareImage = scrollViewFirstImageView.image;
    }
            
    if(self.moreClick) {
        self.moreClick(self.postInfo, shareImage);
    }

}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    return self.bigImgPresentAnimation;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.bigImgDismissAnimation;
}

-(void)bigImageViewControllerDidClickedDismissButton:(XTBigImageViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    //return self.transitionController.interacting ? self.transitionController : nil;
    return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.contentScrollView) {
        return self;
    }
    return view;
}


@end
