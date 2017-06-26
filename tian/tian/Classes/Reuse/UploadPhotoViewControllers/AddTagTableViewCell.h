//
//  AddTagTableViewCell.h
//  tian
//
//  Created by 曹亚云 on 15-5-26.
//  Copyright (c) 2015年 尚毅 杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKKTagWriteView.h"
@protocol AddTagCellDelegate <NSObject>
@optional
- (void)clickAddTagBtn:(UIButton *)button;
- (void)tagWriteView:(HKKTagWriteView *)view didRemoveTag:(NSString *)tag;
@end

@interface AddTagTableViewCell : UITableViewCell
@property (nonatomic, strong) HKKTagWriteView *tagView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) id<AddTagCellDelegate> delegate;
@property (nonatomic, strong) UIButton *addTagBtn;
@property (nonatomic, assign) BOOL isUnableEdit;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andType:(BOOL)type;
@end
