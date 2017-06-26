//
//  XTUserFavorateCollectionViewCell.m
//  tian
//
//  Created by huhuan on 15/6/11.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTUserCollectionViewCell.h"
#import "XTSearchUserModel.h"
#import "XTOrderArtist.h"
#import "XTBlackListInfo.h"
#import <SDWebImage/SDWebImageManager.h>
#import "XTAddLikeAndHateViewController.h"
#import "YYTHUD.h"
#import "UIImage+Capture.h"
#import "UIImageView+Custom.h"
#import "UIViewController+Extend.h"
#import "XTUserHomePageViewController.h"
#import "XTUserStore.h"
#import "NSString+TextSize.h"
#import "XTUserCollectionView.h"

@interface XTUserCollectionViewCell ()

@property (nonatomic, weak  ) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak  ) IBOutlet UIImageView *vIconImageView;
@property (nonatomic, weak  ) IBOutlet UILabel     *nameLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *fansLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *tagLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *levelLabel;
@property (nonatomic, weak  ) IBOutlet UILabel     *sexLabel;
@property (nonatomic, weak  ) IBOutlet UIButton    *methodButton;

@property (nonatomic, strong) MTLModel    *searchUserModel;

@property (nonatomic, assign) BOOL        isSelected;

@end

@implementation XTUserCollectionViewCell {
  dispatch_once_t __oncetoken;
}

- (IBAction)methodButtonClick:(id)sender {
    if(self.userCollectionView.isRequesting) {
        return;
    }else {
        self.userCollectionView.isRequesting = YES;
    }
    if (!self.isSelected) {
        //判断是否可以相应
        if ([self.infoDelegate respondsToSelector:@selector(sholdChangeInfo)]) {
            //可以相应
            if ([self.infoDelegate sholdChangeInfo]) {
                //可以继续
                if (self.buttonClick) {
                    self.buttonClick(self.searchUserModel, self.isSelected, self.cellIndexPath);
                }
                self.isSelected = !(self.isSelected);
                [self changeButtonStatus];
                return;
            }else{
                self.userCollectionView.isRequesting = NO;
                [YYTHUD showPromptAddedTo:[UIApplication sharedApplication].keyWindow withText:@"你喜爱的艺人已绕地球两圈！" withCompletionBlock:nil];
                return;
            }
        }
    }
    if (self.buttonClick) {
        self.buttonClick(self.searchUserModel, self.isSelected, self.cellIndexPath);
    }
    self.isSelected = !(self.isSelected);
    [self changeButtonStatus];
}

- (void)changeButtonStatus {
    if(self.buttonStyle == XTUserCollectionViewCellButtonStyleRemove) {
        [self.methodButton setBackgroundColor:UIColorFromRGB(0xf91156)];
        [self.methodButton setTitleColor:[UIColor whiteColor]
                                  forState:UIControlStateNormal];
        [self.methodButton setTitle:self.buttonNormalTitle
                             forState:UIControlStateNormal];
    }else {
        if (self.isSelected) {
            [self.methodButton setBackgroundColor:UIColorFromRGB(0xc2c3c4)];
            [self.methodButton setTitleColor:[UIColor whiteColor]
                                      forState:UIControlStateNormal];
            [self.methodButton setTitle:self.buttonSelectedTitle
                                 forState:UIControlStateNormal];
        } else {
            [self.methodButton setBackgroundColor:UIColorFromRGB(0xfbe510)];
            [self.methodButton setTitleColor:UIColorFromRGB(0x4f242b)
                                      forState:UIControlStateNormal];
            [self.methodButton setTitle:self.buttonNormalTitle
                                 forState:UIControlStateNormal];
        }
    
    }

}

- (void)configureUserCell:(MTLModel *)userModel {

  if (self.cellStyle == XTUserCollectionViewCellStyleDefault) {
    self.fansLabel.hidden = YES;
    self.tagLabel.hidden = YES;
    self.levelLabel.hidden = YES;
    self.sexLabel.hidden = YES;
  } else if (self.cellStyle == XTUserCollectionViewCellStyleTagAndSex) {
    self.fansLabel.hidden = YES;
    self.tagLabel.hidden = NO;
    self.levelLabel.hidden = NO;
    self.sexLabel.hidden = NO;
  } else {
    self.fansLabel.hidden = NO;
    self.tagLabel.hidden = YES;
    self.levelLabel.hidden = YES;
    self.sexLabel.hidden = YES;
  }
    
    long userId = 0;

  if ([userModel isKindOfClass:[XTSearchUserModel class]]) {
    XTSearchUserModel *tempUserModel = (XTSearchUserModel *)userModel;
      userId = tempUserModel.userId;
    self.searchUserModel = tempUserModel;
    self.nameLabel.text = tempUserModel.name;
    self.fansLabel.text =
        [NSString stringWithFormat:@"粉丝：%@", @(tempUserModel.fans)];
    [self.headerImageView showHeaderWithUrl:[NSURL URLWithString:tempUserModel.headImg]];
      
      if(self.buttonStyle == XTUserCollectionViewCellButtonStyleHate) {
          if ([tempUserModel.black isEqualToString:@"1"]) {
              self.isSelected = YES;
          } else {
              self.isSelected = NO;
          }
      }else if (tempUserModel.follow) {
          if ([tempUserModel.follow isEqualToString:@"1"]) {
              self.isSelected = YES;
          } else {
              self.isSelected = NO;
          }
      }else if (tempUserModel.like) {
          if ([tempUserModel.like isEqualToString:@"1"]) {
              self.isSelected = YES;
          } else {
              self.isSelected = NO;
          }
      }
      
      if(tempUserModel.state == 1) {
          self.vIconImageView.hidden = NO;
      }else {
          self.vIconImageView.hidden = YES;
      }
      
      //等级与性别
      if(tempUserModel.sex) {
          self.tagLabel.text = tempUserModel.levelName;
          self.levelLabel.text = [NSString stringWithFormat:@"lv%@", tempUserModel.level];
          self.sexLabel.text = tempUserModel.sex;
          if ([tempUserModel.sex isEqualToString:@"女"]) {
              [self.sexLabel setText:tempUserModel.sex];
              [self.sexLabel setBackgroundColor:UIColorFromRGB(0xff266a)];
          } else if ([tempUserModel.sex isEqualToString:@"男"]) {
              [self.sexLabel setText:tempUserModel.sex];
              [self.sexLabel setBackgroundColor:UIColorFromRGB(0x45a7e7)];
          } else {
              [self.sexLabel setText:@"秘"];
              [self.sexLabel setBackgroundColor:UIColorFromRGB(0x595959)];
          }
      }

  } else if ([userModel isKindOfClass:[XTOrderArtist class]]) {
    XTOrderArtist *tempUserModel = (XTOrderArtist *)userModel;
      userId = tempUserModel.artistId;
    self.searchUserModel = tempUserModel;
      
    self.nameLabel.text = tempUserModel.artistName;
    self.fansLabel.text =
    [NSString stringWithFormat:@"粉丝：%@", @(tempUserModel.subNum)];

    [self.headerImageView showHeaderWithUrl:[NSURL URLWithString:tempUserModel.headImg]];

      if(self.buttonStyle == XTUserCollectionViewCellButtonStyleHate) {
          if (tempUserModel.black){
              self.isSelected = YES;
          } else {
              self.isSelected = NO;
          }
      }else {
          if (tempUserModel.subStatus) {
              self.isSelected = YES;
          } else {
              self.isSelected = NO;
          }
      }


  } else if ([userModel isKindOfClass:[XTBlackListInfo class]]) {
    XTBlackListInfo *tempUserModel = (XTBlackListInfo *)userModel;
      userId = tempUserModel.uid;
    self.searchUserModel = tempUserModel;
    self.nameLabel.text = tempUserModel.nickName;
    self.fansLabel.text =
        [NSString stringWithFormat:@"粉丝：%@", @(tempUserModel.fans)];
      [self.headerImageView showHeaderWithUrl:tempUserModel.smallAvatar];
  } else if ([userModel isKindOfClass:[XTUserAccountInfo class]]) {
    XTUserAccountInfo *tempUserModel = (XTUserAccountInfo *)userModel;
      userId = [tempUserModel.userID integerValue];
    self.searchUserModel = tempUserModel;
    self.nameLabel.text = tempUserModel.nickname;
    self.tagLabel.text = tempUserModel.levelName;
    self.levelLabel.text =
        [NSString stringWithFormat:@"lv%@", tempUserModel.level];
    self.sexLabel.text = tempUserModel.gender;

    self.isSelected = tempUserModel.hasFollowed;
      
      if(tempUserModel.type == XTAccountFans) {
          self.vIconImageView.hidden = NO;
      }else {
          self.vIconImageView.hidden = YES;
      }

    if ([tempUserModel.gender isEqualToString:@"女"]) {
      [self.sexLabel setText:tempUserModel.gender];
      [self.sexLabel setBackgroundColor:UIColorFromRGB(0xff266a)];
    } else if ([tempUserModel.gender isEqualToString:@"男"]) {
      [self.sexLabel setText:tempUserModel.gender];
      [self.sexLabel setBackgroundColor:UIColorFromRGB(0x45a7e7)];
    } else {
      [self.sexLabel setText:@"秘"];
      [self.sexLabel setBackgroundColor:UIColorFromRGB(0x595959)];
    }

      [self.headerImageView showHeaderWithUrl:tempUserModel.smallAvatarURL];

  }
  [self changeButtonStatus];
    
    if(userId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        self.methodButton.hidden = YES;
    }else {
        self.methodButton.hidden = NO;
    }

    [self layoutIfNeeded];
    [self.headerImageView layoutIfNeeded];
    
    //TODO:由于autoLayout布局导致页面滚动很卡，因此此处改为frame布局，有待优化
    self.vIconImageView.frame = CGRectMake(self.headerImageView.frame.origin.x+self.headerImageView.frame.size.width-18, self.headerImageView.frame.origin.y+self.headerImageView.frame.size.height-18, 18., 18.);
    self.nameLabel.frame = CGRectMake(6., self.headerImageView.frame.origin.y+self.headerImageView.frame.size.height+5, self.frame.size.width-12., 14.);
    self.fansLabel.frame = CGRectMake(6., self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+2, self.frame.size.width-12., 11.);
    
    float levelNameWidth = [self.tagLabel.text textWidthWithFontSize:9 isBold:NO andHeight:11];
    
    float levelWidth = [self.levelLabel.text textWidthWithFontSize:10 isBold:NO andHeight:11];
    
    self.tagLabel.frame = CGRectMake((self.frame.size.width-levelNameWidth-levelWidth-11)/2.f, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+2, levelNameWidth, 11.);
    self.levelLabel.frame = CGRectMake(self.tagLabel.frame.origin.x+self.tagLabel.frame.size.width+2, self.tagLabel.frame.origin.y, levelWidth, 11.);
    self.sexLabel.frame = CGRectMake(self.levelLabel.frame.origin.x+self.levelLabel.frame.size.width+2, self.levelLabel.frame.origin.y, 11., 11.);

    UIView *topViewOfMethodButton = nil;
    float methodButtonOriginY = 0.f;
    float methodButtonHeightDelta = 4.f;
    if(self.cellStyle == XTUserCollectionViewCellStyleDefault) {
        topViewOfMethodButton = self.nameLabel;
        methodButtonOriginY = topViewOfMethodButton.frame.origin.y+topViewOfMethodButton.frame.size.height+8;
        methodButtonHeightDelta = 10.f;
    }else if(self.cellStyle == XTUserCollectionViewCellStyleTagAndSex) {
        topViewOfMethodButton = self.tagLabel;
        methodButtonOriginY = topViewOfMethodButton.frame.origin.y+topViewOfMethodButton.frame.size.height+2;
    }else if(self.cellStyle == XTUserCollectionViewCellStyleFans) {
        topViewOfMethodButton = self.fansLabel;
        methodButtonOriginY = topViewOfMethodButton.frame.origin.y+topViewOfMethodButton.frame.size.height+2;
    }

    self.methodButton.frame = CGRectMake(5., methodButtonOriginY, self.frame.size.width-10., self.frame.size.height - methodButtonOriginY - methodButtonHeightDelta);
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];
    
}

- (void)handleSingleTap:(id)sender {
    long userId = 0;
    MTLModel *transferModel = nil;
    XTUserHomePageType type = XTUserHomePageTypeHis;
    if ([self.searchUserModel isKindOfClass:[XTSearchUserModel class]]) {
        XTSearchUserModel *tempUserModel = (XTSearchUserModel *)self.searchUserModel;
        userId = tempUserModel.userId;
        if(self.isArtist) {
            type = XTUserHomePageTypeArtist;
        }
        transferModel = tempUserModel;
    }else if ([self.searchUserModel isKindOfClass:[XTOrderArtist class]]) {
        XTOrderArtist *tempUserModel = (XTOrderArtist *)self.searchUserModel;
        userId = tempUserModel.artistId;
        type = XTUserHomePageTypeArtist;
        transferModel = tempUserModel;
    }else if ([self.searchUserModel isKindOfClass:[XTBlackListInfo class]]) {
        XTBlackListInfo *tempUserModel = (XTBlackListInfo *)self.searchUserModel;
        userId = tempUserModel.uid;
        transferModel = tempUserModel;
    }else if ([self.searchUserModel isKindOfClass:[XTUserAccountInfo class]]) {
        XTUserAccountInfo *tempUserModel = (XTUserAccountInfo *)self.searchUserModel;
        userId = [tempUserModel.userID integerValue];
        transferModel = tempUserModel;
    }
    if(userId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        transferModel = nil;
        return;
    }
    
    if(self.transferModelSave) {
        self.transferModelSave(transferModel, self.cellIndexPath);
    }
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(userId)];
    controller.type = type;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)configureCellViewsLayout {
  [self.headerImageView updateConstraints:^(MASConstraintMaker *make) {
    make.left.offset(@19);
    make.right.offset(@-19);
    make.top.offset(@8);
    make.height.equalTo(self.headerImageView.mas_width);
  }];
    
//    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:6]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:6]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
//    [self.nameLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:14.f]];

//  [self.nameLabel updateConstraints:^(MASConstraintMaker *make) {
//    make.left.offset(@6);
//    make.right.offset(@-6);
//    make.top.offset(5);
//    make.height.equalTo(@14);
//  }];
    
    
//
//  [self.fansLabel updateConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
//    make.left.equalTo(self.nameLabel);
//    make.right.equalTo(self.nameLabel);
//    make.bottom.equalTo(self.methodButton.mas_top).offset(@-4);
//  }];

//  [self.tagLabel updateConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
//    make.left.equalTo(self.nameLabel);
//    make.width.equalTo(@40);
//    make.bottom.equalTo(self.methodButton.mas_top).offset(@-4);
//  }];
//
//  [self.levelLabel updateConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.tagLabel);
//    make.left.equalTo(self.tagLabel.mas_right);
//    make.right.equalTo(self.sexLabel.mas_left);
//    make.bottom.equalTo(self.tagLabel);
//  }];
//
//  [self.sexLabel updateConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.tagLabel);
//    make.right.offset(@-12);
//    make.width.equalTo(@11);
//    make.bottom.equalTo(self.tagLabel);
//  }];

//  [self.methodButton updateConstraints:^(MASConstraintMaker *make) {
//    make.left.offset(5);
//    make.right.offset(-5);
//    make.bottom.offset(-4);
//    make.height.greaterThanOrEqualTo(@18);
//  }];
}

- (void)layoutSubviews {
  [super layoutSubviews];
//  if (self.cellStyle == XTUserCollectionViewCellStyleTagAndSex) {
//    [self updateTagConstraints];
//  }

  self.sexLabel.layer.masksToBounds = YES;
  self.sexLabel.layer.cornerRadius = 2.f;
}

//- (void)updateTagConstraints {
//  XTUserAccountInfo *tempUserModel = (XTUserAccountInfo *)self.searchUserModel;
//  float levelNameWidth = [tempUserModel.levelName textWidthWithFontSize:9 isBold:NO andHeight:11];
//    
//  float levelWidth = [[NSString stringWithFormat:@"lv%@", tempUserModel.level] textWidthWithFontSize:10 isBold:NO andHeight:11];
//
//  float leadingGap =
//      (self.frame.size.width - levelNameWidth - levelWidth - 11 - 6) / 2;
//
//  [self.tagLabel remakeConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
//    make.left.offset(leadingGap);
//    make.width.equalTo(levelNameWidth);
//    make.bottom.equalTo(self.methodButton.mas_top).offset(@-4);
//  }];
//
//  [self.levelLabel remakeConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.tagLabel);
//    make.left.equalTo(self.tagLabel.mas_right).offset(3);
//    make.width.equalTo(levelWidth);
//    make.bottom.equalTo(self.tagLabel);
//  }];
//
//  [self.sexLabel remakeConstraints:^(MASConstraintMaker *make) {
//    make.centerY.equalTo(self.levelLabel);
//    make.right.offset(-leadingGap);
//    make.width.equalTo(@11);
//    make.height.equalTo(@11);
//  }];
//}

- (void)awakeFromNib {
  self.nameLabel.minimumScaleFactor = 0.5f;
  [self.methodButton.titleLabel setFont:[UIFont systemFontOfSize:11.f]];
  [self configureCellViewsLayout];
  self.isSelected = NO;
}

@end
