//
//  XTAvatarView.m
//  tian
//
//  Created by loong on 15/7/27.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTAvatarView.h"
#import "UIImageView+WebCache.h"

@interface XTAvatarView()

@property(nonatomic,weak) IBOutlet UIImageView *avatarImgView;


@property(nonatomic,weak) IBOutlet UIImageView *v_imgView;
@end


@implementation XTAvatarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    self.avatarImgView.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    self.avatarImgView.layer.masksToBounds = YES;
}

-(void)setAvatarUrl:(NSURL *)aAvatarUrl{
    _avatarUrl = aAvatarUrl;
    
    [self.avatarImgView an_setImageWithURL:_avatarUrl placeholderImage:UIIMAGE(@"placeholderImage4.png") options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

-(void)setIs_V_User:(BOOL)aIs_V_User{
    _is_V_User = aIs_V_User;
    self.v_imgView.hidden = !_is_V_User;
}

@end
