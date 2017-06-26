//
//  XTHomePageLikeAndHateCollectionViewCell.m
//  tian
//
//  Created by huhuan on 15/6/26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import "XTHomePageLikeAndHateCollectionViewCell.h"
#import "XTOrderArtist.h"
#import "XTUserHomePageViewController.h"
#import "UIViewController+Extend.h"

@interface XTHomePageLikeAndHateCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *removeButton;

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (nonatomic, strong) XTOrderArtist *orderArtist;

@end

@implementation XTHomePageLikeAndHateCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)configureUserCell:(XTOrderArtist *)artist
              andCellMode:(XTHomePageLikeAndHateCollectionViewMode)cellMode
             andIndexPath:(NSIndexPath *)indexPath;{
    self.orderArtist = artist;
    self.cellIndexPath = indexPath;
    
    [self.headerImageView an_setImageWithURL:[NSURL URLWithString:artist.headImg]];
    self.titleLabel.text = artist.artistName;
    if(cellMode == XTHomePageLikeAndHateCollectionViewModeNormal) {
        self.removeButton.hidden = YES;
    }else if(cellMode == XTHomePageLikeAndHateCollectionViewModeEdit) {
        self.removeButton.hidden = NO;
    }
    
    [self layoutIfNeeded];
    [self.headerImageView layoutIfNeeded];
    
    self.headerImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.headerImageView addGestureRecognizer:singleTap];
}

- (void)handleSingleTap:(id)sender {
    
    XTUserHomePageViewController *controller = [[XTUserHomePageViewController alloc] initWithNibName:@"XTUserHomePageViewController" bundle:nil];
    controller.userID = [NSString stringWithFormat:@"%@",@(self.orderArtist.artistId)];
    controller.type = XTUserHomePageTypeArtist;
    controller.userType = XTAccountCommon;
    [[UIViewController topViewController] pushViewController:controller animated:YES];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
    
}

- (IBAction)removeClick:(id)sender {
    if(self.removeClickBlock) {
        self.removeClickBlock(self.orderArtist, self.cellIndexPath);
    }

}

@end
