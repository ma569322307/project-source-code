//
//  XTCommendsView.m
//  tian
//
//  Created by loong on 15/6/29.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTCommendsView.h"
#import "UIImageView+WebCache.h"
#import "XTUserInfo.h"
#import "XTUserStore.h"
#import "XTCommendCountView.h"
#import "UIImageView+Custom.h"
@interface XTCommendsView()

@property (weak, nonatomic) IBOutlet UIView *avatarSetView;

@property (weak, nonatomic) IBOutlet UIButton *commendBtn;

@property (weak, nonatomic) IBOutlet XTCommendCountView *commendCountView;

@end


@implementation XTCommendsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = UIColorFromRGB(0xd2d2d2).CGColor;
}


-(void)setCommendUsers:(NSMutableArray *)aCommendUsers{
    
    _commendUsers = aCommendUsers;
    
    [self addImageView];
    
}


- (IBAction)commendBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        if ([self.delegate respondsToSelector:@selector(commendActionWith:)]) {
            [self.delegate commendActionWith:self];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(cancelCommendActionWith:)]) {
            [self.delegate cancelCommendActionWith:self];
        }
    }
    sender.selected = !sender.selected;

}

-(void)setFavorited:(BOOL)aFavorited{
    _favorited = aFavorited;
    
    self.commendBtn.selected = _favorited;
    
}

-(void)setCommendCount:(NSInteger)aCommendCount{
    _commendCount = aCommendCount;
    self.commendCountView.hidden = _commendCount < 5;
    self.commendCountView.count = _commendCount;
}
-(NSArray *)commendSuccess{
    
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    XTUserInfo *userInfo = [[XTUserInfo alloc] init];
    userInfo.nickName = userAccountInfo.nickname;
    userInfo.smallAvatar = userAccountInfo.smallAvatarURL;
    
    userInfo.uid = [userAccountInfo.userID integerValue];
    
    userInfo.level = [userAccountInfo.level integerValue];
    
    //NSInteger insertIndex = self.commendUsers.count <=7 ? self.commendUsers.count-1 : 6;
    
    
    [self.commendUsers  insertObject:userInfo atIndex:0];
    
    self.commendCountView.count += 1;
    if (self.commendCountView.count >= 5) {
        self.commendCountView.hidden = NO;
    }
    [self addCommendUserWith:0];
    
    return [self.commendUsers copy];
}


-(void)cancelCommendSuccess{
    //[self.commendUsers removeObjectAtIndex:0];
    NSInteger index = - 1;
    
    for (NSUInteger i = 0; i < self.commendUsers.count; i ++) {
        XTUserInfo *userInfo = self.commendUsers[i];
        XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
        if (userInfo.uid == [userAccountInfo.userID integerValue]) {
            [self.commendUsers removeObject:userInfo];
            index = i;
            break;
        }
    }
    self.commendCountView.count -= 1;
    
    if (self.commendCountView.count < 5) {
        self.commendCountView.hidden = YES;
    }
    
    if (index >= 4) {
        return;
    }
    
    [self deleteCommendUserWithIndex:index];
    
}


-(void)addImageView{
    
    NSArray *arr = self.avatarSetView.subviews;
    
    for (UIView *view in arr) {
        [view removeFromSuperview];
    }
    
    
    NSInteger count = _commendUsers.count > 5 ? 5 : _commendUsers.count;
    
    //self.commendCountView.hidden = YES;//(_commendUsers.count < 7);
    
    for (int i = 0; i < count; i ++) {
        
        XTUserInfo *model = _commendUsers[i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 26 + 5 * i, 9, 26, 26)];
        imgView.layer.cornerRadius = 13;
        imgView.layer.masksToBounds = YES;

        [imgView an_setImageWithURL:model.smallAvatar placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"placeholderImage%zd.png",(i + 1)%6]]];
        //[imgView showHeaderWithUrl:model.smallAvatar];
        
        imgView.userInteractionEnabled = YES;
        imgView.tag = model.uid;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired  = 1;
        [imgView addGestureRecognizer:tap];
        [self.avatarSetView addSubview:imgView];
    }
}

-(void)addCommendUserWith:(NSInteger)index{
    
    NSArray *arr = self.avatarSetView.subviews;
    
    if (arr.count == 5) {
        //XTUserInfo *userInfo = self.commendUsers[5];
        UIView *view = [arr lastObject];
        
        [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
            view.frame = CGRectMake(view.center.x, view.center.y, 0, 0);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            
            for (UIView *view_f in self.avatarSetView.subviews) {
                
                //NSLog(@"self.avatarSetView.subViews.count ===== %zd",self.avatarSetView.subviews.count);
                
                [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.8f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveLinear animations:^{
                    view_f.frame = CGRectMake(CGRectGetMaxX(view_f.frame) + 5, CGRectGetMinY(view_f.frame), 26, 26);
                } completion:^(BOOL finished) {
                    NSLog(@"动画完成");
                    
                }];
            }
            [self addAvatarImageViewWithIndex:index];
            
        }];
        
    }else{
        for (UIView *view_f in self.avatarSetView.subviews) {
            
            [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.3f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
                view_f.frame = CGRectMake(CGRectGetMaxX(view_f.frame) + 5, CGRectGetMinY(view_f.frame), 26, 26);
            } completion:^(BOOL finished) {
                
            }];
        }
        [self addAvatarImageViewWithIndex:index];
    }
    
    
}

-(void)deleteCommendUserWithIndex:(NSInteger)index{
    if (index == -1) {
        return;
    }
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    UIView *removeView = [self.avatarSetView viewWithTag:[userAccountInfo.userID integerValue]];
    
    [UIView animateWithDuration:0.1 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
        removeView.frame = CGRectMake(removeView.center.x, removeView.center.y, 0, 0);
    } completion:^(BOOL finished) {
        [removeView removeFromSuperview];
        if (index < self.commendUsers.count) {
            [self moveAvatarImageViewWithIndex:index];
        }
    }];
}




-(void)tapGesture:(UITapGestureRecognizer *)tap{
    NSInteger userID = tap.view.tag;
    //XTUserInfo *userInfo = self.commendUsers[idx];
    XTUserAccountInfo *userAccountInfo = [XTUserStore sharedManager].user;
    
    if (userID == [userAccountInfo.userID integerValue]) {
        return;
    }
    
    for (XTUserInfo *userInfo in self.commendUsers) {
        if (userID == userInfo.uid) {
            if ([self.delegate respondsToSelector:@selector(tapActionWith:)]) {
                [self.delegate tapActionWith:userInfo];
            }
            break;
        }
    }
}


-(void)addAvatarImageViewWithIndex:(NSInteger)index{
    
    XTUserInfo *userInfo = self.commendUsers[index];
    
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(index * 26 + index * 5 + 13, 22, 0, 0)];
//    avatarImageView.layer.cornerRadius = 13;
//    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.tag = userInfo.uid;
    avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired  = 1;
    [avatarImageView addGestureRecognizer:tap];
    [self.avatarSetView addSubview:avatarImageView];
    

    XTUserInfo *model = self.commendUsers[index];
//    [avatarImageView an_setImageWithURL:model.smallAvatar placeholderImage:[UIImage imageNamed:@"placeholderImage1.png"]];
    [avatarImageView showHeaderWithUrl:model.smallAvatar];
    [self.avatarSetView addSubview:avatarImageView];
    
    
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
        avatarImageView.frame = CGRectMake(index * 26 + index * 5, 9, 26, 26);

    } completion:^(BOOL finished) {
        
    }];
}

-(void)moveAvatarImageViewWithIndex:(NSInteger)index{
    
    for (NSUInteger i = index; i < self.commendUsers.count && i < 4; i++) {
        XTUserInfo *userInfo  = self.commendUsers[i];
        UIView *view_i = [self.avatarSetView viewWithTag:userInfo.uid];
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.4f initialSpringVelocity:0.9f options:UIViewAnimationOptionCurveLinear animations:^{
            view_i.frame = CGRectMake(CGRectGetMinX(view_i.frame) - 31, CGRectGetMinY(view_i.frame), 26, 26);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (self.avatarSetView.subviews.count < 5 && self.commendUsers.count >= 5) {
        [self addAvatarImageViewWithIndex:4];
    }

}



@end
