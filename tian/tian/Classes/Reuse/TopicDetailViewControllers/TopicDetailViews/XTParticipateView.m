//
//  XTParticipate.m
//  tian
//
//  Created by loong on 15/7/15.
//  Copyright (c) 2015年 音悦Tai. All rights reserved.
//

#import "XTParticipateView.h"
#import "XTUserInfo.h"
#import "XTUserStore.h"
@interface XTParticipateView()

@property(nonatomic,weak)NSLayoutConstraint *heightConstraints;


@property(nonatomic,weak)IBOutlet UILabel *participateCountLabel;



@end


@implementation XTParticipateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)setArr:(NSArray *)aArr{
    _arr = aArr;
    if (!_arr && _arr.count == 0) {
        self.heightConstraints.constant = 0;
        return;
    }else{
        self.heightConstraints.constant = 43;
    }
    
    NSInteger count = _arr.count > 7 ? 7 : _arr.count;
    
    for (int i = 0; i < count; i ++) {
        
        XTUserInfo *model= _arr[i];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + i * 27 + i * 5, 7, 27, 27)];
        imgView.layer.cornerRadius = 13;
        imgView.layer.masksToBounds = YES;
        [imgView an_setImageWithURL:model.smallAvatar placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",(i+1)%6]]];
        imgView.userInteractionEnabled = YES;
        imgView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [imgView addGestureRecognizer:tap];
        [self addSubview:imgView];
    }
}

-(void)setParticipateConut:(NSNumber *)aParticipateConut{
    
    _participateConut = aParticipateConut;
    
    if ([_participateConut integerValue] < 7) {
        self.participateCountLabel.superview.hidden = YES;
    }else{
        self.participateCountLabel.superview.hidden = NO;
    }
    
    self.participateCountLabel.text = [NSString stringWithFormat:@"%@",_participateConut];
    
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    NSInteger idx = tap.view.tag;

    XTUserInfo *userInfo = self.arr[idx];
    
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    if (userInfo.uid == [userAccountInfo.userID integerValue]) {
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(tapActionWith:)]) {
        [self.delegate tapActionWith:self.arr[idx]];
    }    
}


@end
