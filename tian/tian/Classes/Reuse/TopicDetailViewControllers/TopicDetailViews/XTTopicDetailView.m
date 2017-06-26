//
//  XTTopicDetailView.m
//  tian
//
//  Created by loong on 15/7/7.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTTopicDetailView.h"
#import "XTImgSetView.h"
#import "XTTopicDetailModel.h"
#import "XTCommendsView.h"
#import "XTUserInfo.h"
#import "NSString+TimeReversal.h"
#import "XTAvatarView.h"
#import "XTCommendCountView.h"
@interface XTTopicDetailView()



@property (weak, nonatomic) IBOutlet XTAvatarView *avatarView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@property (weak, nonatomic) IBOutlet XTImgSetView *imgeSetView;


@property (weak, nonatomic) IBOutlet XTCommendsView *commendView;


@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

static NSString const *CommentCountKVOContext;

@implementation XTTopicDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    self.levelLabel.layer.cornerRadius = 6.0f;
    self.levelLabel.layer.masksToBounds = YES;
    
    self.commendView.layer.borderWidth = 0.5f;
    self.commendView.layer.borderColor = [UIColor grayColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *avatarViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewTapGesture:)];
    avatarViewTap.numberOfTapsRequired = 1;
    avatarViewTap.numberOfTouchesRequired = 1;
    [self.avatarView addGestureRecognizer:avatarViewTap];
    
    
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(tapAction)]) {
        [self.delegate tapAction];
    }
}


-(void)avatarViewTapGesture:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(topicDetailViewAvatarViewTapActionWith:)]) {
        [self.delegate topicDetailViewAvatarViewTapActionWith:self.model.user];
    }
}


-(void)setModel:(XTTopicDetailModel *)aModel{
    
    self.backgroundColor = [UIColor clearColor];
    
    _model = aModel;
    
    [_model addObserver:self forKeyPath:@"commentCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&CommentCountKVOContext];
    
    
    self.nickNameLabel.text = _model.user.nickName;
    
    self.levelLabel.text = [NSString stringWithFormat:@"  lv%zd  ",_model.user.level];
    
    NSString *time = [NSString diffTimestamp:[_model.created floatValue]];
    
    self.createdAtLabel.text = time;
    
    //[self.avatarImageView sd_setImageWithURL:_model.user.smallAvatar placeholderImage:UIIMAGE(@"placeholder4.png")];
    
    self.avatarView.avatarUrl = _model.user.smallAvatar;
    self.avatarView.is_V_User = _model.user.vuser;
    
    self.imgeSetView.arr = _model.images;
    
    self.desLabel.text = _model.des;
    
    self.commendView.commendUsers = [NSMutableArray arrayWithArray:_model.commendUsers];
    
    self.commendView.favorited = _model.commended;
    
    self.commendView.commendCount = _model.commendCount;
    
    [self.commendView layoutIfNeeded];
    
    self.commentCount = [_model.commentCount integerValue];
    
    //[self layoutIfNeeded];
}


-(void)setCommentCount:(NSInteger)aCommentCount{
    
    _commentCount = aCommentCount;
    
    self.commentCountLabel.hidden = (_commentCount == 0) ? YES : NO;
    
    self.commentCountLabel.text = [NSString stringWithFormat:@"评论(%@)",[_model.commentCount stringValue]];

}

- (IBAction)shareBtnClick:(UIButton *)sender {
    
    NSArray *subViews = self.imgeSetView.subviews;
    
    UIImageView *imageView = subViews[0];
    
    if ([self.delegate respondsToSelector:@selector(topicDetailViewShareBtnAction:andImg:)]) {
        [self.delegate topicDetailViewShareBtnAction:self.model andImg:imageView.image];
    }
}

-(void)setDelegate:(id)aDeelegate{
    _delegate = aDeelegate;
    self.commendView.delegate = _delegate;
    self.imgeSetView.delegate = _delegate;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == &CommentCountKVOContext) {
        self.commentCountLabel.text = [NSString stringWithFormat:@"评论(%@)",change[@"new"]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


-(void)dealloc{
    
    [self.model removeObserver:self forKeyPath:@"commentCount" context:&CommentCountKVOContext];
}

@end
