//
//  XTArtistFollowCollectionViewCell.m
//  tian
//
//  Created by huhuan on 15/6/15.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTVFollowCollectionViewCell.h"
#import "XTOrderArtist.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"
#import "XTUserStore.h"

@interface XTVFollowCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sexImageView;

@property (nonatomic, weak) IBOutlet UIImageView *contentImageView1;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView2;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView3;
@property (nonatomic, weak) IBOutlet UIImageView *contentImageView4;

@property (nonatomic, weak) IBOutlet UIButton *followButton;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) XTOrderArtist *searchArtistModel;

@end

@implementation XTVFollowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
}

- (IBAction)followButtonClick:(id)sender {
    self.isSelected = !(self.isSelected);
    if (self.buttonClick) {
        self.buttonClick(self.searchArtistModel, self.isSelected);
    }
    [self changeButtonStatus];
}

- (void)configureArtistCell:(XTOrderArtist *)artistModel {

    self.searchArtistModel = artistModel;
    self.nameLabel.text = self.searchArtistModel.artistName;
    [self.headerImageView an_setImageWithURL:[NSURL URLWithString:self.searchArtistModel.headImg]];
    
    for(int i = 0; i < [artistModel.pics count]; i++) {
        UIImageView *imageView = (UIImageView *)[self valueForKey:[NSString stringWithFormat:@"contentImageView%@",@(i+1)]];
        [imageView an_setImageWithURL:[NSURL URLWithString:artistModel.pics[i][@"image"]]];
    }
    
    self.isSelected = artistModel.follow;
    [self changeButtonStatus];
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];

}

- (void)handleSingleTap:(id)sender {
    
    if(self.searchArtistModel.artistId == [[XTUserStore sharedManager].user.userID longLongValue]) {
        return;
    }
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.searchArtistModel.artistId)];
    controller.type = XTUserHomePageTypeHis;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)changeButtonStatus {
    if (self.isSelected) {
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

@end
