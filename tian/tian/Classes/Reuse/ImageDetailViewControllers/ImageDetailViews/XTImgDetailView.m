//
//  XTImgDetailView.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTImgDetailView.h"
#import "XTImgShowModel.h"
#import "UIImageView+WebCache.h"
#import "XTUserInfo.h"
#import "UIImage+Size.h"
#import "UIImageView+Custom.h"
#import "XTTagsView.h"
#import "XTCommendsView.h"
#import "XTAlbumsOfPicView.h"
#import "NSString+TimeReversal.h"
#import "XTUserStore.h"
#import "NSString+TextSize.h"
#import "XTAvatarView.h"
#import "UIImage+Capture.h"
static NSString * commentCountContext = @"commentCountContext";

@interface XTImgDetailView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *imgPic;


@property (weak, nonatomic) IBOutlet XTAvatarView *avatarView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@property(nonatomic,weak)IBOutlet XTTagsView *tagsView;

@property (weak, nonatomic) IBOutlet XTCommendsView *commendsView;

@property (weak, nonatomic) IBOutlet XTAlbumsOfPicView *albumsView;


@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgPicHeightCostraints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagsViewHeightConstraints;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeightConstraints;

@property (weak, nonatomic) IBOutlet UIView *underLine;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end



@implementation XTImgDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.levelLabel.layer.cornerRadius = 6;
    self.levelLabel.layer.masksToBounds = YES;
    
//    CGFloat textHeight = [text textHeightWithFontSize:13.0f isBold:NO andWidth:SCREEN_SIZE.width - 48];
//    
//    self.textLabelHeightConstraints.constant = textHeight;
    
    self.textLabel.preferredMaxLayoutWidth = SCREEN_SIZE.width - 48;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgViewTapGesture:)];
    [self.avatarView addGestureRecognizer:tap];
    [self.imgPic setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self.imgPic setContentMode:UIViewContentModeScaleAspectFill];
    [self.imgPic setClipsToBounds:YES];
}


-(void)setModel:(XTImgShowModel *)aModel{
    _model = aModel;
    self.shareBtn.enabled = NO;
    
    //[_model addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&commentCountContext];
    
    CGFloat height = [self calculateHeightWith:[_model.width floatValue] andHeight:[_model.height floatValue]];
    
    CGFloat percent_w_h = height / (SCREEN_SIZE.width - 30);
    
    if (percent_w_h > 2) {
        height = SCREEN_SIZE.width * 2;
    }
    
    self.imgPicHeightCostraints.constant = height;
    [self.imgPic layoutIfNeeded];
    
    
    NSString *sdCacheKey = self.placeholderImageURL.absoluteString;
    SDImageCache *sdCache = [SDImageCache sharedImageCache];
    UIImage *cacheImage = [sdCache imageFromMemoryCacheForKey:sdCacheKey];
    
    UIImage *placeholderImage = cacheImage ? cacheImage : UIIMAGE(@"placeholderImage4.png");
    
    if (self.placeholderImageURL) {
        [self.imgPic sd_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority /*| SDWebImageProgressiveDownload*/ completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.shareBtn.enabled = image ? YES : NO;
            self.imgLoadFinish(image);
            
        }];
    }else{
        [self.imgPic an_setImageWithURL:[NSURL URLWithString:_model.picUrl] placeholderImage:placeholderImage options:SDWebImageRetryFailed | SDWebImageLowPriority /*| SDWebImageProgressiveDownload*/ completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.shareBtn.enabled = image ? YES : NO;
            self.imgLoadFinish(image);
            
        }];
    }
    
    //    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    //
    //    [self.imgPic sd_setImageWithURL:model.originalPic placeholderImage:pi completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //        //[self.aiView stopAnimating];
    //        if ([self.delegate respondsToSelector:@selector(scrollActionWithOriginalImg:andCurImg:)]) {
    //            [self.delegate scrollActionWithOriginalImg:isExists andCurImg:image];
    //        }
    //    }];
    //
    
    
    
    //CGFloat width = [_model.width integerValue];
    
    
    self.avatarView.avatarUrl = _model.user.smallAvatar;
    self.avatarView.is_V_User = _model.user.vuser;
    self.nickNameLabel.text = _model.user.nickName;
    
    self.levelLabel.text = [NSString stringWithFormat:@" lv%ld  ",_model.user.level];
    
    NSString *time = [NSString diffTimestamp:[_model.createdAt doubleValue]];
    
    self.createdAtLabel.text = time;
    
    NSString *text = _model.text;
    
    self.textLabel.text = text;
    
    //self.textLabel.text = @"lksjdfoewifnihfadksfksadjfkjads;fkjas;kdfhijgrnlidnliashdfliasjflkdjsnflkdasjnflkjadsn";
    if ([_model.commentCount integerValue] == 0) {
        self.commentCountLabel.hidden = YES;
    }else{
        self.commentCountLabel.hidden = NO;
        self.commentCountLabel.text = [NSString stringWithFormat:@"评论(%@)",_model.commentCount];
    }
    
    NSLog(@"textLabel.frame === %@",NSStringFromCGRect(self.textLabel.frame));
    
    NSLog(@"imgPic.frame ===== %@",NSStringFromCGRect(self.imgPic.frame));
    
    if (!_model.tagsNew || _model.tagsNew.count == 0) {
        self.tagsViewHeightConstraints.constant = 32;
    }else{
        //self.tagsView.tags = @[@"@"萧敬腾",@"exo",@"tfboys",@"jay",@"lksdjfklj"];
        self.tagsViewHeightConstraints.constant = 32;
        self.tagsView.tags = _model.tagsNew;
        //self.tagsView.backgroundColor = [UIColor yellowColor];
    }
    
    self.commendsView.commendUsers = [NSMutableArray arrayWithArray:_model.commendUsers];
    self.commendsView.commendCount = [_model.commendCount integerValue];
    self.commendsView.favorited = _model.commended;
    
    if (!_model.album) {
        self.albumsView.heightConstraints.constant = 0;
        self.albumsView.hidden = YES;
        self.underLine.hidden = YES;
    }else{
        self.albumsView.heightConstraints.constant = 64;
        self.albumsView.model = _model.album;
        self.underLine.hidden = NO;
        self.albumsView.hidden = NO;
    }
}


-(void)setPlaceholderImageURL:(NSURL *)aPlaceholderImageURL{
    _placeholderImageURL = aPlaceholderImageURL;
    
    if (!_placeholderImageURL) {
        self.imgPic.image = nil;
    }
}

-(void)avatarImgViewTapGesture:(UITapGestureRecognizer *)tap{
    
     XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    if (self.model.user.uid == [userAccountInfo.userID integerValue]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(avatarImgViewTapAction:)]) {
        [self.delegate avatarImgViewTapAction:self.model.user];
    }
}


-(CGFloat)calculateHeightWith:(CGFloat)width andHeight:(CGFloat)height{
    if (width == 0) {
        return 0;
    }
    
    CGFloat scale = (SCREEN_SIZE.width - 30) / width;
    
    CGFloat imgHeight = scale * height;
    
    return imgHeight;
    
}

- (IBAction)imgTapAction:(UITapGestureRecognizer *)sender {
    UIImageView *imgView = (UIImageView *)sender.view;
    
    CGRect rect = [imgView convertRect:imgView.bounds toView:nil];
    NSLog(@"rect === %@",NSStringFromCGRect(rect));
    
    if ([self.delegate respondsToSelector:@selector(tapImgActionWith:andRect:andImage:)]) {
        [self.delegate tapImgActionWith:self.index andRect:[NSValue valueWithCGRect:rect] andImage:imgView.image];
    }
}


- (IBAction)shareBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(shareBtnAction:andModel:)]) {
        [self.delegate shareBtnAction:self.imgPic.image andModel:self.model];
    }
}


-(void)setDelegate:(id)aDelegate{
    _delegate = aDelegate;
    self.commendsView.delegate = _delegate;
    self.albumsView.delegate = _delegate;
    self.tagsView.delegate = _delegate;
}

//-(UIImage *)image{
//    return self.imgPic.image;
//}


-(void)setImgLoadFinish:(void (^)(UIImage *image))aImgLoadFinish{
    _imgLoadFinish = aImgLoadFinish;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == &commentCountContext) {
        //self.commentCountLabel.text =
    }
}




@end
