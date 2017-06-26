//
//  XTHotTopicView.m
//  tian
//
//  Created by loong on 15/6/27.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHotTopicView.h"
#import "XTHotTopicSetModel.h"
#import "UIImageView+WebCache.h"
#import "XTParticipateView.h"
@interface XTHotTopicView ()


@property(nonatomic,weak)IBOutlet UILabel *topicLabel;

@property(nonatomic,weak)IBOutlet UILabel *contentLabel;


@property (weak, nonatomic) IBOutlet XTParticipateView *participateView;


@property(nonatomic,weak)IBOutlet UIView *imgSetView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgSetViewHeightConstraints;


@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;

@end


@implementation XTHotTopicView


-(void)awakeFromNib{
    self.participateView.layer.borderColor = [UIColor grayColor].CGColor;
    self.participateView.layer.borderWidth = 0.5f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
}

-(void)setModel:(XTHotTopicSetModel *)aModel{
    _model = aModel;
    self.topicLabel.text = self.model.title;
    self.contentLabel.text = self.model.des;
    [self layoutIfNeeded];
    
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%@",_model.favoritesCount];
    self.viewCountLabel.text = [NSString stringWithFormat:@"%@",_model.viewCount];
    
    NSArray *imgArr = self.model.images;
    
    //CGFloat width_a = CGRectGetWidth(self.imgSetView.frame);
    
    CGFloat Width = ((SCREEN_SIZE.width - 46) - 2 * 14) / 3;
    
    UIImageView *imgView = nil;
    
    for (int i = 0; i < imgArr.count; i++) {
        NSString *obj = imgArr[i];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * Width + i * 14, 0, Width, Width)];
        [imgView an_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",(i+1) % 6]]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        
        [self.imgSetView addSubview:imgView];
    }
    
    
    self.imgSetViewHeightConstraints.constant = Width;
    
    NSArray *participateArr = self.model.users;
    
    self.participateView.arr = participateArr;
    
    self.participateView.participateConut = _model.userCount;
    
    //self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(imgView.frame)+CGRectGetHeight(self.contentLabel.frame) + CGRectGetMinY(self.imgSetView.frame) + 45 + 16 + CGRectGetHeight(self.likeContentView.frame));
}

-(void)setDelegate:(id)aDelegate{
    _delegate = aDelegate;
    self.participateView.delegate = _delegate;
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(hotTopicViewTapAction)]) {
        [self.delegate hotTopicViewTapAction];
    }
}

-(UIImage *)getShareImage{
    UIImageView *imageView = [self.imgSetView.subviews firstObject];
    
    return imageView.image;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
