//
//  XTHeadSetTableViewCell.h
//  StarPicture
//
//  Created by 曹亚云 on 15-3-13.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
@protocol HeadSetViewDelegate <NSObject>
@required
- (void)clickHeadImageBtn:(UIButton *)button;
@end

@interface XTHeadSetTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *headImageBtn;
@property (nonatomic, weak) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, assign)id<HeadSetViewDelegate>delegate;
- (IBAction)clickBtn:(UIButton *)button;
@end
